define ['underscore', 'backbone', 'util/util'], (_, Backbone, Util) ->
  class Location extends Backbone.Model
    defaults:
      email: ""
      home: ""
      current: ""
      last_modify: ""
      status: ""
      interest: ""
      has_match: "false"
      is_admin: "0"

    url: ->
      "/locations/#{@get 'id'}"

  return Location