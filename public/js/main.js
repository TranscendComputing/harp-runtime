/*global $:true, editor:true, console:true, annyang:true */
(function(){
  "use strict";
  $("#voice_toggle").on("click", function(evt) {
    // Start listening.
    if (annyang) {
      if ($(evt.target).parent().hasClass("active")) {
        $(evt.target).parent().removeClass("active");
        annyang.abort();
        console.debug("Disabling voice control.");
        return false;
      }
      annyang.start();
      annyang.debug();
      $(evt.target).parent().addClass("active");
      console.debug("Enabling voice control.");
    }
  });

}());
