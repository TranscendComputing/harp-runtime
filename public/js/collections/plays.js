/*global define*/
define([
  'underscore',
  'backbone',
  'js/models/play'
], function (_, Backbone, HarpPlay) {
  'use strict';

  var HarpPlays = Backbone.Collection.extend({
    model: HarpPlay
  });

  return HarpPlays;
});
