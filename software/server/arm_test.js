process.chdir(__dirname);

var OpenPilot = require('./openpilot.js');
var child_process = require('child_process');
var async = require('async');
var fs = require("fs");

var op = new OpenPilot();
op.debug = process.argv[2];
async.waterfall([ function(callback) {// connect to openpilot
	op.init(function() {
		callback(null);
	});
}, function(callback) {// connect to openpilot
	op.connect(function() {
		callback(null);
	});
}, function(callback) {// start up websocket server
	op.setArm(true, function(res) {
		console.log(res);
		callback(null);
	});
}, function(callback) {// start up websocket server
	var step = 0;
	var throttle = -1;
	setInterval(function() {
		step++;
		switch (step % 7) {
		case 0:
			op.getObject("FlightStatus", function(res) {
				console.log(res);
			});
			break;
		case 1:
			op.getObject("FlightTelemetryStats", function(res) {
				console.log(res);
			});
			break;
		case 2:
			op.getObject("ActuatorCommand", function(res) {
				console.log(res);
			});
			break;
		case 3:
			op.getObject("ActuatorSettings", function(res) {
				console.log(res);
			});
			break;
		case 4:
			op.getObject("ManualControlCommand", function(res) {
				console.log(res);
			});
			break;
		case 5:
			op.getObject("ManualControlSettings", function(res) {
				console.log(res);
			});
			break;
		case 6:
			throttle += 0.01;
			op.setThrottle(throttle, function(res) {
				console.log(res);
			});
			break;
		}
	}, 1000);
	callback(null);
} ], function(err, result) {
	console.log(result);
});