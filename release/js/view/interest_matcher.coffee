define ['underscore', 'backbone', 'model/location'], (_, Backbone, Location) ->
  class InterestMatcher extends Backbone.View
    el: "#matches"

    initialize: ->
      _.bindAll this
      @match()

    match: ->
      console.log "hello, this is matcher"
      matched = []
      users = @model.toJSON()
      for i of users
        current = users[i]
        if current.has_match != "false" or matched[current.email]
          continue
        for j of users
          potential = users[j]
          # @$el.append("<p> #{current.email} vs. #{potential.email}</p>")
          if current.email == potential.email or current.interest != potential.interest or matched[potential.email]
            # @$el.append("<p> potential was not</p>")
            continue
          else
            matched[current.email] = potential.email
            matched[potential.email] = current.email
            @$el.append("<p> #{current.email} matched with #{potential.email}</p>")
            break
      for i of matched
        match1 = new Location
        match1.set "id", i
        console.log (i)
        matchPromise = match1.fetch()
        matchPromise.done @saver(match1, matched[i])

    saver: (match, matchee) ->
      match.set
        has_match: matchee
          # current: match.get "current"
          # last_modify: match.get "last_modify"
          # status: match.get "status"
          # interest: match.get "interest"
          # is_admin: match.get "is_admin"
      match.save()
      # match.toJSON()
      # # console.log @match1.toJSON().get "interest"
      # console.log match.get "interest"
      # console.log match.get "email"
      # console.log match.get "is_admin"
      console.log match.get "home"

