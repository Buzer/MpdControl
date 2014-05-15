var io = require('socket.io').listen(7915);
var net = require('net');
var fs = require('fs');

/*var basepath = "D:\\packer\\test\\";
fs.readFile(basepath+"00ab6cda-d3b6-4458-a3e1-3962963a3ea1/c03326e0-71ce-472b-8890-4312fab4e555/test.txt", function(err, data) {
    console.log(data);
});*/
var basepath = "M:\\Touhou lossless music collection";
fs.readFile(basepath+"/[ほねとかわとがはなれるおと]/2010.10.31 東方双奏録 [M3-10秋]/cover.jpg", function(err, data) {
    console.log(data);
});