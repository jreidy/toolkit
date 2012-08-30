require.config
  paths:
    zepto: 'libs/zepto/zepto_amd'
    underscore: 'libs/underscore/underscore-min'
    backbone: 'libs/backbone/backbone'
    backbone_localStorage: 'libs/backbone/backbone.localStorage'
    text: 'libs/require/text'
    moment: 'libs/moment/moment.min'

require ['backbone', 'backbone_localStorage', 'router/app_router'], (Backbone, BackboneLocalStorage, AppRouter) ->  
  window.EngApp = {}
  appRouter = new AppRouter
  window.EngApp.appRouter = appRouter
  Backbone.history.start()

  
