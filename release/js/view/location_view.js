(function(){var e={}.hasOwnProperty,t=function(t,n){function i(){this.constructor=t}for(var r in n)e.call(n,r)&&(t[r]=n[r]);return i.prototype=n.prototype,t.prototype=new i,t.__super__=n.prototype,t};define(["underscore","backbone","util/util","model/location","text!template/current_location.html"],function(e,n,r,i,s){var o;return o=function(n){function r(){return r.__super__.constructor.apply(this,arguments)}return t(r,n),r.prototype.el="#my_current_location",r.prototype.template=e.template(s),r.prototype.initialize=function(t){return e.bindAll(this),this.router=window.EngApp.appRouter,this.location=new i,this.location.set("id",t.locationId),this.locationPromise=this.location.fetch(),this.model.on("locating",this.locating),this.model.on("setLocation:failed getLocationName:failed",this.fail),this.model.on("change:country change:city",this.success),this.model.locate()},r.prototype.render=function(){return this.$el.html(this.template({model:this.model.toJSON(),location:this.location.toJSON()}))},r.prototype.locating=function(){return this.model.set("message","Calculating your location..."),this.render()},r.prototype.fail=function(){return this.model.set("message","Sorry, can't get your location. You may have disallowed location requests for this browser"),this.render()},r.prototype.success=function(){return this.model.set("message","You are in "+this.model.get("city")+", "+this.model.get("countryAbbr")),this.render(),this.updateUserLocation()},r.prototype.updateUserLocation=function(){return this.locationPromise.done(this.getLocationSuccess)},r.prototype.getLocationSuccess=function(){var e=this;return this.location.get("home")?(this.render(),this.location.set({current:""+this.model.get("city")+", "+this.model.get("countryAbbr"),last_modify:Date.now()}),this.location.save().done(function(){return e.trigger("curretLocationReady")})):this.jumpToSetHomePage()},r.prototype.jumpToSetHomePage=function(){return this.router.navigate("settings/home",{trigger:!0})},r}(n.View),o})}).call(this)