process.chdir(__dirname);

var OpenPilot = require('./openpilot.js');
var child_process = require('child_process');
var async = require('async');
var fs = require("fs");
var express = require('express');
var v4l2camera = require("node-vrcam");
var cam = new v4l2camera.Camera("/dev/video0");
var piblaster = require('pi-blaster.js');

var op = new OpenPilot();
async.waterfall([ function(callback) {// exit sequence
	process.on('SIGINT', function() {
		console.log("led shutting down");
		piblaster.setPwm(40, 0);
		piblaster.setPwm(41, 0);
		// console.log("camera shutting down");
		// cam.stop();
		console.log("exit process done");
		process.exit();
	})
	callback(null);
}, function(callback) {// led startup
	console.log("led starting up");
	piblaster.setPwm(40, 0);
	piblaster.setPwm(41, 0);
	callback(null);
}, function(callback) {// camera startup
	console.log("camera starting up");
	cam.start();
	cam.capture(function loop() {
		cam.capture(loop);
	});
	callback(null);
}, function(callback) {// connect to openpilot
	op.init(function() {
		callback(null);
	});
}, function(callback) {// connect to openpilot
	op.connect(function() {
		callback(null);
	});
}, function(callback) {// start up websocket server
	child_process.exec('sh ./sh/init_servo.sh');

	var veicle_attitude = {
		// -180 - 180
		Roll : 0,
		// -180 - 180
		Pitch : 0,
		// -180 - 180
		Yaw : 0
	};
	
	var server = require("http").createServer(function(req, res) {
		var url = req.url.split("?")[0];
		var query = req.url.split("?")[1];
		console.log(url);
		console.log(query);
		if (url == '/vr.jpeg') {
			fs.readFile('/tmp/capture.jpeg', function(err, data) {
				if (err) {
					res.writeHead(404);
					res.end();
					console.log("404");
				} else {
					res.writeHead(200, {
						'Content-Type' : 'image/jpeg',
						'Content-Length' : data.length,
						'Cache-Control' : 'private, no-cache, no-store, must-revalidate',
						'Expires' : '-1',
						'Pragma' : 'no-cache',
					});
					res.end(data);
					console.log("200");
				}
				//console.log(veicle_attitude);
				cam.setRotation(-veicle_attitude.Roll,-veicle_attitude.Pitch,-veicle_attitude.Yaw);
				cam.toJpegAsEquirectangular();
			});
		} else {
			res.writeHead(200, {
				"Content-Type" : "text/html"
			});
			var output = fs.readFileSync("./www/index.html", "utf-8");
			res.end(output);
		}
	}).listen(9001);

	var io = require("socket.io").listen(server);

	var yaw_offset = 0;
	var controlValue = {
		// 0% - 100%
		Throttle : 0,
		// -180 - 180
		Roll : 0,
		// -180 - 180
		Pitch : 0,
		// -180 - 180
		Yaw : 0
	};
	var accel_factor = 0.02;

	function degToOne(value) {
		value = value % 180;// -180 <-> +180
		return value / 180;// -1 <-> +1
	}
	function degToRad(value) {
		return Math.PI * value / 180;
	}
	function radToDeg(value) {
		return 180 * value / Math.PI;
	}
	function clone(src) {
		var dst = {}
		for ( var k in src) {
			dst[k] = src[k];
		}
		return dst;
	}

	var lastThrottle = 0;
	var controlValueUpdating = false;
	op.onAttitudeStateChanged(function(attitude) {
		veicle_attitude = attitude;
		if (controlValue.Throttle > 0 || lastThrottle != 0) {
			if (controlValueUpdating) {
				return;
			}
			controlValueUpdating = true;

			var value = {
				// 0 - 1
				Throttle : 0,
				// -1 - 1
				Roll : 0,
				// -1 - 1
				Pitch : 0,
				// -1 - 1
				Yaw : 0
			};

			var length = Math.sqrt(controlValue.Roll * controlValue.Roll + controlValue.Pitch * controlValue.Pitch);
			var angle = radToDeg(Math.atan2(controlValue.Roll, controlValue.Pitch));
			var roll = 0;
			var pitch = 0;
			if (attitude.Roll < -90 || attitude.Roll > 90) {
				angle -= attitude.Yaw - yaw_offset;
				roll = length * -Math.sin(degToRad(angle));
				pitch = length * Math.cos(degToRad(angle));
			} else {
				angle += attitude.Yaw - yaw_offset;
				roll = length * Math.sin(degToRad(angle));
				pitch = length * Math.cos(degToRad(angle));
			}

			value.Throttle = controlValue.Throttle / 100;
			value.Roll = degToOne(roll);
			value.Pitch = degToOne(pitch);
			value.Yaw = degToOne(controlValue.Yaw);
			op.setControlValue(value, function(res) {
				controlValueUpdating = false;
			});
			lastThrottle = value.Throttle;
		}
	});

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
			controlValue.Throttle += accel_factor * value;
			if (controlValue.Throttle < 0.0) {
				controlValue.Throttle = 0.0;
			} else if (controlValue.Throttle > 1.0) {
				controlValue.Throttle = 1.0;
			}
			op.setThrust(controlValue.Throttle, function() {
				callback();
			});
		});

		socket.on("connectFcm", function(callback) {
			op.connect(function() {
				callback();
			});
		});

		socket.on("setArm", function(bln, callback) {
			controlValue.Throttle = 0.0;
			op.setArm(bln, function(res) {
				callback(res);
			});
		});

		socket.on("calibrateLevel", function(callback) {
			var LEVEL_SAMPLES = 100;
			op.calibrateLevel(LEVEL_SAMPLES, function(res) {
				op.getObject("AttitudeState", function(attitude) {
					yaw_offset = attitude.Yaw;
					console.log("yaw_offset : " + yaw_offset);
					callback(res);
				});
			});
		});

		socket.on("setControlValue", function(value, callback) {
			controlValue = value;
			callback();
		});

		socket.on("getControlValue", function(callback) {
			callback(controlValue);
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
				var dst = clone(obj);
				dst.Yaw -= yaw_offset;
				callback(dst);
			}, true);
		});

		socket.on("setUdpProxyEnabled", function(value) {
			op.setUdpProxyEnabled(value);
		});

		socket.on("setUpperLedValue", function(value) {
			piblaster.setPwm(40, value / 100.0);
		});

		socket.on("setBottomLedValue", function(value) {
			piblaster.setPwm(41, value / 100.0);
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