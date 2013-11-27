/*global require:true, $:true, ace:true, console:true, Spinner:true, Opentip:true, document:true */
require([
  'backbone',
  'js/models/harp',
  'js/views/editor',
  'js/routers/router',
  'js/common'
  ], function (Backbone, HarpScript, EditorView, Router, Common) {
    "use strict";
    // Initialize routing and start Backbone.history()
    var router, editorview, harp;
    router = new Router();
    Backbone.history.start();

    harp = new HarpScript();
    // Initialize the application view
    editorview = new EditorView({model: harp});
  });
