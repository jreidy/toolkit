define ['underscore', 'backbone', 'util/util', 'model/user', 'model/loading', 'view/navbar_view', 'view/loading_view', 'text!template/settings.html', 'view/tab_controller'], (_, Backbone, Util, User, Loading,  NavbarView, LoadingView, SettingsTemplate, TabController) ->
  class SettingsView extends Backbone.View
    el: "#main"
    template: _.template SettingsTemplate
    initialize: ->


      @number = 4
      @selected = "t0"


      _.bindAll this
      @_preRender()
      @bindEvents()  
      @user = new User
      @user.on "change:userName", @userDataReady
      navbarView = new NavbarView
        model: @user

    bindEvents: ->
      for i in [0...@number]
        @$el.undelegate "tab_default" + i
      eventName = if 'createTouch' of document then 'tap' else 'click'
      events = {}
      for i in [0...@number]
        id = "#t" + i
        events["#{eventName} #{id}"] = "tabSelected"
      @delegateEvents events

    _preRender: ->
      @loadingView = new LoadingView
        model: new Loading {"message": "rendering settings page"}
      @loadingView.render()

    userDataReady: ->
      @loadingView.empty()  
      @render()

    render: ->
      @$el.html @template ""
      @createTabs()
      # document.getElementById("page_header").innerHTML = "Settings"

    createTabs: ->
      tab_controller = new TabController
        model: @number

     tabSelected: ->
        unless event.target.id == @selected
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

  return SettingsView