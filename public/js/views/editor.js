/*global define, ace */
define([
  'jquery',
  'underscore',
  'backbone',
  'backbone.babysitter',
  'js/views/debugger'
  ], function ($, _, Backbone, unused, DebuggerView) {
    'use strict';

    var EditorView = Backbone.View.extend({

    // Instead of generating a new element, bind to the existing skeleton of
    // the editor already present in the HTML.
    el: '#editor_all',

    events: {
    },

    initialize: function () {
      this.editor = ace.edit("editor");
      this.current_line = 0;
      this.editor.setTheme("ace/theme/vibrant_ink");
      //this.editor.setTheme("ace/theme/textmate");
      this.editor.getSession().setMode("ace/mode/ruby");
      this.model.set("content", this.editor.getValue());
      this.childViews = new Backbone.ChildViewContainer();
      this.childViews.add(new DebuggerView({parentModel: this.model,
                                            editSession: this.editor.session
                                          }));
      _.bindAll(this, "marginClick", "documentChanged");
      this.editor.on("guttermousedown", this.marginClick);
      this.editor.on("change", this.documentChanged);
    },

    render: function () {
    },

    marginClick: function(e) {
      var target = e.domEvent.target, row = e.getDocumentPosition().row;
      if (target.className.indexOf("ace_gutter-cell") === -1) {
        e.editor.session.clearBreakpoint(row);
        return;
      }
      if (e.clientX > 25 + target.getBoundingClientRect().left) {
        return;
      }
      if (target.className.indexOf("breakpoint") === -1) {
        e.editor.session.setBreakpoint(row, " breakpoint");
        e.stop();
      } else {
        e.editor.session.clearBreakpoint(row);
        return;
      }
    },

    documentChanged: function () {
      this.model.set("content", this.editor.getValue());
    }
  });

  return EditorView;
});
