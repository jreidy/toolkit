

var canvas = document.getElementById("body_background");
canvas.width  = 640;
canvas.height = 960;

var topLeftBack = new Point(0, 1000);
var rectSizeBack = new Size(640, 740);
var back = new Path.Rectangle(topLeftBack, rectSizeBack);

var topLeft = new Point(0, 20);
var rectSize = new Size(425, 558);
var rectangleBack = new Path.Rectangle(topLeft, rectSize);
rectangleBack.fillColor = 'e9e9e9';

// greenTab.scale(0.5);
// greenTab.stretch(400);



    var group = new Group();
    for (i = 0; i < 4; i = i +1) {
        // var tab = ;
        // tab.posX(i * 100);

        group.addChild(new Tab(85));
        group.children[i].position.x = (i*108+50);
    }



    for (i = 0; i < 4; i = i +1) {
        if (i != 1) {
            group.children[i].children[0].fillColor = "d5d5d5";
            group.children[i].strokeColor = "d5d5d5";
            group.insertChild(0, group.children[i]);
        } else {
            // group.insertBelow(3, group.children[i]);
            group.children[i].children[0].fillColor = "e9e9e9";
        }
    }



function Tab(width) {

   
    this.tab = createTabWithWidth(width, 100);
    this.tab.scale(.6);

    this.shadow = createTabWithWidth(width, 100);
    this.shadow.scale(.6);

    this.shadow.blendmode = "multiply";


    this.shadow.position.x = 10;
    
    this.tab.position.y = 600;
    this.tab.fillColor = "e9e9e9";
    this.tab.strokeColor = "e9e9e9";

    var tabset = new Group ([this.tab, this.shadow]);

    return tabset;

    function createTabWithWidth(width, height) {
        var leftSide = createLeft(width, height);
        var rightSide = createRight(width, height);
        var rectangle = createRectangle(width, height);
        rectangle.position.x = width/2 + height;
        rightSide.position.x = height/2 + height + width;
        var tabs = new CompoundPath([leftSide, rectangle, rightSide]);
        var circle = new Path.Circle(15, 15);
        return tabs;
    }

    function createLeft(width, height) {
        var leftSide = new Path();
        var start = new Point(0, 0); 

        leftSide.add(start, [height, 0], [height, height]);
        leftSide.closed = true;

        leftSide.segments[0].handleIn.x = 61;
        leftSide.segments[0].handleIn.y = 19;
        leftSide.segments[2].handleOut.x = -40;
        return leftSide;
    }

    function createRight(width, height) {
        var rightSide = new Path();
        var start2 = new Point(height, 0); 

        rightSide.add(start2, [0, 0], [0, height]);
        rightSide.closed = true;

        rightSide.segments[0].handleIn.x = -61;
        rightSide.segments[0].handleIn.y = 19;
        rightSide.segments[2].handleOut.x = 40;

        return rightSide;
    }

    function createRectangle(width, height) {
        var topLeft = new Point(0, 0);
        var rectSize = new Size(width, height + 1);
        var rectangle = new Path.Rectangle(topLeft, rectSize);
        return rectangle;
    }

}

var hitOptions = {
    segments: true,
    stroke: true,
    fill: true,
    tolerance: 5
};

var segment, path;
var movePath = false;
function onMouseDown(event) {
    segment = path = null;
    var hitResult = group.hitTest(event.point, hitOptions);

    if (hitResult) {
        path = hitResult.item;
        console.log("please god");
    }

}







