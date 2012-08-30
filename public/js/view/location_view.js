// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'util/util', 'model/location', 'text!template/current_location.html'], function(_, Backbone, Util, Location, CurrentLocationTemplate) {
    var LocationView;
    LocationView = (function(_super) {

      __extends(LocationView, _super);

      function LocationView() {
        return LocationView.__super__.constructor.apply(this, arguments);
      }

      LocationView.prototype.el = "#my_current_location";

      LocationView.prototype.template = _.template(CurrentLocationTemplate);

      LocationView.prototype.initialize = function(options) {
        _.bindAll(this);
        this.router = window.EngApp.appRouter;
        this.location = new Location;
        this.location.set("id", options.locationId);
        this.locationPromise = this.location.fetch();
        this.model.on('locating', this.locating);
        this.model.on('setLocation:failed getLocationName:failed', this.fail);
        this.model.on("change:country change:city", this.success);
        return this.model.locate();
      };

      LocationView.prototype.render = function() {
        return this.$el.html(this.template({
          model: this.model.toJSON(),
          location: this.location.toJSON()
        }));
      };

      LocationView.prototype.locating = function() {
        this.model.set("message", "Calculating your location...");
        return this.render();
      };

      LocationView.prototype.fail = function() {
        this.model.set("message", "Sorry, can't get your location. You may have disallowed location requests for this browser");
        return this.render();
      };

      LocationView.prototype.success = function() {
        this.model.set("message", "You are in " + (this.model.get('city')) + ", " + (this.model.get('countryAbbr')));
        this.render();
        return this.updateUserLocation();
      };

      LocationView.prototype.updateUserLocation = function() {
        return this.locationPromise.done(this.getLocationSuccess);
      };

      LocationView.prototype.getLocationSuccess = function() {
        var _this = this;
        if (this.location.get('home')) {
          this.render();
          this.location.set({
            current: "" + (this.model.get('city')) + ", " + (this.model.get('countryAbbr')),
            last_modify: Date.now()
          });
          return this.location.save().done(function() {
            return _this.trigger("curretLocationReady");
          });
        } else {
          return this.jumpToSetHomePage();
        }
      };

      LocationView.prototype.jumpToSetHomePage = function() {
        return this.router.navigate("settings/home", {
          trigger: true
        });
      };

      return LocationView;

    })(Backbone.View);
    return LocationView;
  });

}).call(this);
