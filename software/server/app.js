process.chdir(__dirname);

var OpenPilot = require('./openpilot.js');
var child_process = require('child_process');
var async = require('async');
var fs = require("fs");

var op = new OpenPilot();
async.waterfall([ function(callback) {//connect to openpilot
	op.connect(function() {
		callback(null);
	});
}, function(callback) {//start up websocket server
	child_process.exec('sh ./sh/init_servo.sh');

	var server = require("http").createServer(function(req, res) {
	     res.writeHead(200, {"Content-Type":"text/html"});
	     var output = fs.readFileSync("./www/index.html", "utf-8");
	     res.end(output);
	}).listen(9001);

	var io = require("socket.io").listen(server);

	var roll = 0.0;
	var pitch = 0.0;
	var yaw = 0.0;
	var throttle = 0.0;
	var accel_factor = 0.02;

	io.sockets.on("connection", function (socket) {

		socket.on("connected", function () {
		});
		  
		socket.on("ping", function (time) {
			socket.emit("pong");
		});
		
		socket.on("accelerate_throttle", function (value, callback) {
			throttle += accel_factor*value;
			if(throttle < 0.0)
			{
				throttle = 0.0;
			}
			else if(throttle > 1.0)
			{
				throttle = 1.0;
			}
			op.setThrust(throttle, function(){
				callback();
			});
		});
		
		socket.on("setArm", function (bln, callback) {
			throttle = 0.0;
			op.setArm(bln, function(){
				callback();
			});
		});
		
		socket.on("setRoll", function (value, callback) {
			op.setRoll(value, function(){
				callback();
			});
		});
		
		socket.on("setPitch", function (value, callback) {
			op.setPitch(value, function(){
				callback();
			});
		});
		
		socket.on("setYaw", function (value, callback) {
			op.setYaw(value, function(){
				callback();
			});
		});
		
		socket.on("getAttitude", function (callback) {
			op.getAttitude(function(obj){
				callback(obj);
			});
		});
		
		socket.on("disconnect", function () {
		});
	}
} ], function(err, result) {
});