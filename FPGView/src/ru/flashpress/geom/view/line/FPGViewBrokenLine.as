/**
 * Created by sam on 02.03.15.
 */
package ru.flashpress.geom.view.line
{
    import ru.flashpress.geom.FPGElement2d;
    import ru.flashpress.geom.core.ns.geometry2d;
    import ru.flashpress.geom.line.FPGLine2dFactory;
    import ru.flashpress.geom.line.broken.FPGBrokenLine2d;
    import ru.flashpress.geom.line.math.FPGLineToLine2dMath;
    import ru.flashpress.geom.point.FPGPoint2d;
    import ru.flashpress.geom.point.FPGPoint2dFactory;
    import ru.flashpress.geom.point.math.FPGPoint2dMath;
    import ru.flashpress.geom.view.FPGView;
    import ru.flashpress.geom.view.core.FPGFillData;
    import ru.flashpress.geom.view.core.drawDotline;
    import ru.flashpress.geom.view.point.FPGDrawPoint;
    import ru.flashpress.geom.view.point.FPGViewPoinTypes;
    import ru.flashpress.geom.view.point.FPGViewPoint;

    public class FPGViewBrokenLine extends FPGView
    {
        use namespace geometry2d;
        //
        private var _line:FPGBrokenLine2d;
        private var points:Vector.<FPGViewPoint>;
        private var _draw:FPGDrawLine;
        public function FPGViewBrokenLine(line:FPGBrokenLine2d=null, draw:FPGDrawLine=null)
        {
            super();
            //
            this._draw = draw ? draw : new FPGDrawLine(0xffffff*Math.random(), 0.5);
            //
            if (line) {
                this.data = line;
            }
        }

        private function createPoints():void
        {
            var i:int;
            var point:FPGViewPoint;
            var count:int = _line ? _line._points.length : 0;
            var dp:FPGDrawPoint;
            for (i=0; i<count; i++) {
                //
                if (i < count-1) {
                    dp = _draw.p1;
                } else {
                    dp = _draw.p2;
                }
                //
                if(i < this.points.length) {
                    point = this.points[i];
                    point.drawInfo = dp;
                } else {
                    point = new FPGViewPoint(_line._points[i], dp);
                    this.addChild(point);
                    points.push(point);
                }
                //
                point.data = _line._points[i];
            }
            while (this.points.length > count) {
                point = this.points.pop();
                point.remove();
                if (this.contains(point)) this.removeChild(point);
            }
        }

        protected override function change():void
        {
            super.change();
            //
            if (points && points.length) {
                var p1:FPGViewPoint = points[points.length-2];
                var p2:FPGViewPoint = points[points.length-1];
                if (p2._draw.type == FPGViewPoinTypes.ARROW) {
                    p2.rotateTo = FPGPoint2dMath.angleDirectionLines(FPGPoint2dFactory.ZERO, FPGPoint2dFactory.AXIS_X, p1._data as FPGPoint2d, p2._data as FPGPoint2d);
                }
            }
            //
            draw();
        }

        protected override function draw():void
        {
            super.draw();
            //
            if(_draw.thikness > 0 && _draw.color != -1) {
                container.graphics.lineStyle(_draw.thikness, _draw.color, _draw.alpha);
            }
            //
            if (this._line && this._line.length) {
                var i:int;
                var point:FPGPoint2d;
                for (i=0; i<this._line._points.length; i++) {
                    point = this._line._points[i];
                    //
                    if (i == 0) {
                        container.graphics.moveTo(point._x, point._y);
                    } else {
                        if(!_draw.dotline) {
                            container.graphics.lineTo(point._x, point._y);
                        } else {
                            drawDotline(container.graphics, this._line._points[i - 1], point);
                        }
                    }
                }
            }
        }
        protected override function setData(value:FPGElement2d):void
        {
            super.setData(value);
            this.draw();
            this.change();
        }

        public function get data():FPGBrokenLine2d {return this._line;}
        public function set data(value:FPGBrokenLine2d):void
        {
            this._line = value;
            //
            if (points) {
                createPoints();
            }
            //
            this.setData(value);
        }

        public override function set dragEnabled(value:Boolean):void
        {
            if (points) {
                var i:int;
                for (i=0; i<points.length; i++) {
                    points[i].dragEnabled = value;
                }
            }
        }
    }
}
