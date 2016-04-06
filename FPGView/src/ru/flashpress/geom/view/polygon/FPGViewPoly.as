/**
 * Created by sam on 25.12.15.
 */
package ru.flashpress.geom.view.polygon {
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    import ru.flashpress.geom.core.ns.geometry2d;
    import ru.flashpress.geom.point.FPGPoint2d;
    import ru.flashpress.geom.polygon.FPGPolygon2d;
    import ru.flashpress.geom.polygon.FPGVertex2d;
    import ru.flashpress.geom.view.FPGView;
    import ru.flashpress.geom.view.core.drawDotline;
    import ru.flashpress.geom.view.point.FPGViewPoint;

    public class FPGViewPoly extends FPGView
    {
        use namespace geometry2d;

        private var _model:FPGPolygon2d;
        private var _draw:FPGDrawPoly;
        private var pointsCont:Sprite;
        private var pointsList:Vector.<FPGViewPoint>;
        public function FPGViewPoly(model:FPGPolygon2d=null, draw:FPGDrawPoly=null)
        {
            super();
            this._draw = draw ? draw : new FPGDrawPoly(0xffffff*Math.random(), 1);
            //
            pointsCont = new Sprite();
            this.addChild(pointsCont);
            pointsList = new <FPGViewPoint>[];
            //
            if (model) {
                this.data = model;
            }
        }

        private var translate:Point = new Point();
        private function downHandler(event:MouseEvent):void
        {
            if (event.target != this) return;
            _caller.dispatchCallback(DRAG_BEGIN);
            translate.x = this.mouseX;
            translate.y = this.mouseY;
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
            this.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
        }
        private function moveHandler(event:MouseEvent):void
        {
            event.updateAfterEvent();
            _model.translate(mouseX-translate.x, mouseY-translate.y);
            translate.x = this.mouseX;
            translate.y = this.mouseY;
        }
        private function upHandler(event:MouseEvent):void
        {
            _caller.dispatchCallback(DRAG_END);
            this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
            this.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
        }

        private var _pointsDragEnabled:Boolean;
        public function set pointsDragEnabled(value:Boolean):void
        {
            _pointsDragEnabled = value;
            var i:int;
            for (i=0; i<pointsList.length; i++) {
                pointsList[i].dragEnabled = _pointsDragEnabled;
            }
        }

        public override function set dragEnabled(value:Boolean):void
        {
            super.dragEnabled = value;
            if (value) {
                this.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
            } else {
                this.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
            }
        }

        private function createPoints():void
        {
            pointsCont.removeChildren();
            if (!_model) return;
            if (!_draw.points) return;
            //
            var vertex:FPGVertex2d;
            var i:int;
            var point:FPGViewPoint;
            for (i=0; i<_model._vertexes.length; i++) {
                vertex = _model._vertexes[i];
                point = new FPGViewPoint(vertex);
                point.name = 'point_'+i;
                point.dragEnabled = this._pointsDragEnabled;
                pointsList.push(point);
                pointsCont.addChild(point);
            }
        }

        protected override function change():void
        {
            super.change();
            //
            draw();
        }

        protected override function draw():void
        {
            super.draw();
            if (!_model) return;
            //
            if(_draw.line && _draw.line.thikness > 0 && _draw.line.color != -1) {
                container.graphics.lineStyle(_draw.line.thikness, _draw.line.color, _draw.line.alpha);
            }
            if(_draw.color != -1) {
                container.graphics.beginFill(_draw.color, _draw.alpha);
            }
            //
            var v1:FPGVertex2d = _model._vertexes[0];
            var v2:FPGVertex2d;
            container.graphics.moveTo(v1._x, v1._y);
            var i:int;
            for (i=1; i<_model._vertexes.length; i++) {
                v2 = _model._vertexes[i];
                drawSegment(v1, v2);
                v1 = v2;
            }
            drawSegment(v1, _model._vertexes[0]);
            container.graphics.endFill();
        }
        private function drawSegment(v1:FPGPoint2d, v2:FPGPoint2d):void
        {
            if (_draw.line && _draw.line.dotline) {
                drawDotline(container.graphics, v1, v2);
            } else {
                container.graphics.lineTo(v2._x, v2._y);
            }
        }

        public function get data():FPGPolygon2d {return _model;}
        public function set data(value:FPGPolygon2d):void
        {
            this._model = value;
            super.setData(value);
            //
            createPoints();
            //
            this.change();
        }
    }
}
