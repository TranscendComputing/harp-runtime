/*global require:true, $:true, console:true */
require([
  'backbone',
  'js/models/harp',
  'js/views/file_chooser',
  'js/routers/router',
  'js/common'
  ], function (Backbone, HarpScript, FileChooserView, Router, Common) {
    "use strict";
    // Initialize the chooser view
    var file_chooser = new FileChooserView();
  });
