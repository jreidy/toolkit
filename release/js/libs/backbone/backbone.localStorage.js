define(["underscore","backbone"],function(e,t){function n(){return((1+Math.random())*65536|0).toString(16).substring(1)}function r(){return n()+n()+"-"+n()+"-"+n()+"-"+n()+"-"+n()+n()+n()}t.LocalStorage=window.Store=function(e){this.name=e;var t=this.localStorage().getItem(this.name);this.data=t&&JSON.parse(t)||{}},e.extend(t.LocalStorage.prototype,{save:function(){localStorage.setItem(this.name,JSON.stringify(this.data))},create:function(e){return e.id||(e.id=e.attributes.id=r()),this.data[e.id]=e,this.save(),e},update:function(e){return this.data[e.id]=e,this.save(),e},find:function(e){return this.data[e.id]},findAll:function(){return e.values(this.data)},destroy:function(e){return delete this.data[e.id],this.save(),e},localStorage:function(){return localStorage}}),t.LocalStorage.sync=window.Store.sync=t.localSync=function(e,t,n,r){var i=t.localStorage||t.collection.localStorage;typeof n=="function"&&(n={success:n,error:r});var s;switch(e){case"read":s=t.id!=undefined?i.find(t):i.findAll();break;case"create":s=i.create(t);break;case"update":s=i.update(t);break;case"delete":s=i.destroy(t)}s?n.success(s):n.error("Record not found")},t.ajaxSync=t.sync,t.getSyncMethod=function(e){return e.localStorage||e.collection&&e.collection.localStorage?t.localSync:t.ajaxSync},t.sync=function(e,n,r,i){return t.getSyncMethod(n).apply(this,[e,n,r,i])}})