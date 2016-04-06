/**
 * Created by sam on 02.03.15.
 */
package ru.flashpress.geom.view.point
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;

    import ru.flashpress.geom.FPGElement2d;
    import ru.flashpress.geom.core.ns.geometry2d;
    import ru.flashpress.geom.point.FPGPoint2d;
    import ru.flashpress.geom.view.FPGView;

    public class FPGViewPoint extends FPGView
    {
        use namespace geometry2d;
        //
        geometry2d var _model:FPGPoint2d;
        geometry2d var _draw:FPGDrawPoint;
        public function FPGViewPoint(point:FPGPoint2d=null, draw:FPGDrawPoint=null)
        {
            super();
            this._draw = draw ? draw : new FPGDrawPoint(0xffffff*Math.random(), 0.5);
            super.setDrawInfo(_draw);
            //
            container = new Sprite();
            this.addChild(container);
            //
            this._model = point;
            //
            if (point) {
                this.data = point;
            }
            //
            this.addEventListener(MouseEvent.ROLL_OVER, overHandler);
        }
        private function overHandler(event:MouseEvent):void
        {
            //trace('point:', this.name, _model);
        }

        public function set drawInfo(value:FPGDrawPoint):void
        {
            setDrawInfo(value);
        }

        private var stageLink:Stage;
        private function downHandler(event:MouseEvent):void
        {
            stageLink = this.stage;
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMoveHandler);
            this.stage.addEventListener(MouseEvent.MOUSE_UP, stageUpHandler);
            this.startDrag();
        }
        private function stageMoveHandler(event:MouseEvent):void
        {
            event.updateAfterEvent();
            if (this._model) {
                this._model.update(this.x, this.y);
            }
        }
        private function stageUpHandler(event:MouseEvent):void
        {
            this.stopDrag();
            stageLink.removeEventListener(MouseEvent.MOUSE_MOVE, stageMoveHandler);
            stageLink.removeEventListener(MouseEvent.MOUSE_UP, stageUpHandler);
        }

        public function get data():FPGPoint2d {return this._model;}
        public function set data(value:FPGPoint2d):void
        {
            this._model = value;
            //
            this.setData(value);
        }


        private var drawed:Boolean;
        protected override function draw():void
        {
            super.draw();
            //
            drawed = true;
            switch (_draw.type) {
                case FPGViewPoinTypes.CIRCLE:
                    container.graphics.beginFill(_draw.color, _draw.alpha);
                    container.graphics.drawCircle(0, 0, _draw.size/2);
                    container.graphics.endFill();
                    break;
                case FPGViewPoinTypes.ARROW:
                    container.graphics.beginFill(_draw.color, _draw.alpha);
                    //
                    container.graphics.moveTo(-_draw.size, -_draw.size/2);
                    container.graphics.lineTo(0, 0);
                    container.graphics.lineTo(-_draw.size, _draw.size/2);
                    container.graphics.lineTo(-_draw.size, -_draw.size/2);
                    break;
                case FPGViewPoinTypes.MARK:
                    container.graphics.beginFill(0x0, 0);
                    container.graphics.drawRect(-_draw.size/2, -_draw.size/2, _draw.size, _draw.size);
                    container.graphics.endFill();
                    container.graphics.lineStyle(2, _draw.color, _draw.alpha);
                    //
                    container.graphics.moveTo(0, -_draw.size/2);
                    container.graphics.lineTo(0, _draw.size/2);
                    container.graphics.moveTo(-_draw.size/2, 0);
                    container.graphics.lineTo(_draw.size/2, 0);
                    break;
            }
        }
        protected override function setData(value:FPGElement2d):void
        {
            super.setData(value);
            this.change();
        }
        protected override function change():void
        {
            if (_model) {
                this.x = _model.x;
                this.y = _model.y;
                if (!drawed) {
                    draw();
                }
            } else {
                container.graphics.clear();
            }
            //
            super.change();
        }

        geometry2d function set rotateTo(angle:Number):void
        {
            container.rotation = angle*180/Math.PI;
        }

        public override function set dragEnabled(value:Boolean):void
        {
            this._dragEnabled = value;
            this.buttonMode = value;
            if (this._dragEnabled) {
                this.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
            } else {
                this.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
            }
        }

        public override function remove():void
        {
            super.remove();
            //
            if (stageLink) {
                this.stopDrag();
                stageLink.removeEventListener(MouseEvent.MOUSE_MOVE, stageMoveHandler);
                stageLink.removeEventListener(MouseEvent.MOUSE_UP, stageUpHandler);
                stageLink = null;
            }
            if (_model) {
                _model = null;
            }
        }
    }
}