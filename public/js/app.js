// Generated by CoffeeScript 1.3.3
(function() {

  require.config({
    paths: {
      zepto: 'libs/zepto/zepto_amd',
      underscore: 'libs/underscore/underscore-min',
      backbone: 'libs/backbone/backbone',
      backbone_localStorage: 'libs/backbone/backbone.localStorage',
      text: 'libs/require/text',
      moment: 'libs/moment/moment.min'
    }
  });

  require(['backbone', 'backbone_localStorage', 'router/app_router'], function(Backbone, BackboneLocalStorage, AppRouter) {
    var appRouter;
    window.EngApp = {};
    appRouter = new AppRouter;
    window.EngApp.appRouter = appRouter;
    return Backbone.history.start();
  });

}).call(this);
