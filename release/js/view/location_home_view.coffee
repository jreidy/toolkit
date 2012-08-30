define ['underscore', 'backbone', 'util/util', 'model/user', 'model/loading', 'model/location', 'view/navbar_view', 'view/loading_view', 'text!template/location_home.html'], (_, Backbone, Util, User, Loading, Location, NavbarView, LoadingView, LocationHomeTemplate) ->
  class LocationHomeView extends Backbone.View
    el: "#main"
    template: _.template LocationHomeTemplate

    initialize: ->
      _.bindAll this
      @router = window.EngApp.appRouter
      @bindEvents()
      @_preRender()  
      @user = new User
      @user.on "change:userName", @userDataReady
      navbarView = new NavbarView
        model: @user

    bindEvents: ->
      # undelegate events to prevent duplicated binding
      @$el.undelegate "#office"
      events = {}
      events["change #office"] = "set"
      @delegateEvents events

    _preRender: ->
      @loadingView = new LoadingView
        model: new Loading {"message": "rendering set home location page"}
      @loadingView.render()

    userDataReady: ->
      @loadingView.empty()
      @location = new Location
      @location.set "id", @user.get "email"
      @locationPromise = @location.fetch()
      @locationPromise.done @render

    render: ->
      @$el.html @template @location.toJSON()

    set: (event) ->
      officeName = $(event.target).val()
      @location.set
        home: officeName
      @location.save().done =>
        @router.navigate "beacon",
          trigger: yes
  