(function (console) { "use strict";
var HxOverrides = function() { };
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
var Std = function() { };
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe_Timer.prototype = {
	run: function() {
	}
};
var webworkers_Main2 = function() {
	var _this = window.document;
	this._videoElement = _this.createElement("video");
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
	this._timer = new haxe_Timer(1000);
	this._timer.run = $bind(this,this._getBarCodeData);
	window.document.body.appendChild(this._videoElement);
	window.document.body.appendChild(this._canvas);
	this._loadJson();
};
webworkers_Main2.main = function() {
	new webworkers_Main2();
};
webworkers_Main2.prototype = {
	_getBarCodeData: function() {
		this._context.drawImage(this._videoElement,0,200,480,50,0,0,480,50);
		this._data = [];
		this._bits = [];
		this._bytes = [];
		this._dataBytes = [];
		var _contextData = this._context.getImageData(0,4,400,1).data;
		var r = 0;
		var g = 0;
		var b = 0;
		var pixel = 0;
		var pixelCount = 0;
		var _g1 = 0;
		var _g = _contextData.length;
		while(_g1 < _g) {
			var i = _g1++;
			r += _contextData[pixel];
			g += _contextData[pixel + 1];
			b += _contextData[pixel + 2];
			pixel++;
			pixelCount++;
			if(pixelCount == 8) {
				if(r / 8 > 128) r = 1; else r = 0;
				if(g / 8 > 128) g = 1; else g = 0;
				if(b / 8 > 128) b = 1; else b = 0;
				this._bits.push(r);
				this._bits.push(g);
				this._bits.push(b);
				r = 0;
				g = 0;
				b = 0;
				pixelCount = 0;
			}
		}
		var bits8 = "";
		var dataByte = "";
		var bitIndex = 0;
		var byteIndex = 0;
		var _g11 = 0;
		var _g2 = this._bits.length;
		while(_g11 < _g2) {
			var i1 = _g11++;
			bits8 += this._bits[i1];
			dataByte += this._bits[i1];
			byteIndex++;
			if(byteIndex == 8) {
				this._bytes.push(bits8);
				byteIndex = 0;
				bits8 = "";
			}
			bitIndex++;
			if(bitIndex == 64 || bitIndex == 128 || bitIndex == 136 || bitIndex == 200 || bitIndex == 232) {
				this._dataBytes.push(dataByte);
				dataByte = "";
			}
		}
		var _g12 = 0;
		var _g3 = this._dataBytes.length;
		while(_g12 < _g3) {
			var d = _g12++;
			var data = 0;
			var binaryData = 0;
			var _g31 = 0;
			var _g21 = this._dataBytes[d].length;
			while(_g31 < _g21) {
				var x = _g31++;
				var pow2 = Math.pow(2,this._dataBytes[d].length - 1 - x);
				data += Std.parseInt(this._dataBytes[d].charAt(x)) * pow2;
			}
			this._data.push(data);
		}
		var binaryBytes = [];
		var _g4 = 0;
		while(_g4 < 25) {
			var d1 = _g4++;
			var binaryData1 = 0;
			var _g22 = 0;
			var _g13 = this._bytes[d1].length;
			while(_g22 < _g13) {
				var x1 = _g22++;
				var pow21 = Math.pow(2,this._bytes[d1].length - 1 - x1);
				binaryData1 += Std.parseInt(this._bytes[d1].charAt(x1)) * pow21;
			}
			binaryBytes.push(binaryData1);
		}
		console.log(this._data);
		this._getJsonData("AccessOrder");
	}
	,_loadJson: function() {
		var _g = this;
		var request = new XMLHttpRequest();
		request.onreadystatechange = function() {
			if(request.readyState == 4) {
				if(request.status == 200) {
					_g._jsonData = JSON.parse(request.responseText);
					console.log(_g._jsonData);
				}
			}
		};
		request.open("GET","resources/checkstyle-config.json",true);
		request.send(null);
	}
	,_getJsonData: function(type) {
		var _g1 = 0;
		var _g = this._jsonData.checks.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._jsonData.checks[i].type == type) {
				console.log(this._jsonData.checks[i]);
				break;
			}
		}
	}
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
webworkers_Main2.main();
})(typeof console != "undefined" ? console : {log:function(){}});
