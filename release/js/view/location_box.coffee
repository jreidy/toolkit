define ['underscore', 'backbone', 'model/location'], (_, Backbone, Location) ->
  class LocationBox extends Backbone.View
   

    initialize: ->
      _.bindAll this

      @r = Raphael("holder2")

      @rect = @r.rect 0, 0, 20, 20
      @rect.attr({fill: "#c45b5b", stroke: "", opacity: 0.80, r: 2})

      @isInflated = false

      @popText = @r.text(0, 0, "0")
      @popText.attr({
                      fill: "#fff", 
                      "font-size": 18, 
                      "font-family": "Helvetica Neue", 
                      "font-weight": "bold",
                      "text-anchor": "start",
                      "line-height": "190px"
                    })
      @popText.node.lineHeight = "50px"

      th = @
      @popText.node.onclick = () ->
        th.flateBox()
      @rect.node.onclick = () ->
        th.flateBox()

      console.log("initialize")

    renderBox: (xpos, ypos, number, list) ->
      console.log("reached render, with " + xpos + " " +ypos)

      @popText.animate({x:xpos, y:ypos}, 0, "backOut")
      @popText.attr({text: number})

      @x = xpos - 4
      @y = ypos - 11
      @width = @popText.getBBox().width + 7
      @height = @popText.getBBox().height
      @number = number
      @list = list

      @rect.animate({x: @x, y: @y, width: @width, height: @height}, 0, "backOut")

    flateBox: ->
      if @isInflated

        @rect.animate({width: @width, height: @height, x: @x, y: @y}, 100, "backOut")
        @popText.attr({text: @number})
        @popText.animate({x:@x + 4})
        @isInflated = false

      else if @number > 0

        @popText.attr({text: @list})
        expandedWidth = @popText.getBBox().width + 8
        expandedHeight = @popText.getBBox().height + 5
        expandedY = @y + @height/2 - expandedHeight/2
        expandedX = @x

        console.log xmax = expandedY + expandedWidth
        console.log ymax = expandedY + expandedHeight
        if xmax > 320
          expandedX = 320 - expandedWidth - 10

        @rect.animate({width: expandedWidth, height: expandedHeight, x: expandedX, y: expandedY}, 100, "backOut")
        @popText.animate({x: expandedX + 4})
        @isInflated = true