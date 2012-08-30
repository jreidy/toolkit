define ['underscore', 'backbone', 'zepto', 'util/util', 'model/gauth'], (_, Backbone, $, Util, GAuth) ->
  class User extends Backbone.Model
    auth = null
    location = null
    access_token = null
    url: ->
      "https://www.googleapis.com/oauth2/v2/userinfo?access_token=#{access_token}"

    initialize: ->
      _.bindAll this
      @id = "local_user"
      @localStorage = new Backbone.LocalStorage @id
      @on "destroy", @userDestroyed
      auth = new GAuth
      auth.on "change:access_token", @authAccessTokenChanged

    userDestroyed: ->
      auth.destroy()

    authAccessTokenChanged: ->
      access_token = auth.get 'access_token'
      @fetch()
      unless @get('userName')?.length > 0
        @load().always (model) =>
          if model? && model["email"]?.length
            match = /(.*)@/.exec model["email"]
            if match
              model["userName"] = match[1]
            model["uid"] = model["id"]
            model["id"] = @id
            @set model
            @save()
          else
            @trigger "fetch:error"

    load: ->
      $.ajax
        dataType: "jsonp"
        url: @url()

    authorized: ->
      auth.fetch()
      auth.authorized()

    getAuthUrl: ->
      auth.getAuthUrl()

    getAccessToken: ->
      auth.get 'access_token'

    isGreeAccount: ->
      @get('email').indexOf("@gree.co.jp") > 0

  return User