// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'util/util', 'model/kpi_category', 'moment'], function(_, Backbone, Util, KpiCategory, moment) {
    var KpiCategories;
    KpiCategories = (function(_super) {

      __extends(KpiCategories, _super);

      function KpiCategories() {
        return KpiCategories.__super__.constructor.apply(this, arguments);
      }

      KpiCategories.prototype.worksheetId = 1;

      KpiCategories.prototype.id = "0AkS9wwNRj-wtdGVKN0x5SFFOdXBITXBYOW96UzBpSnc";

      KpiCategories.prototype.model = KpiCategory;

      KpiCategories.prototype.url = function() {
        return "https://spreadsheets.google.com/feeds/list/" + this.id + "/" + this.worksheetId + "/private/full?v=3&alt=json-in-script&access_token=" + this.access_token;
      };

      KpiCategories.prototype.initialize = function() {};

      KpiCategories.prototype.parse = function(response) {
        /*
              backbone will merge duplicated model if they have same id. since value of id property is an object in google response data. we just reset id with a real string value to solve this issue 
              we also filter non-spreadsheet files from document list
        */

        var categories, items;
        Util.debug("kpi categories response: ", response);
        categories = {};
        items = response.feed.entry;
        _.each(items, function(item) {
          var category, kpiName, value;
          category = item.gsx$category.$t;
          kpiName = item.gsx$kpi.$t;
          value = item.gsx$value.$t;
          value = value.substring(0, value.indexOf(".") + 3);
          if (!categories[category]) {
            categories[category] = {
              name: category,
              data: []
            };
          }
          return categories[category].data.push({
            name: kpiName,
            value: value
          });
        });
        return _.values(categories);
      };

      return KpiCategories;

    })(Backbone.Collection);
    return KpiCategories;
  });

}).call(this);
