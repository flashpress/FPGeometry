package ru.flashpress.geom.core.bounds
{
	import ru.flashpress.geom.core.constants.FPGeom2dMath;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;

	/**
	 * Математические операции с ограничивающим прямоугольником FPGBounds
	 * @author Serious Sam
	 */
	public class FPGBoundsMath
	{
		use namespace geometry2d;
		//
		/**
		 * Проверить, принадлежит ли точка прямоугольнику. Проверяется с точностью FPGeom2dMath.EXACTITUDE.
		 * @see ru.flashpress.geom.core.constants.FPGeom2dMath#EXACTITUDE
		 */
		public static function pointContains(point:FPGPoint2d, bounds:FPGBounds):Boolean
		{
			var dx:Number = point._x-bounds._x;
			if (dx < -FPGeom2dMath.EXACTITUDE) return false;
			var dy:Number = point._y-bounds._y;
			if (dy < -FPGeom2dMath.EXACTITUDE) return false;
			//
			var dw:Number = point._x-(bounds._x+bounds._width);
			if (dw > FPGeom2dMath.EXACTITUDE) return false;
			var dh:Number = point._y-(bounds._y+bounds._height);
			if (dh > FPGeom2dMath.EXACTITUDE) return false;
			return true;
		}
		
		private static var sx1:Boolean;
		private static var sy1:Boolean;
		private static var sx2:Boolean;
		private static var sy2:Boolean;
		/**
		 * Пересекаются ли прямоугольники. Проверяется с точностью FPGeom2dMath.EXACTITUDE.
		 * @see ru.flashpress.geom.core.constants.FPGeom2dMath#EXACTITUDE
		 */
		public static function isCross(b1:FPGBounds, b2:FPGBounds):Boolean
		{
			var e:Number = FPGeom2dMath.EXACTITUDE;
			//
			sx1 = b1._x-b2._x>e && b1._x-(b2._x+b2._width)<e;
			sx2 = b2._x-b1._x>e && b2._x-(b1._x+b1._width)<e;
			if (!sx1 && !sx2) return false;
			//
			sy1 = b1._y-b2._y>e && b1._y-(b2._y+b2._height)<e;
			sy2 = b2._y-b1._y>e && b2._y-(b1._y+b1._height)<e;
			if (!sy1 && !sy2) return false;
			return true;
		}
	}
}