define ['underscore', 'backbone', 'util/util'], (_, Backbone, Util) ->
  class GAuth extends Backbone.Model
    redirect_uri: "#{Util.loc.protocol}//#{Util.loc.host}"
    client_id: "732956213095-denfv8c10qri71remq4p3d24kgrn7iup.apps.googleusercontent.com"
    # 732956213095-5hur970asb127rfk0dqbk9e8sa43nh4v.apps.googleusercontent.com  ---localhost
    # 732956213095-denfv8c10qri71remq4p3d24kgrn7iup.apps.googleusercontent.com  ---toolkit
    response_type: "token"
    scope: "https://spreadsheets.google.com/feeds/+https://docs.google.com/feeds/+https://www.googleapis.com/auth/userinfo.profile+https://www.googleapis.com/auth/userinfo.email"
    base_url: "https://accounts.google.com/o/oauth2/auth"

    initialize: ->
      @id = "local_auth" 
      @localStorage = new Backbone.LocalStorage @id

    getAuthUrl: ->
      path = "response_type=#{@response_type}&client_id=#{@client_id}&redirect_uri=#{@redirect_uri}&scope=#{@scope}"
      url = "#{@base_url}?#{path}"

    ###
    @param query
      access_token=ya29.AHES6ZSYbvbzbPOfc9p-Q8xtBTWiEuB9TpB-LmnJKXfPH6d2&token_type=Bearer&expires_in=3600
    ###
    parseAuthToken: (query) ->
      pairs = query.split('&')
      params = {}
      _.each pairs, (pair) ->
        item = pair.split "="
        params[item[0]] = item[1]
      params['expired_at'] = Date.now() + params['expires_in'] * 1000
      @set params      

      @save()

    _expired: ->
      expired_at = @get 'expired_at'
      now = Date.now()
      if expired_at
        expired_at < now
      else
        true

    authorized: ->
      return (@get 'access_token') && (not @_expired())

  return GAuth  