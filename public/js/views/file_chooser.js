/*global define, ace, console */
define([
  'jquery',
  'underscore',
  'backbone'
  ], function ($, _, Backbone) {
    'use strict';

    var FileChooserView = Backbone.View.extend({

    // Instead of generating a new element, bind to the existing skeleton of
    // the dialog.
    el: '#welcome',

    events: {
      'click #go_edit': 'render',
      'change #sample_files': 'changedSample',
      'click #loadHarp button.btn-primary': 'load'
    },

    sampleFile: undefined,

    initialize: function () {
      _.bindAll(this, "fileChanged", "onSamples", "changedSample");
    },

    render: function () {
      $.ajax({
        type: "GET",
        url: "/api/v1/sample"
      }).done(this.onSamples);
    },

    onSamples: function(data) {
      var select = $("#sample_files").empty();
      $.each(data.results, function(index, file) {
        select.append($('<option>', { value : file.name })
          .text(file.name));
      });
      console.log("Got data: ", data);
    },

    changedSample: function (evt) {
      this.sampleFile = evt.target.value;
    },

    fileChanged: function () {
      this.model.set("content", "newfile");
    },

    load: function () {
      this.model.set("content", this.editor.getValue());
    }
  });

  return FileChooserView;
});
