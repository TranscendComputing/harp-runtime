/*global $:true, editor:true, console:true, annyang:true */
(function(){
  "use strict";
  // Add a camel case method to strings.
  String.prototype.toCamelCase = function(){
    return this.replace(/(\-[a-z])/g, function($1){return $1.toUpperCase().replace('-','');});
  };

}());
