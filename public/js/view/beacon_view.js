// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'util/util', 'model/user', 'model/loading', 'model/foursquare_location', 'model/location_collection', 'view/navbar_view', 'view/loading_view', 'view/location_view', 'view/locations_view', 'text!template/beacon.html', 'view/tab_controller'], function(_, Backbone, Util, User, Loading, FourSquareLocation, LocationCollection, NavbarView, LoadingView, LocationView, LocationsView, BeaconTemplate, TabController) {
    var BeaconView;
    BeaconView = (function(_super) {

      __extends(BeaconView, _super);

      function BeaconView() {
        return BeaconView.__super__.constructor.apply(this, arguments);
      }

      BeaconView.prototype.el = "#main";

      BeaconView.prototype.template = _.template(BeaconTemplate);

      BeaconView.prototype.initialize = function() {
        var body, navbarView;
        this.number = 4;
        this.selected = "t0";
        _.bindAll(this);
        this._preRender();
        this.bindEvents();
        this.user = new User;
        this.user.on("change:userName", this.userDataReady);
        body = document.getElementById("body");
        body.className = "0";
        console.log(body);
        return navbarView = new NavbarView({
          model: this.user
        });
      };

      BeaconView.prototype.bindEvents = function() {
        var eventName, events, i, id, _i, _j;
        for (i = _i = 0; _i < 4; i = ++_i) {
          this.$el.undelegate("tab_default" + i);
        }
        eventName = 'createTouch' in document ? 'tap' : 'click';
        events = {};
        for (i = _j = 0; _j < 4; i = ++_j) {
          id = "#t" + i;
          events["" + eventName + " " + id] = "tabSelected";
        }
        return this.delegateEvents(events);
      };

      BeaconView.prototype._preRender = function() {
        this.loadingView = new LoadingView;
        this.loadingView.render();
        return this.render();
      };

      BeaconView.prototype.render = function() {
        this.$el.html(this.template(""));
        return this.createTabs();
      };

      BeaconView.prototype.createTabs = function() {
        var tab_controller;
        return tab_controller = new TabController({
          model: this.number
        });
      };

      BeaconView.prototype.tabSelected = function() {
        var z, zIndex;
        if (!(event.target.id === this.selected || event.target.className === "x_icon" || event.target.className === "tab_default_x")) {
          event.target.className = "tab_bar_selected";
          z = 101;
          document.getElementById(event.target.id).style.zIndex = z.toString();
          zIndex = 100 - this.selected[1] - 1;
          document.getElementById(this.selected).style.zIndex = zIndex.toString();
          if (this.selected === "t0") {
            document.getElementById(this.selected).className = "tab_bar_first";
          } else {
            document.getElementById(this.selected).className = "tab_default";
          }
          this.selected = event.target.id;
          return this.locationsView.updateLocationView(this.selected[1]);
        }
      };

      BeaconView.prototype.userDataReady = function() {
        this.loadingView.empty();
        this.fsLocation = new FourSquareLocation;
        this.locationView = new LocationView({
          model: this.fsLocation,
          locationId: this.user.get("email")
        });
        return this.locationView.on("curretLocationReady", this.renderLocationList);
      };

      BeaconView.prototype.renderLocationList = function() {
        var locationCollection;
        locationCollection = new LocationCollection;
        return this.locationsView = new LocationsView({
          model: locationCollection
        });
      };

      return BeaconView;

    })(Backbone.View);
    return BeaconView;
  });

}).call(this);