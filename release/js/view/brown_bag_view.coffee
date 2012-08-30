define ['underscore', 'backbone', 'util/util', 'model/user', 'model/loading', 'model/location', 'model/location_collection', 'view/location_view', 'view/interests_view', 'view/navbar_view', 'view/interest_matcher', 'view/loading_view', 'text!template/brown_bag.html', 'view/tab_controller'], (_, Backbone, Util, User, Loading, Location, LocationCollection, LocationView, InterestsView, NavbarView, InterestMatcher, LoadingView, BrownBagTemplate, TabController) ->
  class BrownBagView extends Backbone.View
    el: "#main"
    template: _.template BrownBagTemplate

    initialize: ->
      @selected = "t0"
      _.bindAll this

      @number = 1

      @bindEvents()
      @_preRender()
      @user = new User
      @user.on "change:userName", @userDataReady

      body = document.getElementById("body")
      body.className = "3"
      console.log body

      navbarView = new NavbarView
        model: @user

    bindEvents: ->
      #undelegate events to prevent duplicate binding
      @$el.undelegate "#interest"
      @$el.undelegate "#match"
      for i in [0...4]
        @$el.undelegate "tab_default" + i
      eventName = if 'createTouch' of document then 'tap' else 'click'
      events = {}
      events["change #interest"] = "set"
      events["#{eventName} #match"] = "callInterestMatcher"
      for i in [0...4]
        id = "#t" + i
        events["#{eventName} #{id}"] = "tabSelected"
      @delegateEvents events

    _preRender: ->
      @loadingView = new LoadingView
        model: new Loading {"message": "rendering brown bag"}
      @loadingView.render()

    userDataReady: ->
      @loadingView.empty()
      @location = new Location
      @location.set "id", @user.get "email"
      @locationPromise = @location.fetch()
      @locationPromise.done @render

    render: ->
      console.log @location.get "interest"
      console.log @location.get "email"
      console.log @location.get "is_admin"
      @$el.html @template @location.toJSON()
      @renderLocationList()
      if (@location.get "is_admin") == "1"
        @renderMatch()
      @createTabs()
      # document.getElementById("page_header").innerHTML = "Baggin'"

    renderLocationList: ->
      @interestCollection = new LocationCollection
      interestsView = new InterestsView
        model: @interestCollection

    renderMatch: ->
      console.log "fadsf"
      $("#button").append("<button id=\"match\"> match </button>")

    set: (event) ->
      this.$("#changed").text("changed!")
      interestName = $(event.target).val()
      console.log interestName
      @location.set
        interest: interestName
        last_modify: Date.now()
      @location.save()
      this.$("#changed").text(interestName)

    callInterestMatcher: ->
      interest_matcher = new InterestMatcher
        model: @interestCollection

    createTabs: ->
      tab_controller = new TabController
        model: @number

     tabSelected: ->
        unless event.target.id == @selected || event.target.className == "x_icon" || event.target.className == "tab_default_x"
          event.target.className = "tab_bar_selected"
          z = 101
          document.getElementById(event.target.id).style.zIndex = z.toString()
          zIndex = 100 - @selected[1] - 1
          document.getElementById(@selected).style.zIndex = zIndex.toString()
          if @selected == "t0"
            document.getElementById(@selected).className = "tab_bar_first"
          else
            document.getElementById(@selected).className = "tab_default"
          @selected = event.target.id












