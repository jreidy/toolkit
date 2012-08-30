define ['underscore', 'backbone', 'text!template/interest.html'], (_, Backbone, InterestsTemplate) ->
  class InterestsView extends Backbone.View
    el: "#locations"
    template: _.template InterestsTemplate

    initialize: ->
      _.bindAll this
      @bindEvents()
      @model.on "reset", @render
      @model.fetch()

    bindEvents: ->
      # undelegate events to prevent duplicated binding
      @$el.undelegate ".has_status"
      eventName = if 'createTouch' of document then 'tap' else 'click'
      events = {}
      events["#{eventName} .has_status"] = "showUserStatus"
      @delegateEvents events

    render: ->
      @length = @model.length
      @$el.html @template {items: @model.toJSON()}
      this.$("#length").text(@length)
      @showInterestMap()

    showUserStatus: (event) ->
      node = $(event.target)
      statusNode =  if node.hasClass "has_status" then node.find(".user_status") else node.parents(".has_status").find(".user_status")
      alert $.trim statusNode.html()

    showInterestMap: ->
      items = @model.toJSON()
      map = {}
      for user of items
        key = items[user].interest
        if map[key] then map[key] = map[key] + 1 else map[key] = 1 
      for key of map
        if key
          $("#interest_map").append("<p> #{key}: #{map[key]} are interested</p>")

  return InterestsView