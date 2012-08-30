define ['backbone', 'util/util', 'view/index_view', 'view/beacon_view', 'view/location_home_view', 'view/travel_status_view', 'view/project_list_view', 'view/project_view', 'view/kpi_dashboard_view', 'view/settings_view', 'view/brown_bag_view', 'view/logout_view', 'view/auth_callback_view'], (Backbone, Util, IndexView, BeaconView, LocationHomeView, TravelStatusView, ProjectListView, ProjectView, KpiDashboardView, SettingsView, BrownBagView, LogoutView, AuthCallbackView) ->  
  class AppRouter extends Backbone.Router
    routes:
      "": "index"
      "beacon": "beacon"
      "beacon/status": "changeStatus"
      "projects": "projectDashboard"
      "projects/:id": "project"
      "kpis": "kpiDashboard"
      "settings": "settings"
      "brownbag": "brownBag" 
      "settings/home": "changeHome"
      "logout": "logout"

    initialize: ->
      @route(/access_token=(.*)/, "authCallback")

    index: ->
      indexView = new IndexView

    beacon: ->
      @beaconView = new BeaconView

    changeStatus: ->
      @travelStatus = new TravelStatusView

    projectDashboard: ->
      @projectList = new ProjectListView

    project: (spreadsheet_id) ->
      @projectView = new ProjectView
        spreadsheet_id: spreadsheet_id

    kpiDashboard: ->
      @kpiDashboard = new KpiDashboardView

    settings: ->
      @settings = new SettingsView

    brownBag: ->
      @brownBag = new BrownBagView

    changeHome: ->
      @locationHome = new LocationHomeView

    logout: ->
      logout = new LogoutView
      logout.render()

    authCallback: (params) ->
      authCallback = new AuthCallbackView
      authCallback.render()

  return AppRouter