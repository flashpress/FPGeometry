package ru.flashpress.geom.ellipse.factory
{
	import ru.flashpress.geom.ellipse.FPGCircle2d;
	import ru.flashpress.geom.line.FPGLine2d;
	import ru.flashpress.geom.line.FPGLine2dFactory;
	import ru.flashpress.geom.line.math.FPGLineToLine2dMath;
	import ru.flashpress.geom.point.FPGPoint2d;
	import ru.flashpress.geom.point.math.FPGPoint2dMath;

	public class FPGCircle2dFactory
	{
		/**
		 * Получить окружность по трем точкам,
		 * если точки лежат на одной проямой, метод вернет значение null.
		 */
		public static function byPoints(p1:FPGPoint2d, p2:FPGPoint2d, p3:FPGPoint2d):FPGCircle2d
		{
			var line1:FPGLine2d = new FPGLine2d(p1, p2);
			var pc1:FPGPoint2d = line1.pointFromTime(0.5);
			var line1H:FPGLine2d = FPGLine2dFactory.incline(Math.PI/2, pc1.x, pc1.y, 1, line1);
			var line2:FPGLine2d = new FPGLine2d(p2, p3);
			var pc2:FPGPoint2d = line2.pointFromTime(0.5);
			var line2H:FPGLine2d = FPGLine2dFactory.incline(Math.PI/2, pc2.x, pc2.y, 1, line2);
			//
			var center:FPGPoint2d = FPGLineToLine2dMath.crossLine(line1H, line2H);
			if (center == null) return null;
			var radius:Number = FPGPoint2dMath.length(center, p1);
			//
			return new FPGCircle2d(center, radius);
		}
	}
}