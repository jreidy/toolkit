define ['underscore', 'backbone', 'model/location'], (_, Backbone, Location) ->
  class DataVisualization extends Backbone.View
   

    initialize: ->
      _.bindAll this

    renderPie:  (dataArray) ->
      hi = `
            function (dataArray) {
              document.getElementById("holder2").innerHTML = ""
              var r = Raphael("holder2");
              var xpos = 160;
              var ypos = 205;
              var radius = 90;
              radii = [];
              r.customAttributes.segment = function (i, x, y, r, a1, a2) {
                  var flag = (a2 - a1) > 180,
                      clr = (a2 - a1) / 360;
                  a1 = (a1 % 360) * Math.PI / 180;
                  a2 = (a2 % 360) * Math.PI / 180;

   

                  return {
                      path: [["M", x, y], ["l", r * Math.cos(a1), r * Math.sin(a1)], ["A", r, r, 0, +flag, 1, x + r * Math.cos(a2), y + r * Math.sin(a2)], ["z"]],
                      fill: "hsb(" + clr + ", .50, .8)"

                  };
              };

              function animate(ms) {
                  var start = 0,
                      val;
                  for (i = 0; i < ii; i++) {
                      val = 360 / total * data[i];
                      paths[i].animate({segment: [i, xpos, ypos, radii[i], start, start += val]}, ms || 1500, "bounce");
                      paths[i].angle = start - val / 2;
                  }
              }

              var data = dataArray,
                  paths = r.set(),
                  total,
                  start,
                  bg = r.circle(xpos, ypos, 0).attr({stroke: "#e9e9e9", "stroke-width": 4});
              data = data.sort(function (a, b) { return b - a;});

              total = 0;
              for (var i = 0, ii = data.length; i < ii; i++) {
                  total += data[i];
              }
              start = 0;
              for (i = 0; i < ii; i++) {
                  radii[i] = radius;
                  var val = 360 / total * data[i];
                  (function (i, val) {
                      segment = r.path().attr({segment: [i, xpos, ypos, 1, start, start + val], stroke: "#e9e9e9"});
                      segment.mousedown(function () {
                          if (radii[i] == radius) {
                            radii[i] = radius + 10;
                          } else {
                            radii[i] = radius;
                          }
                          
                          animate(650);

                          console.log("down");
                      });
                      
                      paths.push(segment);
                  })(i, val);

                  start += val;
              }
              bg.animate({r: radius + 1}, 1000, "bounce");
              animate(1000);
                
            }`
      hi(dataArray)

