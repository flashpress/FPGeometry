package ru.flashpress.geom.ellipse.math
{
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.ellipse.FPGCircle2d;
	import ru.flashpress.geom.point.math.FPGPoint2dMath;

	public class FPGEllipse2dMath
	{
		use namespace geometry2d;
		
		/**
		 * Проверить пересекаются ли две окружности
		 */
		public static function cross(c1:FPGCircle2d, c2:FPGCircle2d):Boolean
		{
			var length:Number = FPGPoint2dMath.length(c1._center, c2._center);
			return length < c1._radius + c2._radius;
		}
	}
}