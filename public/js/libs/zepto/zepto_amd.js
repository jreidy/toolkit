define(['libs/zepto/zepto', 'libs/zepto/deferred'], function() {
  this.Deferred.installInto(this.Zepto)
  return this.Zepto;
});