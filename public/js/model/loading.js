// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone'], function(Backbone) {
    var Loading;
    Loading = (function(_super) {

      __extends(Loading, _super);

      function Loading() {
        return Loading.__super__.constructor.apply(this, arguments);
      }

      Loading.prototype.defaults = {
        message: "",
        duration: 0.6
      };

      return Loading;

    })(Backbone.Model);
    return Loading;
  });

}).call(this);