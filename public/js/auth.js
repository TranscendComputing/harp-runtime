/*global $:true, CryptoJS:true, _:true, console:true */
(function(){
  "use strict";

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
    return CryptoJS.HmacSHA256(this.stringToSign(datetime), secret);
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
    parts.push(this.pathname());
    parts.push(this.request.search());
    parts.push(this.canonicalHeaders() + '\n');
    parts.push(this.signedHeaders());
    parts.push(this.request.body);
    return parts.join('\n');
  }     
});

}());
