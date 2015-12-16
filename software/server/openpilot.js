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
		connect : function(callback_connected) {
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
			}, function(callback) {
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
			}, function(callback) {
				objMan.getObject("ManualControlCommand.Metadata", function(obj) {
					Uavtalk.UavtalkObjMetadataHelper.setFlightAccess(obj, Uavtalk.UavtalkObjMetadataHelper.UAVObjAccessType.ACCESS_READONLY);
					Uavtalk.UavtalkObjMetadataHelper.setFlightTelemetryUpdateMode(obj, Uavtalk.UavtalkObjMetadataHelper.UAVObjUpdateMode.UPDATEMODE_MANUAL);
					objMan.updateObject(obj);
					callback(null);
				});
			}, function(callback) {
				callback(null, obj);
			} ], function(err, result) {
				callback_connected();
			});
		},
		setArm : function(bArm, callback) {
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
					obj.Arming = bArm ? FlightModeSettingsArmingOptions.FLIGHTMODESETTINGS_ARMING_ALWAYSARMED : FlightModeSettingsArmingOptions.FLIGHTSTATUS_ARMED_DISARMED;
					objMan.updateObject(obj);
					self.getArm(callback);
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
		setThrottle : function(value, callback) {
			objMan.getObject("ManualControlCommand", function(obj) {
				if (obj == null) {
					callback(null);
					return;
				}
				obj.Throttle = value;
				obj.Connected = 1;
				objMan.updateObject(obj);
				callback(obj);
			});
		},
		setRoll : function(value, callback) {
			objMan.getObject("ManualControlCommand", function(obj) {
				if (obj == null) {
					callback(null);
					return;
				}
				obj.Roll = value;
				obj.Connected = 1;
				objMan.updateObject(obj);
				callback(obj);
			});
		},
		setPitch : function(value, callback) {
			objMan.getObject("ManualControlCommand", function(obj) {
				if (obj == null) {
					callback(null);
					return;
				}
				obj.Pitch = value;
				obj.Connected = 1;
				objMan.updateObject(obj);
				callback(obj);
			});
		},
		setYaw : function(value, callback) {
			objMan.getObject("ManualControlCommand", function(obj) {
				if (obj == null) {
					callback(null);
					return;
				}
				obj.Yaw = value;
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
		getAttitude : function(callback) {
			objMan.getObject("AttitudeState", function(obj) {
				callback(obj);
			}, true);
		},
		getFlightStatus : function(callback) {
			objMan.getObject("FlightStatus", function(obj) {
				callback(obj);
			}, true);
		},
		getManualControlSettings : function(callback) {
			objMan.getObject("ManualControlSettings", function(obj) {
				callback(obj);
			}, true);
		}
	};
	return self;
}

module.exports = OpenPilot;