(function(){var e={}.hasOwnProperty,t=function(t,n){function i(){this.constructor=t}for(var r in n)e.call(n,r)&&(t[r]=n[r]);return i.prototype=n.prototype,t.prototype=new i,t.__super__=n.prototype,t};define(["underscore","backbone","model/location"],function(e,n,r){var i;return i=function(n){function r(){return r.__super__.constructor.apply(this,arguments)}return t(r,n),r.prototype.initialize=function(){return e.bindAll(this),this.renderPie()},r.prototype.renderPie=function(){var e;return e=function(e){function s(e){var t=0,i;for(c=0;c<h;c++)i=360/a*o[c],u[c].animate({segment:[c,n,r,radii[c],t,t+=i]},e||1500,"bounce"),u[c].angle=t-i/2}var t=Raphael("holder2"),n=160,r=205,i=90;radii=[],t.customAttributes.segment=function(e,t,n,r,i,s){var o=s-i>180,u=(s-i)/360;return i=i%360*Math.PI/180,s=s%360*Math.PI/180,{path:[["M",t,n],["l",r*Math.cos(i),r*Math.sin(i)],["A",r,r,0,+o,1,t+r*Math.cos(s),n+r*Math.sin(s)],["z"]],fill:"hsb("+u+", .50, .8)"}};var o=[1,8,2,7,5,2],u=t.set(),a,f,l=t.circle(n,r,0).attr({stroke:"#e9e9e9","stroke-width":4});o=o.sort(function(e,t){return t-e}),a=0;for(var c=0,h=o.length;c<h;c++)a+=o[c];f=0;for(c=0;c<h;c++){radii[c]=i;var p=360/a*o[c];(function(e,o){segment=t.path().attr({segment:[e,n,r,1,f,f+o],stroke:"#e9e9e9"}),segment.mousedown(function(){radii[e]==i?radii[e]=i+10:radii[e]=i,s(650),console.log("down")}),u.push(segment)})(c,p),f+=p}l.animate({r:i+1},1e3,"bounce"),s(1e3)},e()},r}(n.View)})}).call(this)