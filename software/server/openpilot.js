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

	return {
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
					console.log("data");
					console.log(data);
					sp.write(data, function() {
						sp.drain();
					});
				};
				sp.on("data", objMan.input_stream);
				sp.on("open", function() {
					callback(null);
				});
			}, function(callback) {
				objMan.requestObject("FlightTelemetryStats", function(obj) {
					callback(null, obj);
				});
			}, function(obj, callback) {
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
					objMan.requestObject("FlightTelemetryStats", connection);
				};
				connection(obj);
			}, function(callback) {
				callback(null);
			} ], function(err, result) {
				callback_connected();
			});
		},
		setArm : function(bArm, callback) {
			objMan.requestObject("FlightModeSettings", function(obj) {
				if (obj == null || obj.Arming == null) {
					callback(false);
					return;
				}
				obj.Arming = bArm ? FlightModeSettingsArmingOptions.FLIGHTMODESETTINGS_ARMING_ALWAYSARMED : FlightModeSettingsArmingOptions.FLIGHTSTATUS_ARMED_DISARMED;
				objMan.updateObject(obj);
				callback(true);
			});
		},
		getArm : function(callback) {
			objMan.requestObject("FlightStatus", function(obj) {
				if (obj == null || obj.Armed == null) {
					callback(false);
					return;
				}
				callback(obj.Armed);
			});
		},
		setRoll : function(value, callback) {
			objMan.requestObject("ManualControlCommand", function(obj) {
				if (obj == null) {
					callback(false);
					return;
				}
				obj.Roll = value;
				objMan.updateObject(obj);
				callback(true);
			});
		},
		setPitch : function(value, callback) {
			objMan.requestObject("ManualControlCommand", function(obj) {
				if (obj == null) {
					callback(false);
					return;
				}
				obj.Pitch = value;
				objMan.updateObject(obj);
				callback(true);
			});
		},
		setYaw : function(value, callback) {
			objMan.requestObject("ManualControlCommand", function(obj) {
				if (obj == null) {
					callback(false);
					return;
				}
				obj.Yaw = value;
				objMan.updateObject(obj);
				callback(true);
			});
		},
		setThrust : function(value, callback) {
			objMan.requestObject("ManualControlCommand", function(obj) {
				if (obj == null) {
					callback(false);
					return;
				}
				obj.Thrust = value;
				objMan.updateObject(obj);
				callback(true);
			});
		},
		getAttitude : function(callback) {
			objMan.requestObject("AttitudeState", function(obj) {
				callback(obj);
			});
		},
		getFlightStatus : function(callback) {
			objMan.requestObject("FlightStatus", function(obj) {
				callback(obj);
			});
		},
		getManualControlSettings : function(callback) {
			objMan.requestObject("ManualControlSettings", function(obj) {
				callback(obj);
			});
		}
	}
}

module.exports = OpenPilot;