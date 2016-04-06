/**
 * Created by sam on 02.03.15.
 */
package ru.flashpress.geom.point
{
    import flash.geom.Matrix;

    import ru.flashpress.geom.core.errors.FPGError;

    import ru.flashpress.geom.point.FPGPoint2d;

    public class FPGPoint2dFix extends FPGPoint2d
    {
        public function FPGPoint2dFix(x:Number=0, y:Number=0)
        {
            super(x, y);
        }

        public override function set x(value:Number):void
        {
            throw new FPGError(FPGError.FIXED);
        }
        public override function set y(value:Number):void
        {
            throw new FPGError(FPGError.FIXED);
        }

        public override function update(_x:Number, _y:Number):void
        {
            throw new FPGError(FPGError.FIXED);
        }

        public override function set matrix(value:Matrix):void
        {
            throw new FPGError(FPGError.FIXED);
        }

        public override function removeTransform():void
        {
            throw new FPGError(FPGError.FIXED);
        }

        public override function transform(matrix:Matrix):void
        {
            throw new FPGError(FPGError.FIXED);
        }

        public override function translate(tx:Number, ty:Number):void
        {
            throw new FPGError(FPGError.FIXED);
        }

        public override function scale(sx:Number, sy:Number, point:FPGPoint2d=null):void
        {
            throw new FPGError(FPGError.FIXED);
        }

        public override function rotation(angle:Number, point:FPGPoint2d=null):void
        {
            throw new FPGError(FPGError.FIXED);
        }

        public override function skew(sx:Number, sy:Number, point:FPGPoint2d=null):void
        {
            throw new FPGError(FPGError.FIXED);
        }

    }
}
