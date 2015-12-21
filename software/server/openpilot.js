var async = require('async');
var Uavtalk = require("uavtalk");
var EventEmitter = require('events').EventEmitter;
var SerialPort = require("serialport").SerialPort;

function OpenPilot(board_type, com_port, definition_path) {
	var BOARD_TYPE = board_type === undefined ? "cc3d" : board_type;
	var DEFINITION_PATH = definition_path === undefined ? "./openpilot_definitions" : definition_path;
	var COM_PORT = com_port === undefined ? "/dev/ttyAMA0" : com_port;

	var objMan = new Uavtalk.ObjectManager(DEFINITION_PATH);
	var gtsObj;
	var ftsObj;

	var STATUS_DISCONNECTED = 0;
	var STATUS_HANDSHAKEREQ = 1;
	var STATUS_HANDSHAKEACK = 2;
	var STATUS_CONNECTED = 3;

	var FlightModeSettingsArmingOptions = {
		FLIGHTMODESETTINGS_ARMING_ALWAYSDISARMED : 0,
		FLIGHTMODESETTINGS_ARMING_ALWAYSARMED : 1,
		FLIGHTMODESETTINGS_ARMING_ROLLLEFT : 2,
		FLIGHTMODESETTINGS_ARMING_ROLLRIGHT : 3,
		FLIGHTMODESETTINGS_ARMING_PITCHFORWARD : 4,
		FLIGHTMODESETTINGS_ARMING_PITCHAFT : 5,
		FLIGHTMODESETTINGS_ARMING_YAWLEFT : 6,
		FLIGHTMODESETTINGS_ARMING_YAWRIGHT : 7,
		FLIGHTMODESETTINGS_ARMING_ACCESSORY0 : 8,
		FLIGHTMODESETTINGS_ARMING_ACCESSORY1 : 9,
		FLIGHTMODESETTINGS_ARMING_ACCESSORY2 : 10
	};
	var ManualControlSettingsChannelGroupsOptions = {
		MANUALCONTROLSETTINGS_CHANNELGROUPS_PWM : 0,
		MANUALCONTROLSETTINGS_CHANNELGROUPS_PPM : 1,
		MANUALCONTROLSETTINGS_CHANNELGROUPS_DSMMAINPORT : 2,
		MANUALCONTROLSETTINGS_CHANNELGROUPS_DSMFLEXIPORT : 3,
		MANUALCONTROLSETTINGS_CHANNELGROUPS_SBUS : 4,
		MANUALCONTROLSETTINGS_CHANNELGROUPS_GCS : 5,
		MANUALCONTROLSETTINGS_CHANNELGROUPS_OPLINK : 6,
		MANUALCONTROLSETTINGS_CHANNELGROUPS_NONE : 7
	};

	function getBlankGtsObj() {
		var gtsObj = {};
		gtsObj.TxDataRate = 0;
		gtsObj.TxBytes = 0;
		gtsObj.TxFailures = 0;
		gtsObj.TxRetries = 0;
		gtsObj.RxDataRate = 0;
		gtsObj.RxBytes = 0;
		gtsObj.RxFailures = 0;
		gtsObj.RxSyncErrors = 0;
		gtsObj.RxCrcErrors = 0;
		gtsObj.Status = 0;
		gtsObj.name = "GCSTelemetryStats";
		gtsObj.object_id = objMan.getObjectId(gtsObj.name);
		return gtsObj;
	}

	var self = {
		debug : false,
		init : function(callback_completed) {
			async.waterfall([ function(callback) {
				objMan.init(function() {
					callback(null);
				});
			}, function(callback) {
				var sp = new SerialPort(COM_PORT, {
					baudrate : 57600
				});
				objMan.output_stream = function(data) {
					if (self.debug) {
						console.log("output");
						console.log(data);
					}
					sp.write(data, function() {
						sp.drain();
					});
				};
				sp.on("data", function(data) {
					if (self.debug) {
						console.log("input");
						console.log(data);
					}
					objMan.input_stream(data)
				});
				sp.on("open", function() {
					callback(null);
				});
			} ], function(err, result) {
				callback_completed();
			});
		},
		connect : function(callback_completed) {
			async.waterfall([ function(callback) {
				gtsObj = getBlankGtsObj();
				var connection = function(obj) {
					ftsObj = obj;
					console.log(ftsObj);
					if (ftsObj.Status == STATUS_DISCONNECTED) {
						gtsObj.Status = STATUS_HANDSHAKEREQ;
						console.log(gtsObj);
						objMan.updateObject(gtsObj);
					} else if (ftsObj.Status == STATUS_HANDSHAKEACK) {
						gtsObj.Status = STATUS_CONNECTED;
						console.log(gtsObj);
						objMan.updateObject(gtsObj);
					} else if (ftsObj.Status == STATUS_CONNECTED) {
						console.log("connected");
						callback(null);
						return;
					}
					objMan.getObject("FlightTelemetryStats", connection, true);
				};
				objMan.getObject("FlightTelemetryStats", connection, true);
			} ], function(err, result) {
				callback_completed();
			});
		},
		setArm : function(bArm, callback) {
			objMan.getObject("ManualControlCommand.Metadata", function(obj) {
				Uavtalk.UavtalkObjMetadataHelper.setFlightAccess(obj, Uavtalk.UavtalkObjMetadataHelper.UAVObjAccessType.ACCESS_READONLY);
				Uavtalk.UavtalkObjMetadataHelper.setFlightTelemetryUpdateMode(obj, Uavtalk.UavtalkObjMetadataHelper.UAVObjUpdateMode.UPDATEMODE_MANUAL);
				objMan.updateObject(obj);
				console.log("ManualControlCommand overide init");
				objMan.getObject("ManualControlCommand", function(obj) {
					if (obj == null) {
						callback(null);
						return;
					}
					obj.Throttle = -1;
					obj.Roll = 0;
					obj.Pitch = 0;
					obj.Yaw = 0;
					obj.FlightModeSwitchPosition = 0;
					obj.Connected = 1;
					objMan.updateObject(obj);
					objMan.getObject("FlightModeSettings", function(obj) {
						if (obj == null || obj.Arming == null) {
							callback(null);
							return;
						}
						obj.Arming = bArm ? FlightModeSettingsArmingOptions.FLIGHTMODESETTINGS_ARMING_ALWAYSARMED : FlightModeSettingsArmingOptions.FLIGHTMODESETTINGS_ARMING_ALWAYSDISARMED;
						objMan.updateObject(obj);
						self.getArm(callback);
					});
				});
			});
		},
		getArm : function(callback) {
			objMan.getObject("FlightStatus", function(obj) {
				if (obj == null || obj.Armed == null) {
					callback(false);
					return;
				}
				callback(obj.Armed);
			}, true);
		},
		calibrateLevel : function(LEVEL_SAMPLES, callback) {
			var AttitudeSettingsBiasCorrectGyroOptions = {
				ATTITUDESETTINGS_BIASCORRECTGYRO_FALSE : 0,
				ATTITUDESETTINGS_BIASCORRECTGYRO_TRUE : 1
			};
			LEVEL_SAMPLES = LEVEL_SAMPLES ? LEVEL_SAMPLES : 100;
			var count = 0;
			var x = 0;
			var y = 0;
			var z = 0;
			var mementoAttitudeSettings = null;
			var getSample = function() {
				objMan.getObject("AccelState", function(obj) {
					count++;
					console.log("calibrateLevel : " + count);
					x += obj.x;
					y += obj.y;
					z += obj.z;
					if (count == LEVEL_SAMPLES) {
						x /= LEVEL_SAMPLES;
						y /= LEVEL_SAMPLES;
						z /= LEVEL_SAMPLES;
						objMan.getObject("AccelGyroSettings", function(obj) {
							obj.gyrobiasIdx0 += x;
							obj.gyrobiasIdx1 += y;
							obj.gyrobiasIdx2 += z;
							console.log(obj);
							objMan.updateObject(obj);
							objMan.updateObject(mementoAttitudeSettings);
							callback(true);
						}, true);
					} else {
						setTimeout(getSample, 100);
					}
				}, true);
			};
			objMan.getObject("AttitudeSettings", function(obj) {
				mementoAttitudeSettings = JSON.parse(JSON.stringify(obj));
				obj.BiasCorrectGyro = AttitudeSettingsBiasCorrectGyroOptions.ATTITUDESETTINGS_BIASCORRECTGYRO_FALSE;
				obj.BoardRotationIdx0 = 0;
				obj.BoardRotationIdx1 = 0;
				obj.BoardRotationIdx2 = 0;
				objMan.updateObject(obj);
				console.log(mementoAttitudeSettings);
				console.log(obj);
				getSample();
			}, true);
		},
		setControlValue : function(value, callback) {
			objMan.getObject("ManualControlCommand", function(obj) {
				if (obj == null) {
					callback(null);
					return;
				}
				obj.Throttle = value.Throttle;
				obj.Thrust = value.Throttle;
				obj.Roll = value.Roll;
				obj.Pitch = value.Pitch;
				obj.Yaw = value.Yaw;
				obj.Connected = 1;
				objMan.updateObject(obj);
				callback(obj);
			});
		},
		setFlightModeSwitchPosition : function(value, callback) {
			objMan.getObject("ManualControlCommand", function(obj) {
				if (obj == null) {
					callback(null);
					return;
				}
				obj.FlightModeSwitchPosition = value;
				obj.Connected = 1;
				objMan.updateObject(obj);
				callback(obj);
			});
		},
		getObject : function(name, callback, blnRenew) {
			objMan.getObject(name, function(obj) {
				callback(obj);
			}, blnRenew);
		}
	};
	return self;
}

module.exports = OpenPilot;