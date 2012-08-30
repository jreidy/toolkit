define ['underscore', 'backbone', 'util/util', 'model/loading', 'view/loading_view', 'text!template/logout.html'], (_, Backbone, Util, Loading, LoadingView, LogoutTemplate) ->
  class LogoutView extends Backbone.View
    el: "#main"
    template: _.template LogoutTemplate

    initialize: ->
      _.bindAll this    

    render: ->
      Util.debug "LogoutView render"
      @$el.html @template ""
      logoutIFrame = @$el.find("#googleLogout")[0]
      loadingView = new LoadingView
      loadingView.render()
      onloadTimes = 0
      logoutIFrame.onload = ->
        Util.debug "logout done"
        onloadTimes += 1
        if onloadTimes > 4
          Util.loc.href = "#{Util.loc.protocol}//#{Util.loc.host}"
          console.log Util.loc.href + " href"
      logoutIFrame.src = "https://accounts.google.com/Logout"

  return LogoutView