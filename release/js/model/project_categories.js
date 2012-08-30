(function(){var e={}.hasOwnProperty,t=function(t,n){function i(){this.constructor=t}for(var r in n)e.call(n,r)&&(t[r]=n[r]);return i.prototype=n.prototype,t.prototype=new i,t.__super__=n.prototype,t};define(["underscore","backbone","util/util","model/project_category","moment"],function(e,n,r,i,s){var o;return o=function(n){function r(){return r.__super__.constructor.apply(this,arguments)}return t(r,n),r.prototype.worksheetId=1,r.prototype.model=i,r.prototype.url=function(){return"https://spreadsheets.google.com/feeds/list/"+this.id+"/"+this.worksheetId+"/private/full?v=3&alt=json-in-script&access_token="+this.access_token},r.prototype.initialize=function(e,t){return this.id=t.id},r.prototype.parse=function(t){var n,r,i=this;return n=[],r=t.feed.entry,e.each(r,function(e){var t,r;if(!e.gsx$category)return;t=e.gsx$category.$t;if(t.length!==0)return n.push({name:t,subcategory:[i._parseSubCategory(e)]});r=n.length;if(r>0)return n[r-1].subcategory.push(i._parseSubCategory(e))}),n},r.prototype._parseSubCategory=function(e){var t,n,r,i;return i=e["gsx$sub-category"].$t,n=e.gsx$startdate.$t,t=e.gsx$enddate.$t,r={name:i,startDate:n,endDate:t,workingWeeks:this._parseWorkingWeeks(n,t)}},r.prototype._parseWorkingWeeks=function(e,t){var n,r,i,o,u,a,f,l,c,h,p,d,v,m,g,y,b,w,E,S;g=[];if((e!=null?e.length:void 0)===0||(t!=null?t.length:void 0)===0)return g;m=8,h=s(e,"M/D/YYYY"),r=s(t,"M/D/YYYY"),n=s().day(1),c=s().day(7+(m-1)*7),p=Math.ceil(h.diff(n,"days",!0)),i=Math.ceil(c.diff(r,"days",!0));for(u=y=0;0<=m?y<m:y>m;u=0<=m?++y:--y){g[u]="",v=[];if(p>=u*7&&p<=u*7+6){d=p-u*7+1;for(a=b=d;d<=7?b<7:b>7;a=d<=7?++b:--b)v[a]=!0}if(p<u*7&&i<(m-u)*7-6)for(f=w=0;w<7;f=++w)v[f]=!0;if(i>=(m-u)*7-6&&i<=(m-u)*7){o=(m-u)*7-i+1;for(l=E=0,S=o+1;0<=S?E<S:E>S;l=0<=S?++E:--E)v[l]=!0}g[u]=v}return g},r}(n.Collection),o})}).call(this)