define ['underscore', 'backbone', 'util/util', 'model/user', 'model/loading', 'model/project_categories', 'view/navbar_view', 'view/loading_view', 'text!template/project.html', 'moment'], (_, Backbone, Util, User, Loading, ProjectCategories, NavbarView, LoadingView, ProjectTemplate, moment) ->
  class ProjectView extends Backbone.View
    el: "#project_view"
    template: _.template ProjectTemplate

    initialize: (options) ->
      _.bindAll this
      @bindEvents()
      @_preRender()

      @options = options

      @currentCategory = 0

      @projects = []
      for i in [0...@options.items.length]
        @projects[i] = new ProjectCategories [],
          id: @options.items[i].gd$resourceId.$t

      @user = new User
      @user.on "change:userName", @userDataReady

      body = document.getElementById("body")
      body.className = "1"

      navbarView = new NavbarView
        model: @user

      @currentIndex = 0
      @projectTitle = @options.items[0].title.$t

      for i in [0...@projects.length]
        @projects[i].on "reset", @spreadSheetReady


    bindEvents: ->
      # undelegate events to prevent duplicated binding
      @$el.undelegate ".sub_category"
      events = {}
      eventName = if 'createTouch' of document then 'tap' else 'click'
      for i in [0...3]
        events["#{eventName} .category#{i}"] = "tabSelected"
      events["#{eventName} .next_week"] = "nextWeekSelected"
      events["#{eventName} .previous_week"] = "previousWeekSelected"
      @delegateEvents events

    _preRender: ->
      @loadingView = new LoadingView
        model: new Loading {"message": "rendering Project page"}
      @loadingView.render()

    userDataReady: ->
      for i in [0...@projects.length]
        @projects[i].access_token = @user.getAccessToken()
        @fetchProject(i)
      
    fetchProject: (index)->
      @projects[index].fetch
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
        items: @projects[@currentIndex].toJSON()
        weeks: @_getWeeksFromNow()
        title: @projectTitle
      @_calculateColWidth()
      $("#window_width").append("<p>#{window.innerWidth}</p>")
      length = @projects[@currentIndex].toJSON().length
      for i in [1...length]
        @$el.find("#category#{i}").hide()
      @currentWeek = 0
      for i in [0...8]
        @$el.find("#week#{i}").hide()
      @$el.find("#week#{@currentWeek}").show()
       
    _calculateColWidth: ->
      if window.orientation is 90 or window.orientation is -90
        @$el.find("table").addClass "landscape"
      else
        @$el.find("table").removeClass "landscape"
      
    tabSelected: (event) ->
      value = event.target.value
      length = @projects[@currentIndex].toJSON().length
      @currentCategory = value
      @currentWeek = 0
      @$el.find("#week#{@currentWeek}").show()

      for i in [0...length]
        if i == (Number) value
          @$el.find("#category#{value}").show()
        else 
          @$el.find("#category#{i}").hide()

    updateProjectView: (index)->
      @currentIndex = index
      @projectTitle = @options.items[index].title.$t
      @render()

    previousWeekSelected: ->
      
      @$el.find("#week#{@currentWeek - 1}").show()
      @$el.find("#week#{@currentWeek}").hide()
      @currentWeek = @currentWeek - 1
      console.log "previous week" + @currentWeek

    nextWeekSelected: ->
      console.log "#week#{@currentWeek + 1}"
      console.log @$el.find("#week#{@currentWeek + 1}")
      @$el.find("#week#{@currentWeek + 1}").show()
      @$el.find("#week#{@currentWeek}").hide()
      @currentWeek = @currentWeek + 1
      console.log "next week" + @currentWeek

  return ProjectView







