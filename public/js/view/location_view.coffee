define ['underscore', 'backbone', 'util/util', 'model/location', 'text!template/current_location.html'], (_, Backbone, Util, Location, CurrentLocationTemplate) ->
  class LocationView extends Backbone.View
    el: "#my_current_location"
    template: _.template CurrentLocationTemplate
    initialize: (options) ->
      _.bindAll this
      @router = window.EngApp.appRouter

      @location = new Location
      @location.set "id", options.locationId
      @locationPromise = @location.fetch()
      @model.on 'locating', @locating
      @model.on 'setLocation:failed getLocationName:failed', @fail
      @model.on "change:country change:city", @success
      @model.locate()

    render: ->
      @$el.html @template 
        model: @model.toJSON()
        location: @location.toJSON()

    locating: ->
      @model.set "message", "Calculating your location..."
      @render()

    fail: ->
      @model.set "message", "Sorry, can't get your location. You may have disallowed location requests for this browser"
      @render()

    success: ->
      @model.set "message", "You are in #{@model.get 'city'}, #{@model.get 'countryAbbr'}"
      @render()
      @updateUserLocation()

    updateUserLocation: ->
      @locationPromise.done @getLocationSuccess

    getLocationSuccess: ->
      if @location.get 'home'
        @render()
        @location.set
          current: "#{@model.get 'city'}, #{@model.get 'countryAbbr'}"
          last_modify: Date.now()
        @location.save().done =>
          @trigger "curretLocationReady"
      else
        @jumpToSetHomePage()  

    jumpToSetHomePage: ->
      @router.navigate "settings/home",
        trigger: true

    # readableCoordination: ->
    #   round = (num) ->
    #     Math.round(num * 10)/10
    #   "#{round @model.get 'latitude'},#{round @model.get 'longitude'}"

  return LocationView