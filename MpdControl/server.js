var app = require('http').createServer()
  , io = require('socket.io').listen(app)
  , crypto = require('crypto')
  , net = require('net')
  , fs = require('fs')
  , config = require('./config');



io.set('origins', config.origins);

/*interface MpdMessage {
    command: string;
    identifier: number;
    params: any;
}*/
function Queue(socket, mpdconn) {
    this.socket = socket;
    this.mpdconn = mpdconn;
    this.queue = [];
    this.locked = true;
    this.started = false;
    this.dataqueue = "";
    var self = this;
    this.stop = false;
    this.msg = {callback: function () { self.socket.emit('ready'); }};
    this.mpdconn.on('data', function (data) {
        self.dataqueue = data.toString();
        var splitarray = self.dataqueue.split("\n");
        var lastele = splitarray.pop();
        if (lastele.replace(/^\s+|\s+$/g, '').length == 0)
            lastele = splitarray.pop();
        lastele = lastele.replace(/^\s+|\s+$/g, '').split(" ")[0];
        if (lastele != "OK" && lastele != "ACK")
            return;
        self.dataqueue = self.dataqueue.replace(/^\s+|\s+$/g, '');
        self.msg.callback(self.dataqueue);
        self.msg = null;
        self.dataqueue = "";
        self.locked = false;
    });
}
Queue.prototype.add = function (command, callback) {
    this.queue.push({"command": command, "callback": callback});
}
Queue.prototype.start = function () {
    if (this.started)
        return;
    this.started = true;
    var self = this;
    setTimeout(function () { self.handleQueue(); }, 50);
}
Queue.prototype.handleQueue = function() {
    var self = this;
    if (!this.stop)
        setTimeout(function () { self.handleQueue(); }, 50);
    if (self.locked || self.queue.length == 0)
        return;
    self.locked = true;
    self.msg = self.queue.pop();
    self.mpdconn.write(self.msg.command+"\n");
}
io.set('log level', config.io.loglevel);
io.sockets.on('connection', function (socket) {
    var user = null;
    socket.on('login', function(userdata, callback) {
        try {
            var decipher = crypto.createDecipher(config.crypto.algo, config.crypto.key);
            var jsondata = decipher.update(userdata.data, 'base64', 'utf8');
            jsondata = jsondata+decipher.final('utf8');
            for (var i=0; (jsondata[i] == '|' && i < jsondata.length); i++);
            if (jsondata.length == i)
                throw "Empty";
            var data = JSON.parse(jsondata.substring(i));
            if (new Date(data.valid) < new Date()) {
                throw "Old login data";
            }
            user = data.user;
            var newroles = {};
            for (var i=0; i < user[config.roleattr].length; i++) {
                var role = JSON.parse(user[config.roleattr][i]);
                for (var rolename in role) {
                    if (role.hasOwnProperty(rolename))
                        newroles[rolename] = role[rolename];
                }
            }
            user.roles = newroles;
        } catch (err) {
            console.log(err);
            var response = {state: "error", msg: "Something went wrong"};
            socket.emit("mpdResult", response);
            return;
        }
        var response = {state: "ok", hosts: Object.keys(user.roles)};
        callback(response);
        socket.on('connectto', function(host, callback) {
            if (user.roles[host] == null) {
                response = {state: "error", msg: "You do not have access to "+host};
                callback(response);
                return;
            }
            mpdconn = net.connect({port: 6600, host: user.roles[host].mpdhost}, function() {
                queue = new Queue(socket, mpdconn);
                queue.add("password "+user.roles[host].mpdpass, function (res) { callback({state: "ok"}); });
                queue.start();

                socket.on('mpd', function (data) {
                    /*if (data.command == "password") {
                        var response = data;
                        queue.add("password "+data.params, function (res) {
                            //if (res.replace(/^\s+|\s+$/g, '') == "OK")
                                response.params = res;
                            socket.emit("mpdResult", response);
                        });
                        return;
                    } else*/ if (data.command == "getcover") {
                        queue.add("currentsong", function (res) {
                            var response = data;
                            var filename = parseMpdArray(res)['file'];
                            filename = filename.replace(/[^\/]*$/, "cover.jpg");
                            filename = config.coverbasepath+"/"+filename;
                            fs.readFile(filename, function (err, data) {
                                if (err)
                                    response.params = null;
                                else {
                                    response.params = "data:image/jpg;base64,"+new Buffer(data).toString('base64');
                                }
                                socket.emit("mpdResult", response);

                                response = null;
                                data = null;
                            });

                        });
                        return;
                    } else {
                        var response = data;
                        if (data.params == null)
                            data.params = "";
                        if (typeof data.params != "string")
                            data.params = data.params.toString();
                        queue.add(data.command+" "+data.params, function (res) {
                            //if (res.replace(/^\s+|\s+$/g, '') == "OK")
                                response.params = res;
                            socket.emit("mpdResult", response);
                        });
                        return;
                    }
                });
                socket.on('disconnect', function() {
                    queue.stop = true;
                    mpdconn.end("close");
                    mpdconn = null;
                    queue = null;
                });
            });
        });
    });
});
function parseMpdArray(data) {
    var lines = data.split("\n");
    var resdata = {};
    for (var i = 0; i < lines.length; i++) {
        if (lines[i].replace(/^\s+|\s+$/g, '') == "OK" || lines[i].replace(/^\s+|\s+$/g, '') == "")
            continue;
        lines[i].substring(0, lines[i].indexOf(":") - 1);
        resdata[lines[i].substring(0, lines[i].indexOf(":"))] = lines[i].substring(lines[i].indexOf(":") + 1).replace(/^\s+|\s+$/g, '');
    }
    return resdata;
}
app.listen(config.port);
