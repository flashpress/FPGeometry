/**
 * Created by sam on 25.12.15.
 */
package ru.flashpress.geom.view.polygon {
    import ru.flashpress.geom.view.core.FPGDrawInfo;
    import ru.flashpress.geom.view.line.FPGDrawLine;
    import ru.flashpress.geom.view.point.FPGDrawPoint;

    public class FPGDrawPoly extends FPGDrawInfo
    {
        public var line:FPGDrawLine;
        public var points:FPGDrawPoint;
        public function FPGDrawPoly(color:int, alpha:Number, line:FPGDrawLine=null, points:FPGDrawPoint=null)
        {
            super(color, alpha);
            this.line = line;
            this.points = points;
        }
    }
}
