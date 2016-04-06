/**
 * Created by sam on 02.03.15.
 */
package ru.flashpress.geom.view
{
    import flash.display.Sprite;

    import ru.flashpress.callback.FPCaller;

    import ru.flashpress.callback.IFPTarget;

    import ru.flashpress.geom.FPGElement2d;
    import ru.flashpress.geom.core.ns.geometry2d;
    import ru.flashpress.geom.view.core.FPGDrawInfo;

    public class FPGView extends Sprite implements IFPTarget
    {
        use namespace geometry2d;

        public static const DRAG_BEGIN:String = 'viewDragBegin';
        public static const DRAG_CHANGE:String = 'viewDragChange';
        public static const DRAG_END:String = 'viewDragEnd';
        //
        protected var container:Sprite;
        public function FPGView()
        {
            super();
            //
            container = this;
            //
            _caller = new FPCaller(null, this, callback);
        }

        protected var _caller:FPCaller;
        public function get caller():FPCaller {return this._caller;}

        protected function callback(chanel:String, data:Object, caller:*, fcaller:*):int
        {
            switch (chanel) {
                case FPGElement2d.CHANGE:
                    change();
                    break;
                case FPGDrawInfo.CHANGE:
                    draw();
                    break;
            }
            return 0;
        }
        protected function change():void {}
        protected function draw():void
        {
            container.graphics.clear();
        }

        geometry2d var _data:FPGElement2d;
        protected function setData(value:FPGElement2d):void
        {
            if (this._data) {
                this._data.deleteForTarget(this);
            }
            //
            this._data = value;
            if (this._data) {
                this._data.registerTarget(FPGElement2d.CHANGE, this);
            }
        }

        private var _draw:FPGDrawInfo;
        protected function setDrawInfo(value:FPGDrawInfo):void
        {
            if (_draw) {
                _draw.deleteForTarget(this);
            }
            _draw = value;
            if (this._draw) {
                this._draw.registerTarget(FPGDrawInfo.CHANGE, this);
            }
        }


        public function remove():void
        {
            if (this._data) {
                this._data.deleteForTarget(this);
                this._data = null;
            }
        }

        protected  var _dragEnabled:Boolean;
        public function get dragEnabled():Boolean {return this._dragEnabled;}
        public function set dragEnabled(value:Boolean):void
        {
            this._dragEnabled = value;
        }
    }
}
