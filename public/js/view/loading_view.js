// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'util/util', 'text!template/loading.html'], function(_, Backbone, Util, LoadingTemplate) {
    var LoadingView;
    LoadingView = (function(_super) {

      __extends(LoadingView, _super);

      function LoadingView() {
        return LoadingView.__super__.constructor.apply(this, arguments);
      }

      LoadingView.prototype.el = ".loading_container";

      LoadingView.prototype.template = _.template(LoadingTemplate);

      LoadingView.prototype.initialize = function() {
        return this._preRender();
      };

      LoadingView.prototype._preRender = function() {
        var hi;
        this.$el.html(this.template);
        hi = 
        function (word) {
          var opts = {
            lines: 13, // The number of lines to draw
            length: 0, // The length of each line
            width: 6, // The line thickness
            radius: 13, // The radius of the inner circle
            corners: 1, // Corner roundness (0..1)
            rotate: 0, // The rotation offset
            color: 'white', // #rgb or #rrggbb
            speed: 1.3, // Rounds per second
            trail: 39, // Afterglow percentage
            shadow: false, // Whether to render a shadow
            hwaccel: false, // Whether to use hardware acceleration
            className: 'spinner', // The CSS class to assign to the spinner
            zIndex: 2e9, // The z-index (defaults to 2000000000)
            // Left position relative to parent in px
          };
          var target = document.getElementById('spinner');
          var spinner = new Spinner(opts).spin(target);
        };
        return hi("hallo");
      };

      LoadingView.prototype.empty = function() {
        return this.$el.html("");
      };

      return LoadingView;

    })(Backbone.View);
    return LoadingView;
  });

}).call(this);
