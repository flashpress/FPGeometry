/**
 * Created by sam on 25.12.15.
 */
package ru.flashpress.geom.view.point {
    import ru.flashpress.geom.view.core.FPGDrawInfo;

    public class FPGDrawPoint extends FPGDrawInfo
    {
        public var size:int=10;
        public var type:int=1;
        public function FPGDrawPoint(color:int, alpha:Number, radius:int=10, type:int=1)
        {
            super(color, alpha);
            //
            this.size = radius;
            this.type = type;
        }
    }
}
