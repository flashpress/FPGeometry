/**
 * Created by sam on 25.12.15.
 */
package {
    import core.CBSprite;
    import core.Share;

    import flash.events.Event;
    import flash.events.MouseEvent;

    import ru.flashpress.geom.FPGElement2d;

    import ru.flashpress.geom.point.FPGPoint2d;

    import ru.flashpress.geom.polygon.FPGPolygon2d;
    import ru.flashpress.geom.polygon.math.FPGPolyToPoly2dMath;
    import ru.flashpress.geom.view.FPGView;
    import ru.flashpress.geom.view.line.FPGDrawLine;
    import ru.flashpress.geom.view.polygon.FPGDrawPoly;

    import ru.flashpress.geom.view.polygon.FPGViewPoly;

    public class TestCross extends CBSprite
    {
        private var poly1:FPGViewPoly;
        private var poly2:FPGViewPoly;
        private var cross:FPGViewPoly;
        public function TestCross()
        {
            poly1 = new FPGViewPoly(null, new FPGDrawPoly(0xff0000, 0.3));
            poly1.name = 'poly11';
            poly1.dragEnabled = true;
            poly1.pointsDragEnabled = true;
            this.addChild(poly1);
            var model:FPGPolygon2d = loadPoly(poly1.name);
            if (!model) model = createPoly(200, 200, 5);
            model.name = poly1.name;
            poly1.data = model;
            //
            this.addEventListener(Event.ENTER_FRAME, frameHandler);
            //this.stage.addEventListener(MouseEvent.CLICK, clickHandler);
            //
            poly2 = new FPGViewPoly(null, new FPGDrawPoly(0x009900, 0.5));
            poly2.name = 'poly21';
            poly2.dragEnabled = true;
            poly2.pointsDragEnabled = true;
            this.addChild(poly2);
            model = loadPoly(poly2.name);
            if (!model) model = createPoly(200, 200, 8);
            model.name = poly2.name;
            poly2.data = model;
            //
            poly1.caller.registerTarget(FPGView.DRAG_END, this);
            poly2.caller.registerTarget(FPGView.DRAG_END, this);
            poly1.data.registerTarget(FPGElement2d.CHANGE, this, -1000);
            poly2.data.registerTarget(FPGElement2d.CHANGE, this, -1000);
            //
            var draw:FPGDrawPoly = new FPGDrawPoly(-1, 1, new FPGDrawLine(0xff0000, 1, 2));
            cross = new FPGViewPoly(null, draw);
            this.addChild(cross);
            //
            changeModel();
        }

        private function loadPoly(name:String):FPGPolygon2d
        {
            var list:Vector.<Object> = Share.open(name, null) as Vector.<Object>;
            if (!list) return null;
            var i:int;
            var points:Vector.<FPGPoint2d> = new <FPGPoint2d>[];
            for (i=0; i<list.length; i++) {
                points.push(new FPGPoint2d(list[i].x, list[i].y));
            }
            return new FPGPolygon2d(points);
        }

        private function clickHandler(event:MouseEvent):void
        {
            frameHandler();
        }

        private function frameHandler(event:Event=null):void
        {
            poly1.data.rotation(Math.PI/180);
        }

        private function createPoly(x:int, y:int, count:int=4, r:Number=60):FPGPolygon2d
        {
            var points:Vector.<FPGPoint2d> = new <FPGPoint2d>[];
            var i:int;
            var a:Number = Math.PI*2/count;
            for (i=0; i<count; i++) {
                points.push(new FPGPoint2d(x+r*Math.cos(a*i), y+r*Math.sin(a*i)));
            }
            var model:FPGPolygon2d = new FPGPolygon2d(points);
            model.rotation(Math.PI/4);
            return model;
        }

        private function changeModel():void
        {
            cross.data = FPGPolyToPoly2dMath.cross(poly1.data, poly2.data);
            //cross.data = FPGPolyToPoly2dMath.add(poly1.data, poly2.data)[0];
        }

        protected override function callback(chanel:String, data:Object, caller:*, fcaller:*):int
        {
            switch (chanel) {
                case FPGElement2d.CHANGE:
                    changeModel();
                    break;
                case FPGView.DRAG_END:
                    var targetView:FPGViewPoly = caller;
                    Share.save(targetView.name, targetView.data.vertexes);
                    break;
            }
            //
            return 0;
        }
    }
}
