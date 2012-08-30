define ['underscore', 'backbone', 'util/util', 'model/user', 'model/loading', 'model/location', 'view/navbar_view', 'view/loading_view', 'text!template/travel_status.html'], (_, Backbone, Util, User, Loading, Location, NavbarView, LoadingView, TravelStatusTemplate) ->
  class TravelStatusView extends Backbone.View
    el: "#main"
    template: _.template TravelStatusTemplate

    initialize: ->
      _.bindAll this
      @bindEvents()
      @router = window.EngApp.appRouter
      @_preRender()  
      @user = new User
      @user.on "change:userName", @userDataReady
      navbarView = new NavbarView
        model: @user

    bindEvents: ->
      # undelegate events to prevent duplicated binding
      @$el.undelegate "#save"
      eventName = if 'createTouch' of document then 'tap' else 'click'
      events = {}
      events["#{eventName} #save"] = "set"
      @delegateEvents events

    _preRender: ->
      @loadingView = new LoadingView
        model: new Loading {"message": "rendering travel status page"}
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
      status = @$el.find("#status").val()
      unless status
        alert "Travel Status can't be empty"
        return
      @location.set
        interest: status
        last_modify: Date.now()
      @location.save().done =>
        @router.navigate "beacon",
          trigger: yes
  