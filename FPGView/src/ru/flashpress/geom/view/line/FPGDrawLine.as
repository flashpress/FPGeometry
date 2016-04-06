/**
 * Created by sam on 25.12.15.
 */
package ru.flashpress.geom.view.line {
    import ru.flashpress.geom.view.core.FPGDrawInfo;
    import ru.flashpress.geom.view.point.FPGDrawPoint;

    public class FPGDrawLine extends FPGDrawInfo
    {
        public var thikness:int;
        public var dotline:Boolean;
        public var p1:FPGDrawPoint;
        public var p2:FPGDrawPoint;
        public function FPGDrawLine(color:int, alpha:Number, thikness:int=1, dotline:Boolean=false, p1:FPGDrawPoint=null, p2:FPGDrawPoint=null)
        {
            super(color, alpha);
            this.thikness = thikness;
            this.dotline = dotline;
            this.p1 = p1;
            this.p2 = p2;
        }
    }
}
