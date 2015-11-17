package webworkers;

import haxe.Json;
import js.html.XMLHttpRequest;

class LoadJson {

	var _data:Dynamic;

	public static function __init__() {
		untyped __js__("self.onmessage = webworkers_LoadJson.prototype._messageHandler");
	}

	function _messageHandler(event) {
		switch(event.data) {
			case "load":
				var request = new XMLHttpRequest();
				request.onreadystatechange = function() {
					if (request.readyState == 4) {
						if (request.status == 200) {
							_data = Json.parse(request.responseText);
							untyped __js__("self").postMessage(_data);
						}
					}
				}

				request.open("GET", "../resources/checkstyle-config.json", true);
				request.send(null);

			default:
				for (i in 0 ... _data.checks.length) {
					if (_data.checks[i].type == event.data) {
						untyped __js__("self").postMessage(_data.checks[i]);
						break;
					}
				}
		}
	}
}