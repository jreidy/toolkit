define ['underscore', 'backbone', 'util/util'], (_, Backbone, Util) ->
  class FourSquareLocation extends Backbone.Model
    client_id: "JRCYYUZK5Q2GENAPUH2CNW2SG1RNVVBDDTADCOB1BWPQVUFK"
    client_secret: "JKQOKQ2SVHVMO5VOOZQAFG55ZG2Y14EUPL44510SEZZUYMJH"
    v: "20120426"
    urlRoot: "https://api.foursquare.com/v2/venues/search"
    countryCityMap:
      "China": "Beijing"
      "Japan": "Tokyo"
      # "United States": "San Francisco"
      "United States": "CB, SF"
      "Argentina": "Buenos Aires"
    countryAbbrs:
      "Argentina": "ARG"
      "China": "CN"
      "Japan": "JP"
      "United States": "US"
    funzioLoc = 
      latitude: 37.7882888570246
      longitude: -122.39682522210278


    url: ->
      "#{@urlRoot}?ll=#{@get 'latitude'},#{@get 'longitude'}&client_id=#{@client_id}&client_secret=#{@client_secret}&v=#{@v}"

    initialize: ->
      _.bindAll this
      @id = "foursquare_location" 
      @localStorage = new Backbone.LocalStorage @id

    locate: ->
      @trigger "locating"
      # Request a position. We accept positions whose age is not
      # greater than 30 minutes
      navigator.geolocation.getCurrentPosition @getLocationSuccess, @getLocationFail
        , { maximumAge: 60000 }

    getLocationSuccess: (position) ->
      newLatitude = position.coords.latitude
      newLongitude = position.coords.longitude
      @fetch()
      currentLatitude = @get('latitude')
      currentLongitude = @get('longitude')
      if currentLatitude is undefined || currentLongitude is undefined || Math.abs(currentLatitude - newLatitude) > 0.01 || Math.abs(currentLongitude - newLongitude) > 0.01
        @set position.coords
        promise = @load()
        promise.done @parseResponse
        promise.fail @fetchLocationFromFourSquareFail 

    getLocationFail: ->
      @trigger 'setLocation:failed'    

    fetchLocationFromFourSquareFail: ->
      @trigger "getLocationName:failed" 

    _parseCity: (country) ->
      if country is "United States" && funzioLoc.latitude - @get('latitude') <= 0.005
        return "2nd St., SF"
      else
        return @countryCityMap[country]


    parseResponse: (resp) ->
      Util.debug "4sq response", resp
      unless resp.meta.code is 200
        @trigger "getLocationName:failed"
        return
      location = resp.response.venues[0].location
      @set
        country: location.country
        city: @_parseCity location.country
        countryAbbr: @countryAbbrs[location.country]
      @save()

    load: ->
      $.ajax
        dataType: "jsonp"
        url: @url()

  return FourSquareLocation