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
var webworkers_VideoData = function() { };
webworkers_VideoData.prototype = {
	_messageHandler: function(event) {
		var _contextData = event.data;
		var _bits = [];
		var _bytes = [];
		var _dataBytes = [];
		var _data = [];
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
				_bits.push(r);
				_bits.push(g);
				_bits.push(b);
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
		var _g2 = _bits.length;
		while(_g11 < _g2) {
			var i1 = _g11++;
			bits8 += _bits[i1];
			dataByte += _bits[i1];
			byteIndex++;
			if(byteIndex == 8) {
				_bytes.push(bits8);
				byteIndex = 0;
				bits8 = "";
			}
			bitIndex++;
			if(bitIndex == 64 || bitIndex == 128 || bitIndex == 136 || bitIndex == 200 || bitIndex == 232) {
				_dataBytes.push(dataByte);
				dataByte = "";
			}
		}
		var _g12 = 0;
		var _g3 = _dataBytes.length;
		while(_g12 < _g3) {
			var d = _g12++;
			var data = 0;
			var binaryData = 0;
			var _g31 = 0;
			var _g21 = _dataBytes[d].length;
			while(_g31 < _g21) {
				var x = _g31++;
				var pow2 = Math.pow(2,_dataBytes[d].length - 1 - x);
				data += Std.parseInt(_dataBytes[d].charAt(x)) * pow2;
			}
			_data.push(data);
		}
		var binaryBytes = [];
		var _g4 = 0;
		while(_g4 < 25) {
			var d1 = _g4++;
			var binaryData1 = 0;
			var _g22 = 0;
			var _g13 = _bytes[d1].length;
			while(_g22 < _g13) {
				var x1 = _g22++;
				var pow21 = Math.pow(2,_bytes[d1].length - 1 - x1);
				binaryData1 += Std.parseInt(_bytes[d1].charAt(x1)) * pow21;
			}
			binaryBytes.push(binaryData1);
		}
		self.postMessage(_data);
	}
};
self.onmessage = webworkers_VideoData.prototype._messageHandler;
var timer = new haxe_Timer(1000);
timer.run = function() {
	self.postMessage("GET_DATA");
};
})(typeof console != "undefined" ? console : {log:function(){}});
