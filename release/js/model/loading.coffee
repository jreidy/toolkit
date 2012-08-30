define ['backbone'], (Backbone) ->
  class Loading extends Backbone.Model
    defaults:
      message: ""
      duration: 0.6

  return Loading  