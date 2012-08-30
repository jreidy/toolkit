define ['underscore', 'backbone', 'util/util', 'model/kpi_category', 'moment'], (_, Backbone, Util, KpiCategory, moment) ->
  class KpiCategories extends Backbone.Collection
    # we always use first worksheet of KPI Spreadsheet
    worksheetId: 1
    id: "0AkS9wwNRj-wtdGVKN0x5SFFOdXBITXBYOW96UzBpSnc"
    model: KpiCategory

    # url: ->
    #   "https://spreadsheets.google.com/feeds/cells/#{@id}/#{@worksheetId}/private/full?v=3&alt=json-in-script&access_token=#{@access_token}"

    url: ->
      "https://spreadsheets.google.com/feeds/list/#{@id}/#{@worksheetId}/private/full?v=3&alt=json-in-script&access_token=#{@access_token}"

    initialize: ->


    parse: (response) ->
      ###
      backbone will merge duplicated model if they have same id. since value of id property is an object in google response data. we just reset id with a real string value to solve this issue 
      we also filter non-spreadsheet files from document list
      ###
      Util.debug "kpi categories response: ", response
      categories = {}
      items = response.feed.entry
      _.each items, (item) ->
        category = item.gsx$category.$t
        kpiName = item.gsx$kpi.$t
        value = item.gsx$value.$t
        value = value.substring(0, value.indexOf(".") + 3)
        if not categories[category]
          categories[category] = 
            name: category
            data: []
        categories[category].data.push
          name: kpiName
          value: value

      return _.values categories

  return KpiCategories