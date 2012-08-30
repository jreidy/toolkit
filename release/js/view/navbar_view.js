(function(){var e={}.hasOwnProperty,t=function(t,n){function i(){this.constructor=t}for(var r in n)e.call(n,r)&&(t[r]=n[r]);return i.prototype=n.prototype,t.prototype=new i,t.__super__=n.prototype,t};define(["underscore","backbone","util/util","model/loading","view/loading_view","text!template/navbar.html","view/tab_navigation_controller"],function(e,n,r,i,s,o,u){var a;return a=function(n){function a(){return a.__super__.constructor.apply(this,arguments)}return t(a,n),a.prototype.el="#navbar",a.prototype.template=e.template(o),a.prototype.initialize=function(){e.bindAll(this),this.bindEvents(),this.router=window.EngApp.appRouter,this.model.on("change:userName",this.showUserName);if(!this.model.authorized())return this.jumpingToGoogleLogin()},a.prototype.bindEvents=function(){var e,t;return this.$el.undelegate("#logout"),this.$el.undelegate("#back"),e="createTouch"in document?"tap":"click",t={},t[""+e+" #beacon"]="navigate",t[""+e+" #projects"]="navigate",t[""+e+" #kpis"]="navigate",t[""+e+" #brownbag"]="navigate",t[""+e+" #logout"]="logout",t[""+e+" #back"]="back",t[""+e+" #settings"]="settings",this.delegateEvents(t)},a.prototype.jumpingToGoogleLogin=function(){var e;return e=new s({model:new i({message:"redirect to google authorization"})}),e.render(),r.loc.href=this.model.getAuthUrl()},a.prototype.render=function(){return this.$el.html(this.template(this.model.toJSON())),this.renderTabs()},a.prototype.renderTabs=function(){var e,t;return e=parseInt(document.getElementById("body").className),t=new u(e)},a.prototype.showUserName=function(){return this.model.isGreeAccount()||(alert("You should use gree account to login this app"),this.logout()),this.render(),this.toggleBackbutton()},a.prototype.toggleBackbutton=function(){var e,t;return e=this.$el.find("#back"),t=r.loc.hash,t.length>1&&t!=="#logout"?e.show():e.hide()},a.prototype.navigate=function(){return console.log(event.target.id),this.router.navigate(event.target.id,{trigger:!0})},a.prototype.logout=function(){if(confirm("Are you sure you want to log out?"))return this.model.destroy(),this.remove(),this.router.navigate("/#logout")},a.prototype.back=function(){var e,t;return e=r.loc.hash,t=e.split("/"),t[0]=t[0].substring(1),t.splice(0,0,""),this.router.navigate(t[t.length-2],{trigger:!0})},a.prototype.settings=function(){var e,t,n;return t="150px",n=document.getElementById("main"),n.style.top===t?(e=function(){$("#main").animate({top:"41px"},100,"toggle")},e()):(e=function(){$("#main").animate({top:t},100)},e()),console.log(n.style.top)},a}(n.View),a})}).call(this)