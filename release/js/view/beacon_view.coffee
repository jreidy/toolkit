define ['underscore', 'backbone', 'util/util', 'model/user', 'model/loading', 'model/foursquare_location', 'model/location_collection', 'view/navbar_view', 'view/loading_view', 'view/location_view', 'view/locations_view', 'text!template/beacon.html', 'view/tab_controller'], (_, Backbone, Util, User, Loading, FourSquareLocation, LocationCollection, NavbarView, LoadingView, LocationView, LocationsView, BeaconTemplate, TabController) ->
  class BeaconView extends Backbone.View
    el: "#main"
    template: _.template BeaconTemplate

    initialize: ->
      @number = 4
      @selected = "t0"

      _.bindAll this
      @_preRender()
      @bindEvents()
      @user = new User
      @user.on "change:userName", @userDataReady

      body = document.getElementById("body")
      body.className = "0"
      console.log body

      navbarView = new NavbarView
        model: @user

    bindEvents: ->
      for i in [0...4]
        @$el.undelegate "tab_default" + i
      eventName = if 'createTouch' of document then 'tap' else 'click'
      events = {}
      for i in [0...4]
        id = "#t" + i
        events["#{eventName} #{id}"] = "tabSelected"
      @delegateEvents events

    _preRender: ->
      @loadingView = new LoadingView
      @loadingView.render()
      @render()

    render: ->
      @$el.html @template ""
      @createTabs()

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
          @locationsView.updateLocationView(@selected[1])

    userDataReady: ->
      @loadingView.empty()
      @fsLocation = new FourSquareLocation
      @locationView = new LocationView
        model: @fsLocation
        locationId: @user.get "email"
      @locationView.on "curretLocationReady", @renderLocationList

    renderLocationList: ->
      locationCollection = new LocationCollection
      @locationsView = new LocationsView
        model: locationCollection

  return BeaconView