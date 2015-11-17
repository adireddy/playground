package webworkers;

import js.html.XMLHttpRequest;

class LoadJson {

	public static function __init__() {
		untyped __js__("self.onmessage = webworkers_LoadJson.prototype._messageHandler");
	}

	function _messageHandler(event) {
		var data = "";
		var request = new XMLHttpRequest();
		request.onreadystatechange = function() {
			if (request.readyState == 4) {
				if (request.status == 200) {
					data = request.responseText;
					untyped __js__("self").postMessage(data);
				}
			}
		}

		request.open("GET", "../resources/checkstyle-config.json", true);
		request.send(null);
	}
}