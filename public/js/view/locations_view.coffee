define ['underscore', 'backbone', 'text!template/location.html', 'view/location_box', 'view/loading_view'], (_, Backbone, LocationsTemplate, LocationBox, LoadingView) ->
  class LocationsView extends Backbone.View
    el: "#locations"
    template: _.template LocationsTemplate

    initialize: ->
      _.bindAll this
      @bindEvents()
      @_preRender()
      @model.on "reset", @readyForAction
      @model.fetch()


    bindEvents: ->
      # undelegate events to prevent duplicated binding
      @$el.undelegate ".has_status"
      eventName = if 'createTouch' of document then 'tap' else 'click'
      events = {}
      events["#{eventName} .has_status"] = "showUserStatus"
      @delegateEvents events

    readyForAction: ->
      @render()
      @loadingView.empty()

    render: ->
      @items = @model.toJSON()
      @$el.html @template

      @header = document.createElement("H3")
      @header.className = "location_header"
      @$el.append(@header)

      @name = document.createElement("span")
      @name.className = "location_name"
      @$el.append(@name)

      @pop = document.createElement("p")
      @pop.className = "pop"

      @locationBox = new LocationBox

      @updateLocationView("0")

    _preRender: ->
      @loadingView = new LoadingView

    showUserStatus: (event) ->
      node = $(event.target)
      statusNode =  if node.hasClass "has_status" then node.find(".user_status") else node.parents(".has_status").find(".user_status")
      alert $.trim statusNode.html()

    updateLocationView: (loc) ->
      img = document.getElementById("current_location_image")
      switch loc
        when "0"
          match = "2nd St., SF, US" 
        when "1"
          match = "CB, SF, US"
        when "2"
          match = "Beijing, CN"
        else
          match = "Tokyo, JP"

      numberAtLocation = 0
      list = ""
      isSingleDigit = false
      for i of @items
        if @items[i].current == match
          numberAtLocation++
          username = @items[i].userName
          nameInList = ""
          first = username.indexOf ".", 0
          last = username.lastIndexOf "."
          if first == last
            nameInList += username.substring 0, first
            nameInList += " " + username.substring first + 1, username.length
          else
            nameInList += username.substring first + 1, last
            nameInList += " " + username.substring last + 1, username.length
          list += nameInList + "\n"


      switch loc
        when "0" 
          img.className = "cali_orange"

          @header.innerHTML = "UNITED STATES"
          @name.innerHTML = "2ND STREET, SF"
          @header.style.marginTop = "273px"
          @name.style.marginTop = "296px"
          @header.style.marginLeft = "40px"
          @name.style.marginLeft = "41px"
          @locationBox.renderBox(85, 164, numberAtLocation, list)

        when "1"
          img.className = "cali_purple"

          @header.innerHTML = "UNITED STATES"
          @name.innerHTML = "CHINA BASIN, SF"
          @header.style.marginTop = "273px"
          @name.style.marginTop = "296px"
          @header.style.marginLeft = "40px"
          @name.style.marginLeft = "41px"
          @locationBox.renderBox(87, 165, numberAtLocation, list)

        when "2"
          img.className = "china_blue"

          @header.innerHTML = "CHINA"
          @name.innerHTML = "BEIJING"
          @header.style.marginTop = "293px"
          @name.style.marginTop = "316px"

          @header.style.marginLeft = "60px"
          @name.style.marginLeft = "61px"
          @locationBox.renderBox(212, 158, numberAtLocation, list)


        else 
          img.className = "japan_green"

          @header.innerHTML = "JAPAN"
          @name.innerHTML = "TOKYO"
          @header.style.marginTop = "163px"
          @name.style.marginTop = "186px"
          @header.style.marginLeft = "50px"
          @name.style.marginLeft = "51px"
          @locationBox.renderBox(210, 234, numberAtLocation, list)

        
  return LocationsView
