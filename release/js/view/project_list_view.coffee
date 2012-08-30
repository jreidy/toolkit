define ['underscore', 'backbone', 'util/util', 'model/user', 'model/loading', 'model/spreadsheet_list', 'view/navbar_view', 'view/loading_view', 'text!template/project_list.html', 'view/tab_controller'], (_, Backbone, Util, User, Loading, SpreadsheetList, NavbarView, LoadingView, ProjectListTemplate, TabController) ->
  class ProjectListView extends Backbone.View
    el: "#main"
    template: _.template ProjectListTemplate

    initialize: ->
      @selected = "t0"
      _.bindAll this

      @number = 1

      @bindEvents()
      @_preRender()
      @model = new SpreadsheetList
      @user = new User
      @user.on "change:userName", @userDataReady

      body = document.getElementById("body")
      body.className = "1"
      console.log body

      navbarView = new NavbarView
        model: @user

      @model.on "reset", @spreadSheetListReady
      
    bindEvents: ->
      #undelegate events to prevent duplicate binding
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
        model: new Loading {"message": "rendering ProjectList page"}
      @loadingView.render()

    userDataReady: ->
      @model.access_token = @user.getAccessToken()
      @fetchProjectList()

    fetchProjectList: ->
      @model.fetch
        dataType: "jsonp"

    spreadSheetListReady: ->
      @loadingView.empty() 
      @render()

    render: -> 
      @$el.html @template {items: @model.toJSON()}
      @createTabs()

    createTabs: ->
      tab_controller = new TabController
        model: @number

    tabSelected: ->
      console.log event.target.id[1]
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


  return ProjectListView