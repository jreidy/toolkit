define ['underscore', 'backbone', "util/util", "model/spreadsheet"], (_, Backbone, Util, Spreadsheet) ->
  ### 
  Read a Spreadsheet 
  sheet = new Spredsheet
    access_token: "ya29.AHES6ZTMXviGBfSy2nglOjfEuOFfggsS0gAh6BWNj5Yi9Q"
    id: "0Au6Uu7l2YC-TdGhWNVIxZ0JNY2psalo1NkRHTFRoWmc"
  ###
  class SpreadsheetList extends Backbone.Collection
    # shared folder id of google spreadsheet
    id: "0B0S9wwNRj-wtZFdjcVhDTTBVcGM"
    model: Spreadsheet

    url: ->
      "https://docs.google.com/feeds/default/private/full/#{@id}/contents?v=3&alt=json-in-script&access_token=#{@access_token}"

    parse: (response) ->
      ###
      backbone will merge duplicated model if they have same id. since value of id property is an object in google response data. we just reset id with a real string value to solve this issue 
      we also filter non-spreadsheet files from document list
      ###
      Util.debug "spreadsheets response: ", response
      items = response.feed.entry
      _.filter items, (item) ->
        item.id = item.id.$t
        resourceId = item.gd$resourceId.$t.split ":"
        item.gd$resourceId.$t = resourceId[1]
        item.updatedDate = item.updated.$t.substring(0, 10)
        resourceId[0] is "spreadsheet"

  return SpreadsheetList