/**
 * Created by sam on 02.03.15.
 */
package ru.flashpress.geom.view.core
{
    import flash.display.Graphics;

    import ru.flashpress.geom.point.FPGPoint2d;
    import ru.flashpress.geom.point.math.FPGPoint2dMath;

    public function drawDotline(target:Graphics, p1:FPGPoint2d, p2:FPGPoint2d):void
    {
        var len:Number = FPGPoint2dMath.length(p1, p2);
        var delta:Number = 3;
        var count:int = len/delta;
        var i:int;
        var draw:Boolean = true;
        var dx:Number;
        var dy:Number;
        for (i=0; i<count; i++) {
            dx = p1.x + (p2.x-p1.x)*i/count;
            dy = p1.y + (p2.y-p1.y)*i/count;
            if (draw) {
                target.lineTo(dx, dy);
            } else {
                target.moveTo(dx, dy);
            }
            draw = !draw;
        }
    }
}
