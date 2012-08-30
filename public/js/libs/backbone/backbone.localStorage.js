define(['underscore', 'backbone'], function(_, Backbone) {
  // A simple module to replace `Backbone.sync` with *localStorage*-based
  // persistence. Models are given GUIDS, and saved into a JSON object. Simple
  // as that.

  // Generate four random hex digits.
  function S4() {
     return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
  };

  // Generate a pseudo-GUID by concatenating random hexadecimal.
  function guid() {
     return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
  };

  // Our Store is represented by a single JS object in *localStorage*. Create it
  // with a meaningful name, like the name you'd give a table.
  // window.Store is deprectated, use Backbone.LocalStorage instead
  Backbone.LocalStorage = window.Store = function(name) {
    this.name = name;
    var store = this.localStorage().getItem(this.name);
    this.data = (store && JSON.parse(store)) || {};
  };

  _.extend(Backbone.LocalStorage.prototype, {

    save: function() {
      localStorage.setItem(this.name, JSON.stringify(this.data));
    },

    create: function(model) {
      if (!model.id) model.id = model.attributes.id = guid();
      this.data[model.id] = model;
      this.save();
      return model;
    },

    update: function(model) {
      this.data[model.id] = model;
      this.save();
      return model;
    },

    find: function(model) {
      return this.data[model.id];
    },

    findAll: function() {
      return _.values(this.data);
    },

    destroy: function(model) {
      delete this.data[model.id];
      this.save();
      return model;
    },

    localStorage: function() {
        return localStorage;
    }

  });

  // localSync delegate to the model or collection's
  // *localStorage* property, which should be an instance of `Store`.
  // window.Store.sync and Backbone.localSync is deprectated, use Backbone.LocalStorage.sync instead
  Backbone.LocalStorage.sync = window.Store.sync = Backbone.localSync = function(method, model, options, error) {
    var store = model.localStorage || model.collection.localStorage;

    // Backwards compatibility with Backbone <= 0.3.3
    if (typeof options == 'function') {
      options = {
        success: options,
        error: error
      };
    }

    var resp;

    switch (method) {
      case "read":    resp = model.id != undefined ? store.find(model) : store.findAll(); break;
      case "create":  resp = store.create(model);                            break;
      case "update":  resp = store.update(model);                            break;
      case "delete":  resp = store.destroy(model);                           break;
    }

    if (resp) {
      options.success(resp);
    } else {
      options.error("Record not found");
    }
  };

  Backbone.ajaxSync = Backbone.sync;

  Backbone.getSyncMethod = function(model) {
    if(model.localStorage || (model.collection && model.collection.localStorage))
    {
      return Backbone.localSync;
    }

    return Backbone.ajaxSync;
  };

  // Override 'Backbone.sync' to default to localSync,
  // the original 'Backbone.sync' is still available in 'Backbone.ajaxSync'
  Backbone.sync = function(method, model, options, error) {
    return Backbone.getSyncMethod(model).apply(this, [method, model, options, error]);
  };


});