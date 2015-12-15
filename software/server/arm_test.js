process.chdir(__dirname);

var OpenPilot = require('./openpilot.js');
var child_process = require('child_process');
var async = require('async');
var fs = require("fs");

var op = new OpenPilot();
async.waterfall([ function(callback) {// connect to openpilot
	op.connect(function() {
		callback(null);
	});
}, function(callback) {// start up websocket server
	op.setArm(true, function(res) {
		console.log(res);
		callback(null);
	});
}, function(callback) {// start up websocket server
	op.getFlightStatus(function(res) {
		console.log(res);
		callback(null);
	});
}, function(callback) {// start up websocket server
	op.getManualControlSettings(function(res) {
		console.log(res);
		callback(null);
	});
} ], function(err, result) {
	console.log(result);
});