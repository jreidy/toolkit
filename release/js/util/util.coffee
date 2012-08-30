define [], ->
  Util = {
    loc: window.location
    debug: ->
      if window.console
        window.console.log Array.prototype.slice.call(arguments)
    observing: (eventEmmiter)->
      eventEmmiter.on 'all', (eventName) ->
        Util.debug eventEmmiter, eventName
  }

  return Util