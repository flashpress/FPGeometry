/**
 * Created by sam on 25.12.15.
 */
package ru.flashpress.geom.view.core {
    import ru.flashpress.callback.FPCaller;

    public class FPGDrawInfo extends FPCaller
    {
        public static const CHANGE:String = 'drawInfoChange';

        public var color:int;
        public var alpha:Number;
        public function FPGDrawInfo(color:int, alpha:Number)
        {
            this.color = color;
            this.alpha = alpha;
        }

        public function update():void
        {

        }
    }
}
