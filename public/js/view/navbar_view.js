// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'util/util', 'model/loading', 'view/loading_view', 'text!template/navbar.html', 'view/tab_navigation_controller'], function(_, Backbone, Util, Loading, LoadingView, NavbarTemplate, TabNavigationController) {
    var NavbarView;
    NavbarView = (function(_super) {

      __extends(NavbarView, _super);

      function NavbarView() {
        return NavbarView.__super__.constructor.apply(this, arguments);
      }

      NavbarView.prototype.el = "#navbar";

      NavbarView.prototype.template = _.template(NavbarTemplate);

      NavbarView.prototype.initialize = function() {
        _.bindAll(this);
        this.bindEvents();
        this.router = window.EngApp.appRouter;
        this.model.on('change:userName', this.showUserName);
        if (!this.model.authorized()) {
          return this.jumpingToGoogleLogin();
        }
      };

      NavbarView.prototype.bindEvents = function() {
        var eventName, events;
        this.$el.undelegate("#logout");
        this.$el.undelegate("#back");
        eventName = 'createTouch' in document ? 'tap' : 'click';
        events = {};
        events["" + eventName + " #beacon"] = "navigate";
        events["" + eventName + " #projects"] = "navigate";
        events["" + eventName + " #kpis"] = "navigate";
        events["" + eventName + " #brownbag"] = "navigate";
        events["" + eventName + " #logout"] = "logout";
        events["" + eventName + " #back"] = "back";
        events["" + eventName + " #settings"] = "settings";
        return this.delegateEvents(events);
      };

      NavbarView.prototype.jumpingToGoogleLogin = function() {
        var loadingView;
        loadingView = new LoadingView({
          model: new Loading({
            "message": "redirect to google authorization"
          })
        });
        loadingView.render();
        return Util.loc.href = this.model.getAuthUrl();
      };

      NavbarView.prototype.render = function() {
        this.$el.html(this.template(this.model.toJSON()));
        return this.renderTabs();
      };

      NavbarView.prototype.renderTabs = function() {
        var index, tab_navigation_controller;
        index = parseInt(document.getElementById("body").className);
        return tab_navigation_controller = new TabNavigationController(index);
      };

      NavbarView.prototype.showUserName = function() {
        if (!this.model.isGreeAccount()) {
          alert("You should use gree account to login this app");
          this.logout();
        }
        this.render();
        return this.toggleBackbutton();
      };

      NavbarView.prototype.toggleBackbutton = function() {
        var backButton, locationHash;
        backButton = this.$el.find("#back");
        locationHash = Util.loc.hash;
        if (locationHash.length > 1 && locationHash !== "#logout") {
          return backButton.show();
        } else {
          return backButton.hide();
        }
      };

      NavbarView.prototype.navigate = function() {
        console.log(event.target.id);
        return this.router.navigate(event.target.id, {
          trigger: true
        });
      };

      NavbarView.prototype.logout = function() {
        if (confirm("Are you sure you want to log out?")) {
          this.model.destroy();
          this.remove();
          return this.router.navigate("/#logout");
        }
      };

      NavbarView.prototype.back = function() {
        var currentHash, paths;
        currentHash = Util.loc.hash;
        paths = currentHash.split("/");
        paths[0] = paths[0].substring(1);
        paths.splice(0, 0, "");
        return this.router.navigate(paths[paths.length - 2], {
          trigger: true
        });
      };

      NavbarView.prototype.settings = function() {
        var animate, dropHeight, main;
        dropHeight = "150px";
        main = document.getElementById("main");
        if (main.style.top === dropHeight) {
          animate = function() {
                    $('#main').animate({
                      top: '41px'
                    }, 100, 'toggle')
                  };
          animate();
        } else {
          animate = function() {
                    $('#main').animate({
                      top: dropHeight
                    }, 100)
                  };
          animate();
        }
        return console.log(main.style.top);
      };

      return NavbarView;

    })(Backbone.View);
    return NavbarView;
  });

}).call(this);