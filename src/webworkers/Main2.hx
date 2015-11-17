package webworkers;

import js.html.XMLHttpRequest;
import js.html.Uint8ClampedArray;
import js.Browser;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;
import haxe.Timer;
import js.html.VideoElement;
import js.html.ImageElement;

class Main2 {

	var _videoElement:VideoElement;
	var _videoCover:ImageElement;

	var _timer:Timer;
	var _canvas:CanvasElement;
	var _context:CanvasRenderingContext2D;

	var _bits:Array<Int>;
	var _bytes:Array<String>;
	var _dataBytes:Array<String>;
	var _data:Array<Float>;

	public function new() {
		_videoElement = Browser.document.createVideoElement();
		_videoElement.style.position = "absolute";
		_videoElement.style.top = "0px";
		_videoElement.autoplay = true;
		_videoElement.loop = true;
		//_videoElement.src = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8";
		_videoElement.src = "../retina.mp4";
		//_videoElement.src = "resources/sample.mp4";

		_canvas = Browser.document.createCanvasElement();
		_canvas.style.position = "absolute";
		_canvas.style.backgroundColor = "#FFFFFF";
		_canvas.style.left = "0px";
		_canvas.style.top = "500px";
		_canvas.width = 400;
		_canvas.height = 16;
		_context = _canvas.getContext2d();

		_timer = new Timer(1000);
		_timer.run = _getBarCodeData;

		Browser.document.body.appendChild(_videoElement);
		Browser.document.body.appendChild(_canvas);

		_loadJson();
	}

	function _getBarCodeData() {
		_context.drawImage(_videoElement, 0, 200, 480, 50, 0, 0, 480, 50);
		_data = [];
		_bits = [];
		_bytes = [];
		_dataBytes = [];

		var _contextData:Uint8ClampedArray = _context.getImageData(0, 4, 400, 1).data;

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

		trace(_data);
	}

	function _loadJson() {
		var request = new XMLHttpRequest();
		request.onreadystatechange = function() {
			if (request.readyState == 4) {
				if (request.status == 200) {
					trace(request.responseText);
				}
			}
		}

		request.open("GET", "resources/checkstyle-config.json", true);
		request.send(null);
	}

	static function main() {
		new Main2();
	}
}