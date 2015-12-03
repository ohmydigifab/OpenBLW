process.chdir(__dirname);

var child_process = require('child_process');
child_process.exec('sh ./sh/init_servo.sh');

var fs = require("fs");
var server = require("http").createServer(function(req, res) {
     res.writeHead(200, {"Content-Type":"text/html"});
     var output = fs.readFileSync("./www/index.html", "utf-8");
     res.end(output);
}).listen(9001);

var io = require("socket.io").listen(server);

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
		var cmd = 'sh ./sh/set_throttle.sh ' + Math.round(1000+throttle*1000);
		child_process.exec(cmd);
		socket.emit("msg", cmd);
		callback(throttle);
	});
	
	socket.on("arm", function (callback) {
		throttle = 0.0;
		var cmd = 'sh ./sh/arm.sh';
		child_process.exec(cmd);
		socket.emit("msg", cmd);
		callback();
	});
	
	socket.on("disarm", function (callback) {
		throttle = 0.0;
		var cmd = 'sh ./sh/disarm.sh';
		child_process.exec(cmd);
		socket.emit("msg", cmd);
		callback();
	});
	
	 socket.on("disconnect", function () {
	 });
});