/**
 * Created by sam on 02.03.15.
 */
package ru.flashpress.geom.view.line
{
    import ru.flashpress.geom.FPGElement2d;
    import ru.flashpress.geom.core.ns.geometry2d;
    import ru.flashpress.geom.line.FPGLine2d;
    import ru.flashpress.geom.line.FPGLine2dFactory;
    import ru.flashpress.geom.line.math.FPGLineToLine2dMath;
    import ru.flashpress.geom.view.FPGView;
    import ru.flashpress.geom.view.core.drawDotline;
    import ru.flashpress.geom.view.point.FPGViewPoinTypes;
    import ru.flashpress.geom.view.point.FPGViewPoint;

    public class FPGViewLine extends FPGView
    {
        use namespace geometry2d;
        //
        private var _line:FPGLine2d;
        private var point1:FPGViewPoint;
        private var point2:FPGViewPoint;
        private var _draw:FPGDrawLine;
        public function FPGViewLine(line:FPGLine2d, draw:FPGDrawLine=null)
        {
            super();
            this._draw = draw ? draw : new FPGDrawLine(0xffffff*Math.random(), 0.5, 1);
            //
            point1 = new FPGViewPoint(null, _draw.p1);
            this.addChild(point1);
            //
            point2 = new FPGViewPoint(null, _draw.p2);
            this.addChild(point2);
            //
            if (line) {
                this.data = line;
            }
        }

        protected override function change():void
        {
            super.change();
            //
            if (point2 && point2._draw.type == FPGViewPoinTypes.ARROW) {
                point2.rotateTo = FPGLineToLine2dMath.angleDirectionLines(FPGLine2dFactory.AXIS_X, this._line);
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
            if (_line) {
                container.graphics.moveTo(_line._p1.x, _line._p1.y);
                if (!_draw.dotline) {
                    container.graphics.lineTo(_line._p2.x, _line._p2.y);
                } else {
                    drawDotline(container.graphics, _line._p1, _line._p2);
                }
            }
        }
        protected override function setData(value:FPGElement2d):void
        {
            super.setData(value);
            //
            if (this._line) {
                if(point1) point1.data = this._line._p1;
                if(point2) point2.data = this._line._p2;
            } else {
                if(point1) point1.data = null;
                if(point2) point2.data = null;
            }
            //
            this.change();
        }

        public function get p1():FPGViewPoint {return point1;}
        public function get p2():FPGViewPoint {return point2;}

        public function get data():FPGLine2d {return this._line;}
        public function set data(value:FPGLine2d):void
        {
            this._line = value;
            //
            this.setData(value);
        }

        public override function set dragEnabled(value:Boolean):void
        {
            super.dragEnabled = value;
            if (point1) {
                point1.dragEnabled = value;
                point1.data.registerTarget(FPGElement2d.CHANGE, this);
            }
            if (point2) {
                point2.dragEnabled = value;
                point2.data.registerTarget(FPGElement2d.CHANGE, this);
            }
        }
    }
}
