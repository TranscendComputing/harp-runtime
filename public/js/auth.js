/*global $:true, CryptoJS:true, _:true, console:true */

//(function(){
//  "use strict";

	var APISigner = _.extend({
	  constructor: function APISigner() {
	  },

	  sign: function (method, pathname, params, body) {
		this.method = method;
		this.pathname = pathname;
		this.params = params;
		this.body = body;
	  },

	  signature: function (credentials, datetime) {
		var secret = credentials.secret;
		var tosign = this.stringToSign(datetime);
		var signed = CryptoJS.HmacSHA256(tosign, secret);
		return signed.toString(CryptoJS.enc.Base64);
	  },

	  stringToSign: function (datetime) {
		var parts = [];
		parts.push('HARP-HMAC-SHA256');
		parts.push(datetime);
		parts.push(this.canonicalString());
		return parts.join('\n');
	  },

	  canonicalString: function () {
		var parts = [];
		parts.push(this.method);
	//    parts.push(this.pathname());
	//    parts.push(this.request.search());
	//    parts.push(this.canonicalHeaders() + '\n');
	//    parts.push(this.signedHeaders());
		parts.push(this.body);
		return parts.join('\n');
	  }     
	});
//}());

