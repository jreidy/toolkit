define ['underscore', 'backbone', 'util/util', 'text!template/loading.html'], (_, Backbone, Util, LoadingTemplate) ->
  class LoadingView extends Backbone.View
    el: ".loading_container"
    template: _.template LoadingTemplate

    initialize: ->
      @_preRender()

    _preRender: ->
      @$el.html @template
      hi = `
        function (word) {
          var opts = {
            lines: 13, // The number of lines to draw
            length: 0, // The length of each line
            width: 6, // The line thickness
            radius: 13, // The radius of the inner circle
            corners: 1, // Corner roundness (0..1)
            rotate: 0, // The rotation offset
            color: 'white', // #rgb or #rrggbb
            speed: 1.3, // Rounds per second
            trail: 39, // Afterglow percentage
            shadow: false, // Whether to render a shadow
            hwaccel: false, // Whether to use hardware acceleration
            className: 'spinner', // The CSS class to assign to the spinner
            zIndex: 2e9, // The z-index (defaults to 2000000000)
            top: 'auto', // Top position relative to parent in px
            left: 'auto' // Left position relative to parent in px
          };
          var target = document.getElementById('spinner');
          var spinner = new Spinner(opts).spin(target);
        }`
      hi("hallo")

    empty: ->
      @$el.html ""
 
  return LoadingView