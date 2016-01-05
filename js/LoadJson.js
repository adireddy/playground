(function (console) { "use strict";
var webworkers_LoadJson = function() { };
webworkers_LoadJson.prototype = {
	_messageHandler: function(event) {
		var _g1 = this;
		var _g = event.data;
		switch(_g) {
		case "load":
			var request = new XMLHttpRequest();
			request.onreadystatechange = function() {
				if(request.readyState == 4) {
					if(request.status == 200) {
						_g1._data = JSON.parse(request.responseText);
						self.postMessage(_g1._data);
					}
				}
			};
			request.open("GET","../resources/checkstyle-config.json",true);
			request.send(null);
			break;
		default:
			var _g2 = 0;
			var _g11 = this._data.checks.length;
			while(_g2 < _g11) {
				var i = _g2++;
				if(this._data.checks[i].type == event.data) {
					self.postMessage(this._data.checks[i]);
					break;
				}
			}
		}
	}
};
self.onmessage = webworkers_LoadJson.prototype._messageHandler;
})(typeof console != "undefined" ? console : {log:function(){}});
