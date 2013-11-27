/*global define*/
define([
  'jquery',
  'backbone',
  'js/common'
], function ($, Backbone, Common) {
  'use strict';

  var Router = Backbone.Router.extend({
    routes: {
      '*filter': 'setFilter'
    },

    setFilter: function (param) {
    }
  });

  return Router;
});
