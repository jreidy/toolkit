define ['underscore', 'backbone', 'util/util', 'model/gauth'], (_, Backbone, Util, GAuth) ->
  class AuthCallbackView extends Backbone.View
    initialize: ->
      @router = window.EngApp.appRouter
      @model = new GAuth

    render: ->
      @model.parseAuthToken Util.loc.hash.substring(1)
      @router.navigate "",
        trigger: true
 
  return AuthCallbackView