(function(){var e={}.hasOwnProperty,t=function(t,n){function i(){this.constructor=t}for(var r in n)e.call(n,r)&&(t[r]=n[r]);return i.prototype=n.prototype,t.prototype=new i,t.__super__=n.prototype,t};define(["underscore","backbone","util/util","model/user","model/loading","model/project_categories","view/navbar_view","view/loading_view","text!template/project.html","moment"],function(e,n,r,i,s,o,u,a,f,l){var c;return c=function(n){function c(){return c.__super__.constructor.apply(this,arguments)}return t(c,n),c.prototype.el="#main",c.prototype.template=e.template(f),c.prototype.initialize=function(t){var n,r,s,a;return e.bindAll(this),this.bindEvents(),this._preRender(),this.model=new o([],{id:t.spreadsheet_id}),this.user=new i,this.user.on("change:userName",this.userDataReady),n=document.getElementById("body"),n.className="1",console.log(n),r=new u({model:this.user}),this.model.on("reset",this.spreadSheetReady),a="onorientationchange"in window,s=a?"orientationchange":"resize",window.addEventListener(s,this._calculateColWidth)},c.prototype.bindEvents=function(){var e,t,n,r;this.$el.undelegate(".sub_category"),t={},e="createTouch"in document?"tap":"click";for(n=r=0;r<3;n=++r)t[""+e+" .category"+n]="tabSelected";return this.delegateEvents(t)},c.prototype._preRender=function(){return this.loadingView=new a({model:new s({message:"rendering Project page"})}),this.loadingView.render()},c.prototype.userDataReady=function(){return this.model.access_token=this.user.getAccessToken(),this.fetchProject()},c.prototype.fetchProject=function(){return this.model.fetch({dataType:"jsonp"})},c.prototype.spreadSheetReady=function(){return this.loadingView.empty(),this.render()},c.prototype._getWeeksFromNow=function(){var e,t,n;t=[];for(e=n=0;n<=7;e=++n)t[e]={name:l().day(1+e*7).format("MM/DD/YY"),landscapeOnly:e<4?"":"landscape_only"};return t},c.prototype.render=function(){var e,t,n,i;r.debug("render ProjectView"),this.$el.html(this.template({items:this.model.toJSON(),weeks:this._getWeeksFromNow()})),this._calculateColWidth(),$("#window_width").append("<p>"+window.innerWidth+"</p>"),t=this.model.toJSON().length,i=[];for(e=n=1;1<=t?n<t:n>t;e=1<=t?++n:--n)i.push(this.$el.find("#category"+e).hide());return i},c.prototype._calculateColWidth=function(){return window.orientation===90||window.orientation===-90?this.$el.find("table").addClass("landscape"):this.$el.find("table").removeClass("landscape")},c.prototype.tabSelected=function(e){var t,n,r,i,s;r=e.target.value,console.log(r),n=this.model.toJSON().length,s=[];for(t=i=0;0<=n?i<n:i>n;t=0<=n?++i:--i)t===Number(r)?s.push(this.$el.find("#category"+r).show()):s.push(this.$el.find("#category"+t).hide());return s},c}(n.View),c})}).call(this)