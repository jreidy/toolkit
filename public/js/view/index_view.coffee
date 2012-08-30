define ['underscore', 'backbone', 'view/loading_view'], (_, Backbone, LoadingView) ->
  class IndexView extends Backbone.View

    initialize: ->
      @router = window.EngApp.appRouter
      @preloadImages()
      @forward()

    preloadImages: ->
      console.log 
      images = ["../img/tabTestLight@2x.png", 
      "../img/tabTestSelected@2x.png", 
      "../img/tabTest@2x.png", 
      "../img/tabTopLight.png", 
      "../img/tabTopFirst.png", 
      "../img/tabTopDark.png",
      "../img/xSmall.png",
      "../img/dashedLine.png",
      "../img/beaconIcon.png",
      "../img/kpiIcon.png",
      "../img/brownBagIcon.png",
      "../img/projectIcon.png"]
      loadedImages = []
      for i in [0...images.length]
        console.log i
        loadedImages[i] = new Image()
        loadedImages[i].src = images[i]

    forward: ->
      @router.navigate("/#beacon")

  return IndexView