define ['underscore', 'backbone', 'util/util', 'model/user', 'model/loading', 'model/project_categories', 'view/navbar_view', 'view/loading_view', 'text!template/project.html', 'moment'], (_, Backbone, Util, User, Loading, ProjectCategories, NavbarView, LoadingView, ProjectTemplate, moment) ->
  class ProjectView extends Backbone.View
    el: "#main"
    template: _.template ProjectTemplate

    initialize: (options) ->
      _.bindAll this
      @bindEvents()
      @_preRender()
      @model = new ProjectCategories [], 
        id: options.spreadsheet_id
      @user = new User
      @user.on "change:userName", @userDataReady

      body = document.getElementById("body")
      body.className = "1"
      console.log body

      navbarView = new NavbarView
        model: @user

      @model.on "reset", @spreadSheetReady

      supportsOrientationChange = "onorientationchange" of window
      orientationEvent = if supportsOrientationChange then "orientationchange" else "resize";
      window.addEventListener orientationEvent, @_calculateColWidth

    bindEvents: ->
      # undelegate events to prevent duplicated binding
      @$el.undelegate ".sub_category"
      events = {}
      eventName = if 'createTouch' of document then 'tap' else 'click'
      for i in [0...3]
        events["#{eventName} .category#{i}"] = "tabSelected"
      @delegateEvents events

    _preRender: ->
      @loadingView = new LoadingView
        model: new Loading {"message": "rendering Project page"}
      @loadingView.render()

    userDataReady: ->
      @model.access_token = @user.getAccessToken()
      @fetchProject()
      
    fetchProject: ->
      @model.fetch
        dataType: "jsonp"

    spreadSheetReady: ->
      @loadingView.empty() 
      @render()  

    _getWeeksFromNow: ->
      weeks = []
      for i in [0..7]
        weeks[i] = 
          name: moment().day(1 + i * 7).format("MM/DD/YY")
          landscapeOnly: if i < 4 then "" else "landscape_only"
      return weeks

    render: -> 
      Util.debug "render ProjectView"
      @$el.html @template 
        items: @model.toJSON()
        weeks: @_getWeeksFromNow()
      @_calculateColWidth()
      $("#window_width").append("<p>#{window.innerWidth}</p>")
      length = @model.toJSON().length
      for i in [1...length]
        @$el.find("#category#{i}").hide()
       

    _calculateColWidth: ->
      if window.orientation is 90 or window.orientation is -90
        @$el.find("table").addClass "landscape"
      else
        @$el.find("table").removeClass "landscape"
      
    tabSelected: (event) ->
      value = event.target.value
      console.log value
      length = @model.toJSON().length
      for i in [0...length]
        if i == (Number) value
          @$el.find("#category#{value}").show()
        else 
          @$el.find("#category#{i}").hide()

  return ProjectView







