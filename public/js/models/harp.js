/*global define*/
define([
  'underscore',
  'backbone',
  'backbone-relational-shim',
  'js/models/play',
  'js/collections/plays'
], function (_, Backbone, unused, HarpPlay, HarpPlays) {
  'use strict';

  var HarpScript = Backbone.RelationalModel.extend({
    // Default attributes for this script execution
    defaults: {
      content: ''
    },
    relations: [{
      type: Backbone.HasMany,
      key: 'plays',
      relatedModel: HarpPlay,
      collectionType: HarpPlays,
      reverseRelation: {
        key: 'playOf',
        includeInJSON: 'id'
      }
    }]

  });

  return HarpScript;
});
