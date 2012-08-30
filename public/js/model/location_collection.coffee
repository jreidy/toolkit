define ['underscore', 'backbone', 'util/util', 'model/location'], (_, Backbone, Util, Location) ->
  class LocationCollection extends Backbone.Collection
    countryAbbrs:
      "Argentina": "ARG"
      "China": "CN"
      "Japan": "JP"
      "United States": "US"
    model: Location
    url: "/locations"

    comparator: (item) ->
      "#{item.get 'isTravelling'} #{item.get 'userName'}"

    parse: (response) ->
      _.map response, (item) =>
        email = item['email']
        if email
          match = /(.*)@/.exec email
          if match
            item["userName"] = match[1]
        [current, home] = [item['current'], item['home']]
        item["isTravelling"] =  if current is home then 'home' else 'away'
        lastModifyDate = new Date parseInt(item["last_modify"])
        item["lastModifyDayTime"] = "#{lastModifyDate.getFullYear()}/#{lastModifyDate.getMonth() + 1}/#{lastModifyDate.getDate()} #{lastModifyDate.getHours()}:#{lastModifyDate.getMinutes()}"
        return item

  return LocationCollection