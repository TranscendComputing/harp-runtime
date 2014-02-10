/*global define:true, APISigner:true, Spinner:true, document:true, alert:true, console:true */
define([
  'jquery',
  'underscore',
  'backbone'
  ], function ($, _, Backbone) {
    'use strict';

    var DebuggerView = Backbone.View.extend({

    el: '#control_panel_frame',

    events: {
      'click .change_lifecycle': 'changeLifecycle',
      'click a.invoke': 'play',
      'click a#step': 'playStep',
      'click a#continue': 'playConfinue'
    },

    break_pattern: /.*l:(\d+):.*$/,

    lifecycle: "create",

    initialize: function (options) {
      this.current_line = 0;
      this.spinner = undefined;
      this.spinner_opts = {
        lines: 13, // The number of lines to draw
        length: 20, // The length of each line
        width: 10, // The line thickness
        radius: 30, // The radius of the inner circle
        corners: 1, // Corner roundness (0..1)
        rotate: 0, // The rotation offset
        direction: 1, // 1: clockwise, -1: counterclockwise
        color: '#FFFACD', // #rgb or #rrggbb
        speed: 1, // Rounds per second
        trail: 60, // Afterglow percentage
        shadow: false, // Whether to render a shadow
        hwaccel: false, // Whether to use hardware acceleration
        className: 'spinner', // The CSS class to assign to the spinner
        zIndex: 2e9, // The z-index (defaults to 2000000000)
        top: 'auto', // Top position relative to parent in px
        left: 'auto' // Left position relative to parent in px
      };

      this.parentModel = options.parentModel;
      this.editSession = options.editSession;
      this.$lifecycle = this.$("#lifecycle");
    },

    render: function () {
    },

    changeLifecycle: function(evt) {
      this.lifecycle = $(evt.target).text();
      this.$lifecycle.text(this.lifecycle);
      this.lifecycle = this.lifecycle.toLowerCase();
    },

    play: function() {
      var index = 0, breakpoint, args = "";

      $.each(this.editSession.getBreakpoints(), _.bind(function(line, val) {
        if (val && (!breakpoint || line < breakpoint)) {
          if (this.current_line < line+1) {
              breakpoint = line+1;
          }
        }
      }, this));
      if (breakpoint) {
        args = "&break=" + breakpoint;
      }
      this.invokeLifecycle(this.lifecycle, this.parentModel.get("content"), args);
    },

    playStep: function() {
      var args = "&step=" + this.current_token;
      this.invokeLifecycle(this.lifecycle, this.parentModel.get("content"), args);
    },

    playConfinue: function() {
      var args = "&continue=" + this.current_token;
      this.invokeLifecycle(this.lifecycle, this.parentModel.get("content"), args);
    },

    invokeLifecycle: function(lifecycle, data, args) {
      args = args + "&mock=y";
      if (lifecycle !== "create") {
          if (!this.harp_id) {
            alert("Harp ID is required for lifecycle '" + lifecycle + "'.");
            return;
          }
          lifecycle = lifecycle + "/" + this.harp_id;
      }
      var access = $("#access").val(), secret = $("#secret").val(), credentials = {}, tm = new Date();

      APISigner.sign("POST", "/api/v1/harp-debug/"+lifecycle, "", data);
      credentials.access=access;
      credentials.secret=secret;
      var datetime = tm.getFullYear()+":"+(tm.getMonth()+1)+":"+tm.getDate()+":"+tm.getHours()+":"+tm.getMinutes()+":" + tm.getSeconds()+":"+tm.getMilliseconds();
	  var signature = APISigner.signature(credentials, datetime);
	  signature = encodeURIComponent(signature);
	  console.log("signature="+signature);
      return this.invoke("/api/v1/harp-debug/"+lifecycle+"?access="+access+
	      "&harp_sig="+signature+"&auth=default_creds&datetime="+datetime+args, data);
    },

    invoke: function(url, data) {
      var id, spin_target;
      $("#script_output").html("");
      $("#working").show();
      if (!this.spinner) {
          spin_target = document.getElementById("working");
          this.spinner = new Spinner(this.spinner_opts).spin(spin_target);
      }else{
          this.spinner.spin(document.getElementById("working"));
      }

      $.ajax({
          type: "POST",
          url: url,
          data: data,
          contentType: "application/x-harp; charset=utf-8",
          dataType: "json",
          context: this,
          success: function (data) {
            this.processResponse(data);
          },
          failure: function (errMsg) {
            console.error(errMsg);
          }
      }).always(function() {
          this.spinner.stop();
          $("#working").hide();
      });
    },

    prettyResult: function(data) {
      var msg = "", verb, line;
      if (data.hasOwnProperty('invoked')) {
          $.each(data.results, _.bind(function (index, val) {
              console.debug("Got:", index, val);
              $.each(val, _.bind(function (action, desc) {
                  console.debug("Got desc:", desc);
                  if (/create|update|destroy|break/.test(action)) {
                      verb = action.toCamelCase();
                      if (verb !== "break" && verb !== "error") {
                          verb += (verb.charAt(verb.length-1) === 'e')? "d":"ed";
                      }
                      msg += verb + ": " + desc + ".\n";
                  }
                  if (action === "output") {
                      // indicate some output is available from command.
                      console.log("Found output.");
                  }
                  if (action === "harp_id") {
                      msg += "Harp ID: " + desc + "\n";
                      this.setHarpId(desc);
                  }
                  if (action === "token") {
                      this.clearExecutionLine();
                      this.setExecutionLine(desc);
                  }
                  if (action === "end") {
                      this.clearExecutionLine();
                  }
              }, this));
          }, this));
      }
      if (data.hasOwnProperty('error')) {
          if (data.hasOwnProperty('description')) {
              msg += data.description + "\n";
          }
      }
      return msg;
    },

    processResponse: function(data) {
      var text = this.prettyResult(data);
      $("#script_output").text(text);
    },

    setHarpId: function (harp_id) {
      this.harp_id = harp_id;
      $("#harpId").val(harp_id);
    },

    setExecutionLine: function (token) {
      var line = parseInt(this.break_pattern.exec(token)[1], 10);
      if (line !== undefined) {
        this.current_line = line+1;
        this.current_token = token;
        this.editSession.addGutterDecoration(line, "current_line");
      }
    },

    clearExecutionLine: function () {
      this.editSession.removeGutterDecoration(this.current_line-1, "current_line");
      this.current_line = 0;
      this.current_token = undefined;
    }

  });

  return DebuggerView;
});
