define ['underscore', 'backbone', 'util/util', 'model/loading', 'view/loading_view', 'text!template/navbar.html', 'view/tab_navigation_controller'], (_, Backbone, Util, Loading, LoadingView, NavbarTemplate, TabNavigationController) ->
  class NavbarView extends Backbone.View
    el: "#navbar"
    # events:
    #   "tap #logout": "logout"
    #   "tap #back": "back"
    template: _.template NavbarTemplate

    initialize: ->
      _.bindAll this
      @bindEvents()
      @router = window.EngApp.appRouter
      @model.on 'change:userName', @showUserName      
      unless @model.authorized()
        @jumpingToGoogleLogin()

    bindEvents: ->
      # undelegate events to prevent duplicated binding
      @$el.undelegate "#logout"
      @$el.undelegate "#back"
      eventName = if 'createTouch' of document then 'tap' else 'click'
      events = {}
      events["#{eventName} #beacon"] = "navigate"
      events["#{eventName} #projects"] = "navigate"
      events["#{eventName} #kpis"] = "navigate"
      events["#{eventName} #brownbag"] = "navigate"
      events["#{eventName} #logout"] = "logout"
      events["#{eventName} #back"] = "back"
      events["#{eventName} #settings"] = "settings"
      @delegateEvents events

    jumpingToGoogleLogin: ->
      # redirect to google login page
      loadingView = new LoadingView
        model: new Loading {"message": "redirect to google authorization"}
      loadingView.render()
      Util.loc.href = @model.getAuthUrl()

    render: ->
      @$el.html @template @model.toJSON()
      @renderTabs()

    renderTabs: ->
      index = parseInt(document.getElementById("body").className)
      tab_navigation_controller = new TabNavigationController(index)

    showUserName: ->
      unless @model.isGreeAccount()
        alert "You should use gree account to login this app"
        @logout()
      @render() 
      @toggleBackbutton()  

    toggleBackbutton: ->
      backButton = @$el.find("#back")
      locationHash = Util.loc.hash
      if locationHash.length > 1 && locationHash isnt "#logout" then backButton.show() else backButton.hide()

    navigate: ->
      console.log event.target.id
      @router.navigate event.target.id,
          trigger: yes

    logout: ->
      if confirm("Are you sure you want to log out?")
        @model.destroy()  
        @remove()
        @router.navigate("/#logout")
        
    back: ->
      currentHash = Util.loc.hash
      paths = currentHash.split "/"
      paths[0] = paths[0].substring 1
      paths.splice 0, 0, ""
      @router.navigate paths[paths.length - 2],
        trigger: true

    settings: ->
      dropHeight = "150px"
      main = document.getElementById("main")

      if (main.style.top == dropHeight)
        animate = `function() {
                    $('#main').animate({
                      top: '41px'
                    }, 100, 'toggle')
                  }`
        animate()
      else
        animate = `function() {
                    $('#main').animate({
                      top: dropHeight
                    }, 100)
                  }`
        animate()

      console.log main.style.top
      
  return NavbarView