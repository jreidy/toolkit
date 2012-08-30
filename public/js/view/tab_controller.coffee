define ['underscore', 'backbone', 'model/location'], (_, Backbone, Location) ->
  class TabController extends Backbone.View
   

    initialize: ->
      _.bindAll this
      @createTabs()


    createTabs:() ->
      console.log @model
      for i in [0...4]
        tab = document.createElement("DIV")
        tab.className = "tab_default"
        tab.id = "t" + i
        position = i * 78 - 15
        tab.style.marginLeft = position.toString() + "px"
        zIndex = 100 - i - 1
        tab.style.zIndex = zIndex.toString()

        if i == 0 
          tab.style.zIndex = "101"
          tab.className = "tab_bar_selected"

        $("#tab_bar").append(tab)

        if i >= @model
          x = document.createElement("DIV")
          x.className = "x_icon"
          $("#t" + i).append(x)
          tab.className = "tab_default_x"
