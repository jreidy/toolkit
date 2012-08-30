define ['underscore', 'backbone', 'util/util', 'model/user', 'model/loading', 'model/kpi_categories', 'view/navbar_view', 'view/loading_view', 'text!template/kpi_categories.html', 'view/tab_controller', 'view/data_visualization'], (_, Backbone, Util, User, Loading, KpiCategories, NavbarView, LoadingView, KpiCategoriesTemplate, TabController, DataVisualization) ->
  class KpiDashboardView extends Backbone.View
    el: "#main"
    template: _.template KpiCategoriesTemplate

    initialize: ->

      @currentPie = 0
      @number = 4
      @selected = "t0"
      _.bindAll this
      @bindEvents()
      @_preRender()
      @model = new KpiCategories
      @user = new User
      @user.on "change:userName", @userDataReady
      @currentCategoryIndex = 0
      @currentKPIIndex = 0

      body = document.getElementById("body")
      body.className = "2"
      
      navbarView = new NavbarView
        model: @user
      @model.on "reset", @kpiCategoriesReady

    bindEvents: ->
      #undelegate events to prevent duplicated binding
      @$el.undelegate "#previousKPI"
      @$el.undelegate "#nextKPI"
      for i in [0...4]
        @$el.undelegate "tab_default" + i
      eventName = if 'createTouch' of document then 'tap' else 'click'
      events = {}
      events["#{eventName} #previousKPI"] = "previousKPI"
      events["#{eventName} #nextKPI"] = "nextKPI"
      for i in [0...4]
        id = "#t" + i
        events["#{eventName} #{id}"] = "tabSelected"
      @delegateEvents events

    _preRender: ->
      @loadingView = new LoadingView

    userDataReady: ->
      @model.access_token = @user.getAccessToken()
      @fetchKpiCategories()

    fetchKpiCategories: ->
      @model.fetch
        dataType: "jsonp"

    kpiCategoriesReady: ->
      @loadingView.empty() 
      @render()

    render: ->
      @items = @model.toJSON()
      @$el.html @template
      @currentCategoryIndex = 0
      @currentKPIIndex = 0
      @updateContent()
      @createTabs()
      @updatePie()
      data = new DataVisualization


    updateIndex: (update, length, obj) ->
      lessLength = length - 1
      obj += update
      if obj > lessLength
        obj = 0
      else if obj < 0
        obj = lessLength
      return obj

    nextKPI: ->
      @currentKPIIndex = @updateIndex(1, @items[@currentCategoryIndex].data.length, @currentKPIIndex)
      @updateContent()
      @updatePie()
      
    previousKPI: ->
      @currentKPIIndex = @updateIndex(-1, @items[@currentCategoryIndex].data.length, @currentKPIIndex)
      @updateContent()
      @updatePie()

    updateContent: ->
      this.$(".KPI_head").text(@items[@currentCategoryIndex].name)
      this.$(".numberLabel").text(@items[@currentCategoryIndex].data.length)
      this.$(".kpiName").text(@items[@currentCategoryIndex].data[@currentKPIIndex].name)
      # this.$(".kpiValue").text(@items[@currentCategoryIndex].data[@currentKPIIndex].value)
      
    updatePie: ->
      @currentPie = @currentPie + 1
      if @currentPie > 3 
        @currentPie = 1
      document.getElementById("pie").className = "pie_#{@currentPie}"

    createTabs: ->
      tab_controller = new TabController
        model: @number

    tabSelected: ->
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
        @currentKPIIndex = 0
        @currentCategoryIndex = @selected[1]
        @updateContent()

  return KpiDashboardView
