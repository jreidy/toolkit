define ['underscore', 'backbone', 'model/location'], (_, Backbone, Location) ->
  class TabNavigationController extends Backbone.View
   

    initialize: (tab_number)->
      _.bindAll this
      @number = tab_number
      @createTabs()
      
    createTabs:() ->
      for i in [0...4]
        tab = document.createElement("DIV")
        tab.className = "tab_top_dark"
        tab.id = "top" + i
        position = i * 58 - 15
        tab.style.marginLeft = position.toString() + "px"
        zIndex = 100 - i - 1
        tab.style.zIndex = zIndex.toString()
        if i == 0
          tab.className = "tab_top_first"
        if i == @number 
          tab.style.zIndex = "101"
          tab.className = "tab_top_light"
        $("#tab_top").append(tab)