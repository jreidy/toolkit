function Tab(e){function n(e,t){var n=r(e,t),o=i(e,t),u=s(e,t);u.position.x=e/2+t,o.position.x=t/2+t+e;var a=new CompoundPath([n,u,o]),f=new Path.Circle(15,15);return a}function r(e,t){var n=new Path,r=new Point(0,0);return n.add(r,[t,0],[t,t]),n.closed=!0,n.segments[0].handleIn.x=61,n.segments[0].handleIn.y=19,n.segments[2].handleOut.x=-40,n}function i(e,t){var n=new Path,r=new Point(t,0);return n.add(r,[0,0],[0,t]),n.closed=!0,n.segments[0].handleIn.x=-61,n.segments[0].handleIn.y=19,n.segments[2].handleOut.x=40,n}function s(e,t){var n=new Point(0,0),r=new Size(e,t+1),i=new Path.Rectangle(n,r);return i}this.tab=n(e,100),this.tab.scale(.6),this.shadow=n(e,100),this.shadow.scale(.6),this.shadow.blendmode="multiply",this.shadow.position.x=10,this.tab.position.y=600,this.tab.fillColor="e9e9e9",this.tab.strokeColor="e9e9e9";var t=new Group([this.tab,this.shadow]);return t}function onMouseDown(e){segment=path=null;var t=group.hitTest(e.point,hitOptions);t&&(path=t.item,console.log("please god"))}var canvas=document.getElementById("body_background");canvas.width=640,canvas.height=960;var topLeftBack=new Point(0,1e3),rectSizeBack=new Size(640,740),back=new Path.Rectangle(topLeftBack,rectSizeBack),topLeft=new Point(0,20),rectSize=new Size(425,558),rectangleBack=new Path.Rectangle(topLeft,rectSize);rectangleBack.fillColor="e9e9e9";var group=new Group;for(i=0;i<4;i+=1)group.addChild(new Tab(85)),group.children[i].position.x=i*108+50;for(i=0;i<4;i+=1)i!=1?(group.children[i].children[0].fillColor="d5d5d5",group.children[i].strokeColor="d5d5d5",group.insertChild(0,group.children[i])):group.children[i].children[0].fillColor="e9e9e9";var hitOptions={segments:!0,stroke:!0,fill:!0,tolerance:5},segment,path,movePath=!1