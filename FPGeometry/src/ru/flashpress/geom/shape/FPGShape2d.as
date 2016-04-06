/**
 * Created by sam on 28.12.15.
 */
package ru.flashpress.geom.shape {
    import ru.flashpress.geom.FPGElement2d;
    import ru.flashpress.geom.core.ns.geometry2d;
    import ru.flashpress.geom.polygon.FPGPolygon2d;

    public class FPGShape2d extends FPGElement2d
    {
        use namespace geometry2d;

        geometry2d var _polygons:Vector.<FPGPolygon2d>;
        public function FPGShape2d()
        {
            super();
        }
    }
}
