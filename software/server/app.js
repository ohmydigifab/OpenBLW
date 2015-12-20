process.chdir(__dirname);

var OpenPilot = require('./openpilot.js');
var child_process = require('child_process');
var async = require('async');
var fs = require("fs");

var op = new OpenPilot();
async.waterfall([ function(callback) {// connect to openpilot
	op.init(function() {
		callback(null);
	});
}, function(callback) {// connect to openpilot
	op.connect(function() {
		callback(null);
	});
}, function(callback) {// start up websocket server
	child_process.exec('sh ./sh/init_servo.sh');

	var server = require("http").createServer(function(req, res) {
		res.writeHead(200, {
			"Content-Type" : "text/html"
		});
		var output = fs.readFileSync("./www/index.html", "utf-8");
		res.end(output);
	}).listen(9001);

	var io = require("socket.io").listen(server);

	var roll = 0.0;
	var pitch = 0.0;
	var yaw = 0.0;
	var throttle = 0.0;
	var accel_factor = 0.02;

	io.sockets.on("connection", function(socket) {

		socket.on("connected", function() {
		});

		socket.on("ping", function(time) {
			op.getObject("ActuatorCommand", function(actuatorCommand) {
				op.getObject("FlightStatus", function(flightStatus) {
					op.getObject("FlightTelemetryStats", function(flightTelemetryStats) {
						socket.emit("pong", {
							ActuatorCommand : actuatorCommand,
							FlightStatus : flightStatus,
							FlightTelemetryStats : flightTelemetryStats
						});
					});
				});
			});
		});

		socket.on("accelerate_throttle", function(value, callback) {
			throttle += accel_factor * value;
			if (throttle < 0.0) {
				throttle = 0.0;
			} else if (throttle > 1.0) {
				throttle = 1.0;
			}
			op.setThrust(throttle, function() {
				callback();
			});
		});

		socket.on("connectFcm", function(callback) {
			op.connect(function() {
				callback();
			});
		});

		socket.on("setArm", function(bln, callback) {
			throttle = 0.0;
			op.setArm(bln, function(res) {
				callback(res);
			});
		});

		socket.on("setControlValue", function(value, callback) {
			function degToOne(value) {
				value = ((value % 360) + 360) % 360;// 0-360
				return value / 360;// 0-1
			}
			value.Throttle = value.Throttle / 100;
			value.Roll = degToOne(value.Roll);
			value.Pitch = degToOne(value.Pitch);
			value.Yaw = degToOne(value.Yaw);
			op.setControlValue(value, function(res) {
				callback(res);
			});
		});

		socket.on("getControlValue", function(callback) {
			op.getObject("ManualControlCommand", function(obj) {
				callback(obj);
			}, true);
		});

		socket.on("setActuatorValue", function(value, callback) {
			op.setActuator(value, function(res) {
				callback(res);
			});
		});

		socket.on("getActuatorValue", function(callback) {
			op.getObject("ActuatorCommand", function(obj) {
				callback(obj);
			}, true);
		});

		socket.on("getAttitude", function(callback) {
			op.getObject("AttitudeState", function(obj) {
				callback(obj);
			}, true);
		});

		socket.on("disconnect", function() {
		});

	});
	callback(null);
}, function(callback) {// start up websocket server
	console.log("poling start!");
	var step = 0;
	setInterval(function() {
		step++;
		switch (step % 2) {
		case 0:
			op.getObject("FlightStatus", function(res) {
				// console.log(res);
			}, true);
			break;
		case 1:
			op.getObject("FlightTelemetryStats", function(res) {
				// console.log(res);
			}, true);
			break;
		}
	}, 1000);
	callback(null);
} ], function(err, result) {
});