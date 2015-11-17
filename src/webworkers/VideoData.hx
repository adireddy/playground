package webworkers;

import haxe.Timer;
import js.html.Uint8ClampedArray;

class VideoData {

	public static function __init__() {
		untyped __js__("self.onmessage = webworkers_VideoData.prototype._messageHandler");

		var timer = new Timer(1000);
		timer.run = function() untyped __js__("self").postMessage("GET_DATA");
	}

	function _messageHandler(event) {
		var _contextData:Uint8ClampedArray = event.data;
		var _bits:Array<Int> = [];
		var _bytes:Array<String> = [];
		var _dataBytes:Array<String> = [];
		var _data:Array<Float> = [];

		var r:Int = 0;
		var g:Int = 0;
		var b:Int = 0;

		var pixel = 0;
		var pixelCount = 0;
		for (i in 0 ... _contextData.length) {
			r += _contextData[pixel];
			g += _contextData[pixel + 1];
			b += _contextData[pixel + 2];
			pixel++;
			pixelCount++;

			if (pixelCount == 8) {
				r = ((r / 8) > 128) ? 1 : 0;
				g = ((g / 8) > 128) ? 1 : 0;
				b = ((b / 8) > 128) ? 1 : 0;
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
		for (i in 0 ... _bits.length) {
			bits8 += _bits[i];
			dataByte += _bits[i];
			byteIndex++;

			if (byteIndex == 8) {
				_bytes.push(bits8);
				byteIndex = 0;
				bits8 = "";
			}

			bitIndex++;
			if (bitIndex == 64 || bitIndex == 128 || bitIndex == 136 || bitIndex == 200 || bitIndex == 232) {
				_dataBytes.push(dataByte);
				dataByte = "";
			}
		}

		for (d in 0 ... _dataBytes.length) {
			var data:Float = 0;
			var binaryData:Float = 0;
			for (x in 0 ... _dataBytes[d].length) {
				var pow2 = Math.pow(2, _dataBytes[d].length - 1 - x);
				data += Std.parseInt(_dataBytes[d].charAt(x)) * pow2;
			}
			_data.push(data);
		}

		var binaryBytes:Array<Float> = [];
		for (d in 0 ... 25) {
			var binaryData:Float = 0;
			for (x in 0 ... _bytes[d].length) {
				var pow2 = Math.pow(2, _bytes[d].length - 1 - x);
				binaryData += Std.parseInt(_bytes[d].charAt(x)) * pow2;
			}
			binaryBytes.push(binaryData);
		}

		untyped __js__("self").postMessage(_data);
	}
}