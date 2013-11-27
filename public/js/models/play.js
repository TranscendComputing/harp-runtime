/*global define*/
define([
  'underscore',
  'backbone',
  'backbone-relational-shim'
], function (_, Backbone) {
  'use strict';

  var HarpPlay = Backbone.RelationalModel.extend({
    // Default attributes for this script execution
    defaults: {
      harp_id: '',
      current_line: 0,
      completed: false
    },

    // Toggle the `completed` state of the play.
    finish: function () {
      this.save({
        completed: true
      });
    }
  });

  return HarpPlay;
});
