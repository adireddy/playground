(function (console) { "use strict";
var webworkers_WorkerMainJson = function() {
	this._worker = new Worker("js/VideoData.js");
	this._worker.onmessage = $bind(this,this._processWorkerData);
	this._worker2 = new Worker("js/LoadJson.js");
	this._worker2.onmessage = $bind(this,this._processWorkerJsonData);
	this._worker2.postMessage("load");
	var _this = window.document;
	this._videoElement = _this.createElement("video");
	this._videoElement.id = "videoWheel";
	this._videoElement.style.position = "absolute";
	this._videoElement.style.top = "0px";
	this._videoElement.autoplay = true;
	this._videoElement.loop = true;
	this._videoElement.src = "../retina.mp4";
	var _this1 = window.document;
	this._canvas = _this1.createElement("canvas");
	this._canvas.style.position = "absolute";
	this._canvas.style.backgroundColor = "#FFFFFF";
	this._canvas.style.left = "0px";
	this._canvas.style.top = "500px";
	this._canvas.width = 400;
	this._canvas.height = 16;
	this._context = this._canvas.getContext("2d",null);
	window.document.body.appendChild(this._videoElement);
	window.document.body.appendChild(this._canvas);
};
webworkers_WorkerMainJson.main = function() {
	new webworkers_WorkerMainJson();
};
webworkers_WorkerMainJson.prototype = {
	_processWorkerData: function(e) {
		if(e.data == "GET_DATA") {
			this._context.drawImage(this._videoElement,0,200,480,50,0,0,480,50);
			this._worker.postMessage(this._context.getImageData(0,4,400,1).data);
		} else console.log(e.data);
		this._worker2.postMessage("AccessOrder");
	}
	,_processWorkerJsonData: function(e) {
		console.log(e.data);
	}
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
webworkers_WorkerMainJson.main();
})(typeof console != "undefined" ? console : {log:function(){}});
