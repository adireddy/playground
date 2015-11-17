package webworkers;

import js.Browser;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;
import js.html.VideoElement;
import js.html.ImageElement;
import js.html.Worker;

class WorkerMainJson {

	var _videoElement:VideoElement;
	var _videoCover:ImageElement;
	var _canvas:CanvasElement;
	var _context:CanvasRenderingContext2D;

	var _worker:Worker;
	var _worker2:Worker;

	public function new() {
		_worker = new js.html.Worker("js/VideoData.js");
		_worker.onmessage = _processWorkerData;

		_worker2 = new js.html.Worker("js/LoadJson.js");
		_worker2.onmessage = _processWorkerJsonData;
		_worker2.postMessage("load");

		_videoElement = Browser.document.createVideoElement();
		_videoElement.id = "videoWheel";
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

		Browser.document.body.appendChild(_videoElement);
		Browser.document.body.appendChild(_canvas);
	}

	function _processWorkerData(e) {
		if (e.data == "GET_DATA") {
			_context.drawImage(_videoElement, 0, 200, 480, 50, 0, 0, 480, 50);
			_worker.postMessage(_context.getImageData(0, 4, 400, 1).data);
		}
		else trace(e.data);

		_worker2.postMessage("AccessOrder");
	}

	function _processWorkerJsonData(e) {
		trace(e.data);
	}

	static function main() {
		new WorkerMainJson();
	}
}