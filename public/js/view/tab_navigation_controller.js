// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'model/location'], function(_, Backbone, Location) {
    var TabNavigationController;
    return TabNavigationController = (function(_super) {

      __extends(TabNavigationController, _super);

      function TabNavigationController() {
        return TabNavigationController.__super__.constructor.apply(this, arguments);
      }

      TabNavigationController.prototype.initialize = function(tab_number) {
        _.bindAll(this);
        this.number = tab_number;
        return this.createTabs();
      };

      TabNavigationController.prototype.createTabs = function() {
        var i, position, tab, zIndex, _i, _results;
        _results = [];
        for (i = _i = 0; _i < 4; i = ++_i) {
          tab = document.createElement("DIV");
          tab.className = "tab_top_dark";
          tab.id = "top" + i;
          position = i * 58 - 15;
          tab.style.marginLeft = position.toString() + "px";
          zIndex = 100 - i - 1;
          tab.style.zIndex = zIndex.toString();
          if (i === 0) {
            tab.className = "tab_top_first";
          }
          if (i === this.number) {
            tab.style.zIndex = "101";
            tab.className = "tab_top_light";
          }
          _results.push($("#tab_top").append(tab));
        }
        return _results;
      };

      return TabNavigationController;

    })(Backbone.View);
  });

}).call(this);
