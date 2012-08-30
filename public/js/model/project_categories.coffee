define ['underscore', 'backbone', 'util/util', 'model/project_category', 'moment'], (_, Backbone, Util, ProjectCategory, moment) ->
  class ProjectCategories extends Backbone.Collection
    # we always use first worksheet of a spreadsheet
    worksheetId: 1
    model: ProjectCategory

    # url: ->
    #   "https://spreadsheets.google.com/feeds/cells/#{@id}/#{@worksheetId}/private/full?v=3&alt=json-in-script&access_token=#{@access_token}"

    url: ->
      "https://spreadsheets.google.com/feeds/list/#{@id}/#{@worksheetId}/private/full?v=3&alt=json-in-script&access_token=#{@access_token}"

    initialize: (model, options) ->
      @id = options.id

    parse: (response) ->
      categories = []
      rows = response.feed.entry
      _.each rows, (row) =>
        unless row.gsx$category
          return 
        category = row.gsx$category.$t
        if category.length is 0
          length = categories.length
          if length > 0
            categories[length - 1].subcategory.push @_parseSubCategory(row)
        else
          categories.push 
            name: category
            subcategory: [@_parseSubCategory(row)]

      return categories

    _parseSubCategory: (row) ->
      subcategory = row["gsx$sub-category"].$t
      startDate = row.gsx$startdate.$t
      endDate = row.gsx$enddate.$t
      subcatObj =
        name: subcategory
        startDate: startDate
        endDate: endDate
        workingWeeks: @_parseWorkingWeeks startDate, endDate

    _parseWorkingWeeks: (startDate, endDate)->
      weeks = []
      if startDate?.length is 0 or endDate?.length is 0
        return weeks
      weekNumber = 8
      start = moment startDate, "M/D/YYYY"
      end = moment endDate, "M/D/YYYY"
      currentWeekMonday = moment().day(1);
      lastWeekSunday = moment().day(7 + (weekNumber - 1) * 7)
      startDiff = Math.ceil(start.diff(currentWeekMonday, "days", true))
      endDiff = Math.ceil(lastWeekSunday.diff(end, "days", true))

      for i in [0...weekNumber]
        weeks[i] = ""
        week = []
        if startDiff >= i * 7 && startDiff <= i * 7 + 6
          startindex = startDiff - i * 7 + 1
          for j in [startindex...7]
            week[j] = true
        if startDiff < i * 7 && endDiff < (weekNumber - i) * 7 - 6
          for k in [0...7]
            week[k] = true
        if endDiff >= (weekNumber - i) * 7 - 6 && endDiff <= (weekNumber - i) * 7
          endindex = (weekNumber - i) * 7 -endDiff + 1
          for l in [0...endindex + 1]
            week[l] = true


    
        weeks[i] = week
      return weeks

  return ProjectCategories

   
    # weeks[i] = week