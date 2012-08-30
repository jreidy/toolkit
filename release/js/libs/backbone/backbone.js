//     (c) 2010-2012 Jeremy Ashkenas, DocumentCloud Inc.
//     Backbone may be freely distributed under the MIT license.
//     For all details and documentation:
//     http://backbonejs.org

(function(e,t){typeof exports!="undefined"?t(e,exports,require("underscore")):typeof define=="function"&&define.amd?(dol=e.jQuery?"jquery":"zepto",define(["underscore",dol,"exports"],function(n,r,i){e.Backbone=t(e,i,n,r)})):e.Backbone=t(e,{},e._,e.jQuery||e.Zepto||e.ender)})(this,function(e,t,n,r){var i=e.Backbone,s=Array.prototype.slice,o=Array.prototype.splice;t.VERSION="0.9.2",t.setDomLibrary=function(e){r=e},t.noConflict=function(){return e.Backbone=i,t},t.emulateHTTP=!1,t.emulateJSON=!1;var u=/\s+/,a=t.Events={on:function(e,t,n){var r,i,s,o,a;if(!t)return this;e=e.split(u),r=this._callbacks||(this._callbacks={});while(i=e.shift())a=r[i],s=a?a.tail:{},s.next=o={},s.context=n,s.callback=t,r[i]={tail:o,next:a?a.next:s};return this},off:function(e,t,r){var i,s,o,a,f,l;if(!(s=this._callbacks))return;if(!(e||t||r))return delete this._callbacks,this;e=e?e.split(u):n.keys(s);while(i=e.shift()){o=s[i],delete s[i];if(!o||!t&&!r)continue;a=o.tail;while((o=o.next)!==a)f=o.callback,l=o.context,(t&&f!==t||r&&l!==r)&&this.on(i,f,l)}return this},trigger:function(e){var t,n,r,i,o,a,f;if(!(r=this._callbacks))return this;a=r.all,e=e.split(u),f=s.call(arguments,1);while(t=e.shift()){if(n=r[t]){i=n.tail;while((n=n.next)!==i)n.callback.apply(n.context||this,f)}if(n=a){i=n.tail,o=[t].concat(f);while((n=n.next)!==i)n.callback.apply(n.context||this,o)}}return this}};a.bind=a.on,a.unbind=a.off;var f=t.Model=function(e,t){var r;e||(e={}),t&&t.parse&&(e=this.parse(e));if(r=C(this,"defaults"))e=n.extend({},r,e);t&&t.collection&&(this.collection=t.collection),this.attributes={},this._escapedAttributes={},this.cid=n.uniqueId("c"),this.changed={},this._silent={},this._pending={},this.set(e,{silent:!0}),this.changed={},this._silent={},this._pending={},this._previousAttributes=n.clone(this.attributes),this.initialize.apply(this,arguments)};n.extend(f.prototype,a,{changed:null,_silent:null,_pending:null,idAttribute:"id",initialize:function(){},toJSON:function(e){return n.clone(this.attributes)},get:function(e){return this.attributes[e]},escape:function(e){var t;if(t=this._escapedAttributes[e])return t;var r=this.get(e);return this._escapedAttributes[e]=n.escape(r==null?"":""+r)},has:function(e){return this.get(e)!=null},set:function(e,t,r){var i,s,o;n.isObject(e)||e==null?(i=e,r=t):(i={},i[e]=t),r||(r={});if(!i)return this;i instanceof f&&(i=i.attributes);if(r.unset)for(s in i)i[s]=void 0;if(!this._validate(i,r))return!1;this.idAttribute in i&&(this.id=i[this.idAttribute]);var u=r.changes={},a=this.attributes,l=this._escapedAttributes,c=this._previousAttributes||{};for(s in i){o=i[s];if(!n.isEqual(a[s],o)||r.unset&&n.has(a,s))delete l[s],(r.silent?this._silent:u)[s]=!0;r.unset?delete a[s]:a[s]=o,!n.isEqual(c[s],o)||n.has(a,s)!=n.has(c,s)?(this.changed[s]=o,r.silent||(this._pending[s]=!0)):(delete this.changed[s],delete this._pending[s])}return r.silent||this.change(r),this},unset:function(e,t){return(t||(t={})).unset=!0,this.set(e,null,t)},clear:function(e){return(e||(e={})).unset=!0,this.set(n.clone(this.attributes),e)},fetch:function(e){e=e?n.clone(e):{};var r=this,i=e.success;return e.success=function(t,n,s){if(!r.set(r.parse(t,s),e))return!1;i&&i(r,t)},e.error=t.wrapError(e.error,r,e),(this.sync||t.sync).call(this,"read",this,e)},save:function(e,r,i){var s,o;n.isObject(e)||e==null?(s=e,i=r):(s={},s[e]=r),i=i?n.clone(i):{};if(i.wait){if(!this._validate(s,i))return!1;o=n.clone(this.attributes)}var u=n.extend({},i,{silent:!0});if(s&&!this.set(s,i.wait?u:i))return!1;var a=this,f=i.success;i.success=function(e,t,r){var o=a.parse(e,r);i.wait&&(delete i.wait,o=n.extend(s||{},o));if(!a.set(o,i))return!1;f?f(a,e):a.trigger("sync",a,e,i)},i.error=t.wrapError(i.error,a,i);var l=this.isNew()?"create":"update",c=(this.sync||t.sync).call(this,l,this,i);return i.wait&&this.set(o,u),c},destroy:function(e){e=e?n.clone(e):{};var r=this,i=e.success,s=function(){r.trigger("destroy",r,r.collection,e)};if(this.isNew())return s(),!1;e.success=function(t){e.wait&&s(),i?i(r,t):r.trigger("sync",r,t,e)},e.error=t.wrapError(e.error,r,e);var o=(this.sync||t.sync).call(this,"delete",this,e);return e.wait||s(),o},url:function(){var e=C(this,"urlRoot")||C(this.collection,"url")||k();return this.isNew()?e:e+(e.charAt(e.length-1)=="/"?"":"/")+encodeURIComponent(this.id)},parse:function(e,t){return e},clone:function(){return new this.constructor(this.attributes)},isNew:function(){return this.id==null},change:function(e){e||(e={});var t=this._changing;this._changing=!0;for(var r in this._silent)this._pending[r]=!0;var i=n.extend({},e.changes,this._silent);this._silent={};for(var r in i)this.trigger("change:"+r,this,this.get(r),e);if(t)return this;while(!n.isEmpty(this._pending)){this._pending={},this.trigger("change",this,e);for(var r in this.changed){if(this._pending[r]||this._silent[r])continue;delete this.changed[r]}this._previousAttributes=n.clone(this.attributes)}return this._changing=!1,this},hasChanged:function(e){return arguments.length?n.has(this.changed,e):!n.isEmpty(this.changed)},changedAttributes:function(e){if(!e)return this.hasChanged()?n.clone(this.changed):!1;var t,r=!1,i=this._previousAttributes;for(var s in e){if(n.isEqual(i[s],t=e[s]))continue;(r||(r={}))[s]=t}return r},previous:function(e){return!arguments.length||!this._previousAttributes?null:this._previousAttributes[e]},previousAttributes:function(){return n.clone(this._previousAttributes)},isValid:function(){return!this.validate(this.attributes)},_validate:function(e,t){if(t.silent||!this.validate)return!0;e=n.extend({},this.attributes,e);var r=this.validate(e,t);return r?(t&&t.error?t.error(this,r,t):this.trigger("error",this,r,t),!1):!0}});var l=t.Collection=function(e,t){t||(t={}),t.model&&(this.model=t.model),t.comparator&&(this.comparator=t.comparator),this._reset(),this.initialize.apply(this,arguments),e&&this.reset(e,{silent:!0,parse:t.parse})};n.extend(l.prototype,a,{model:f,initialize:function(){},toJSON:function(e){return this.map(function(t){return t.toJSON(e)})},add:function(e,t){var r,i,s,u,a,f,l={},c={},h=[];t||(t={}),e=n.isArray(e)?e.slice():[e];for(r=0,s=e.length;r<s;r++){if(!(u=e[r]=this._prepareModel(e[r],t)))throw new Error("Can't add an invalid model to a collection");a=u.cid,f=u.id;if(l[a]||this._byCid[a]||f!=null&&(c[f]||this._byId[f])){h.push(r);continue}l[a]=c[f]=u}r=h.length;while(r--)e.splice(h[r],1);for(r=0,s=e.length;r<s;r++)(u=e[r]).on("all",this._onModelEvent,this),this._byCid[u.cid]=u,u.id!=null&&(this._byId[u.id]=u);this.length+=s,i=t.at!=null?t.at:this.models.length,o.apply(this.models,[i,0].concat(e)),this.comparator&&this.sort({silent:!0});if(t.silent)return this;for(r=0,s=this.models.length;r<s;r++){if(!l[(u=this.models[r]).cid])continue;t.index=r,u.trigger("add",u,this,t)}return this},remove:function(e,t){var r,i,s,o;t||(t={}),e=n.isArray(e)?e.slice():[e];for(r=0,i=e.length;r<i;r++){o=this.getByCid(e[r])||this.get(e[r]);if(!o)continue;delete this._byId[o.id],delete this._byCid[o.cid],s=this.indexOf(o),this.models.splice(s,1),this.length--,t.silent||(t.index=s,o.trigger("remove",o,this,t)),this._removeReference(o)}return this},push:function(e,t){return e=this._prepareModel(e,t),this.add(e,t),e},pop:function(e){var t=this.at(this.length-1);return this.remove(t,e),t},unshift:function(e,t){return e=this._prepareModel(e,t),this.add(e,n.extend({at:0},t)),e},shift:function(e){var t=this.at(0);return this.remove(t,e),t},get:function(e){return e==null?void 0:this._byId[e.id!=null?e.id:e]},getByCid:function(e){return e&&this._byCid[e.cid||e]},at:function(e){return this.models[e]},where:function(e){return n.isEmpty(e)?[]:this.filter(function(t){for(var n in e)if(e[n]!==t.get(n))return!1;return!0})},sort:function(e){e||(e={});if(!this.comparator)throw new Error("Cannot sort a set without a comparator");var t=n.bind(this.comparator,this);return this.comparator.length==1?this.models=this.sortBy(t):this.models.sort(t),e.silent||this.trigger("reset",this,e),this},pluck:function(e){return n.map(this.models,function(t){return t.get(e)})},reset:function(e,t){e||(e=[]),t||(t={});for(var r=0,i=this.models.length;r<i;r++)this._removeReference(this.models[r]);return this._reset(),this.add(e,n.extend({silent:!0},t)),t.silent||this.trigger("reset",this,t),this},fetch:function(e){e=e?n.clone(e):{},e.parse===undefined&&(e.parse=!0);var r=this,i=e.success;return e.success=function(t,n,s){r[e.add?"add":"reset"](r.parse(t,s),e),i&&i(r,t)},e.error=t.wrapError(e.error,r,e),(this.sync||t.sync).call(this,"read",this,e)},create:function(e,t){var r=this;t=t?n.clone(t):{},e=this._prepareModel(e,t);if(!e)return!1;t.wait||r.add(e,t);var i=t.success;return t.success=function(n,s,o){t.wait&&r.add(n,t),i?i(n,s):n.trigger("sync",e,s,t)},e.save(null,t),e},parse:function(e,t){return e},chain:function(){return n(this.models).chain()},_reset:function(e){this.length=0,this.models=[],this._byId={},this._byCid={}},_prepareModel:function(e,t){t||(t={});if(e instanceof f)e.collection||(e.collection=this);else{var n=e;t.collection=this,e=new this.model(n,t),e._validate(e.attributes,t)||(e=!1)}return e},_removeReference:function(e){this==e.collection&&delete e.collection,e.off("all",this._onModelEvent,this)},_onModelEvent:function(e,t,n,r){if((e=="add"||e=="remove")&&n!=this)return;e=="destroy"&&this.remove(t,r),t&&e==="change:"+t.idAttribute&&(delete this._byId[t.previous(t.idAttribute)],this._byId[t.id]=t),this.trigger.apply(this,arguments)}});var c=["forEach","each","map","reduce","reduceRight","find","detect","filter","select","reject","every","all","some","any","include","contains","invoke","max","min","sortBy","sortedIndex","toArray","size","first","initial","rest","last","without","indexOf","shuffle","lastIndexOf","isEmpty","groupBy"];n.each(c,function(e){l.prototype[e]=function(){return n[e].apply(n,[this.models].concat(n.toArray(arguments)))}});var h=t.Router=function(e){e||(e={}),e.routes&&(this.routes=e.routes),this._bindRoutes(),this.initialize.apply(this,arguments)},p=/:\w+/g,d=/\*\w+/g,v=/[-[\]{}()+?.,\\^$|#\s]/g;n.extend(h.prototype,a,{initialize:function(){},route:function(e,r,i){return t.history||(t.history=new m),n.isRegExp(e)||(e=this._routeToRegExp(e)),i||(i=this[r]),t.history.route(e,n.bind(function(n){var s=this._extractParameters(e,n);i&&i.apply(this,s),this.trigger.apply(this,["route:"+r].concat(s)),t.history.trigger("route",this,r,s)},this)),this},navigate:function(e,n){t.history.navigate(e,n)},_bindRoutes:function(){if(!this.routes)return;var e=[];for(var t in this.routes)e.unshift([t,this.routes[t]]);for(var n=0,r=e.length;n<r;n++)this.route(e[n][0],e[n][1],this[e[n][1]])},_routeToRegExp:function(e){return e=e.replace(v,"\\$&").replace(p,"([^/]+)").replace(d,"(.*?)"),new RegExp("^"+e+"$")},_extractParameters:function(e,t){return e.exec(t).slice(1)}});var m=t.History=function(){this.handlers=[],n.bindAll(this,"checkUrl")},g=/^[#\/]/,y=/msie [\w.]+/;m.started=!1,n.extend(m.prototype,a,{interval:50,getHash:function(e){var t=e?e.location:window.location,n=t.href.match(/#(.*)$/);return n?n[1]:""},getFragment:function(e,t){if(e==null)if(this._hasPushState||t){e=window.location.pathname;var n=window.location.search;n&&(e+=n)}else e=this.getHash();return e.indexOf(this.options.root)||(e=e.substr(this.options.root.length)),e.replace(g,"")},start:function(e){if(m.started)throw new Error("Backbone.history has already been started");m.started=!0,this.options=n.extend({},{root:"/"},this.options,e),this._wantsHashChange=this.options.hashChange!==!1,this._wantsPushState=!!this.options.pushState,this._hasPushState=!!(this.options.pushState&&window.history&&window.history.pushState);var t=this.getFragment(),i=document.documentMode,s=y.exec(navigator.userAgent.toLowerCase())&&(!i||i<=7);s&&(this.iframe=r('<iframe src="javascript:0" tabindex="-1" />').hide().appendTo("body")[0].contentWindow,this.navigate(t)),this._hasPushState?r(window).bind("popstate",this.checkUrl):this._wantsHashChange&&"onhashchange"in window&&!s?r(window).bind("hashchange",this.checkUrl):this._wantsHashChange&&(this._checkUrlInterval=setInterval(this.checkUrl,this.interval)),this.fragment=t;var o=window.location,u=o.pathname==this.options.root;if(this._wantsHashChange&&this._wantsPushState&&!this._hasPushState&&!u)return this.fragment=this.getFragment(null,!0),window.location.replace(this.options.root+"#"+this.fragment),!0;this._wantsPushState&&this._hasPushState&&u&&o.hash&&(this.fragment=this.getHash().replace(g,""),window.history.replaceState({},document.title,o.protocol+"//"+o.host+this.options.root+this.fragment));if(!this.options.silent)return this.loadUrl()},stop:function(){r(window).unbind("popstate",this.checkUrl).unbind("hashchange",this.checkUrl),clearInterval(this._checkUrlInterval),m.started=!1},route:function(e,t){this.handlers.unshift({route:e,callback:t})},checkUrl:function(e){var t=this.getFragment();t==this.fragment&&this.iframe&&(t=this.getFragment(this.getHash(this.iframe)));if(t==this.fragment)return!1;this.iframe&&this.navigate(t),this.loadUrl()||this.loadUrl(this.getHash())},loadUrl:function(e){var t=this.fragment=this.getFragment(e),r=n.any(this.handlers,function(e){if(e.route.test(t))return e.callback(t),!0});return r},navigate:function(e,t){if(!m.started)return!1;if(!t||t===!0)t={trigger:t};var n=(e||"").replace(g,"");if(this.fragment==n)return;this._hasPushState?(n.indexOf(this.options.root)!=0&&(n=this.options.root+n),this.fragment=n,window.history[t.replace?"replaceState":"pushState"]({},document.title,n)):this._wantsHashChange?(this.fragment=n,this._updateHash(window.location,n,t.replace),this.iframe&&n!=this.getFragment(this.getHash(this.iframe))&&(t.replace||this.iframe.document.open().close(),this._updateHash(this.iframe.location,n,t.replace))):window.location.assign(this.options.root+e),t.trigger&&this.loadUrl(e)},_updateHash:function(e,t,n){n?e.replace(e.toString().replace(/(javascript:|#).*$/,"")+"#"+t):e.hash=t}});var b=t.View=function(e){this.cid=n.uniqueId("view"),this._configure(e||{}),this._ensureElement(),this.initialize.apply(this,arguments),this.delegateEvents()},w=/^(\S+)\s*(.*)$/,E=["model","collection","el","id","attributes","className","tagName"];n.extend(b.prototype,a,{tagName:"div",$:function(e){return this.$el.find(e)},initialize:function(){},render:function(){return this},remove:function(){return this.$el.remove(),this},make:function(e,t,n){var i=document.createElement(e);return t&&r(i).attr(t),n!=null&&r(i).html(n),i},setElement:function(e,t){return this.$el&&this.undelegateEvents(),this.$el=e instanceof r?e:r(e),this.el=this.$el[0],t!==!1&&this.delegateEvents(),this},delegateEvents:function(e){if(!e&&!(e=C(this,"events")))return;this.undelegateEvents();for(var t in e){var r=e[t];n.isFunction(r)||(r=this[e[t]]);if(!r)throw new Error('Method "'+e[t]+'" does not exist');var i=t.match(w),s=i[1],o=i[2];r=n.bind(r,this),s+=".delegateEvents"+this.cid,o===""?this.$el.bind(s,r):this.$el.delegate(o,s,r)}},undelegateEvents:function(){this.$el.unbind(".delegateEvents"+this.cid)},_configure:function(e){this.options&&(e=n.extend({},this.options,e));for(var t=0,r=E.length;t<r;t++){var i=E[t];e[i]&&(this[i]=e[i])}this.options=e},_ensureElement:function(){if(!this.el){var e=C(this,"attributes")||{};this.id&&(e.id=this.id),this.className&&(e["class"]=this.className),this.setElement(this.make(this.tagName,e),!1)}else this.setElement(this.el,!1)}});var S=function(e,t){var n=N(this,e,t);return n.extend=this.extend,n};f.extend=l.extend=h.extend=b.extend=S;var x={create:"POST",update:"PUT","delete":"DELETE",read:"GET"};t.sync=function(e,i,s){var o=x[e];s||(s={});var u={type:o,dataType:"json"};return s.url||(u.url=C(i,"url")||k()),!s.data&&i&&(e=="create"||e=="update")&&(u.contentType="application/json",u.data=JSON.stringify(i.toJSON())),t.emulateJSON&&(u.contentType="application/x-www-form-urlencoded",u.data=u.data?{model:u.data}:{}),t.emulateHTTP&&(o==="PUT"||o==="DELETE")&&(t.emulateJSON&&(u.data._method=o),u.type="POST",u.beforeSend=function(e){e.setRequestHeader("X-HTTP-Method-Override",o)}),u.type!=="GET"&&!t.emulateJSON&&(u.processData=!1),r.ajax(n.extend(u,s))},t.wrapError=function(e,t,n){return function(r,i){i=r===t?i:r,e?e(t,i,n):t.trigger("error",t,i,n)}};var T=function(){},N=function(e,t,r){var i;return t&&t.hasOwnProperty("constructor")?i=t.constructor:i=function(){e.apply(this,arguments)},n.extend(i,e),T.prototype=e.prototype,i.prototype=new T,t&&n.extend(i.prototype,t),r&&n.extend(i,r),i.prototype.constructor=i,i.__super__=e.prototype,i},C=function(e,t){return!e||!e[t]?null:n.isFunction(e[t])?e[t]():e[t]},k=function(){throw new Error('A "url" property or function must be specified')};return t})