/**
 * Created by sam on 27.02.15.
 */
package ru.flashpress.geom.point
{
    import ru.flashpress.geom.core.ns.geometry2d;

    public class FPGPoint2dFactory
    {
        use namespace geometry2d;

        public static const ZERO:FPGPoint2dFix = new FPGPoint2dFix(0, 0);

        public static const AXIS_X:FPGPoint2dFix = new FPGPoint2dFix(1, 0);

        public static const AXIS_Y:FPGPoint2dFix = new FPGPoint2dFix(0, 1);

        public static const NORMAL:FPGPoint2dFix = new FPGPoint2dFix(1, 1);


        geometry2d static var _pool:Vector.<FPGPoint2d> = new Vector.<FPGPoint2d>();
        public static function create(x:Number=0, y:Number=0):FPGPoint2d
        {
            if (_pool.length) {
                var point:FPGPoint2d = _pool.shift() as FPGPoint2d;
                point.update(x, y);
                return point;
            } else {
                return new FPGPoint2d(x, y);
            }
        }
    }
}
