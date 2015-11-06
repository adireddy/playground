package webworkers;

import js.Browser;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;
import haxe.Timer;
import js.html.VideoElement;
import js.html.ImageElement;
import js.html.Element;
import js.html.Worker;

class WorkerMain {

	var _wrapper:Element;
	var _videoElement:VideoElement;
	var _videoCover:ImageElement;

	var _timer:Timer;
	var _canvas:CanvasElement;
	var _context:CanvasRenderingContext2D;

	var _worker:Worker;

	public function new() {
		_worker = new js.html.Worker("js/WorkerScript.js");
		_worker.onmessage = function(e) {
			trace(e.data);
		}

		_videoElement = Browser.document.createVideoElement();
		_videoElement.id = "videoWheel";
		_videoElement.style.position = "absolute";
		_videoElement.style.top = "0px";
		_videoElement.autoplay = true;
		_videoElement.loop = true;

		//_videoElement.width = 800;
		//_videoElement.height = 600;
		//_videoElement.src = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8";

		_videoElement.src = "../retina.mp4";

		_wrapper = Browser.document.createDivElement();
		Browser.document.body.appendChild(_wrapper);
		_wrapper.appendChild(_videoElement);

		_canvas = Browser.document.createCanvasElement();
		_canvas.id = "video_canvas";
		_canvas.style.position = "absolute";
		_canvas.style.backgroundColor = "#FFFFFF";
		_canvas.style.left = "0px";
		_canvas.style.top = "500px";
		_canvas.width = 400;
		_canvas.height = 16;
		_wrapper.appendChild(_canvas);

		_context = _canvas.getContext2d();

		_videoElement.play();
		_timer = new Timer(1000);
		_timer.run = _getBarCodeData;
	}

	function _getBarCodeData() {
		if (_videoElement.paused || _videoElement.ended) return;
		_context.drawImage(_videoElement, 0, 200, 480, 50, 0, 0, 480, 50);

		_worker.postMessage(_context.getImageData(0, 4, 400, 1).data);
	}

	static function main() {
		new WorkerMain();
	}
}