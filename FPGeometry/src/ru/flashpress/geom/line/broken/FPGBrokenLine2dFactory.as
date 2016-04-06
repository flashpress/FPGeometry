package ru.flashpress.geom.line.broken
{
	import ru.flashpress.geom.core.ns.geomTestFunctions;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;
	import ru.flashpress.geom.point.math.FPGPoint2dMath;

	/**
	 * @private
	 */
	public class FPGBrokenLine2dFactory
	{
		use namespace geometry2d;
		use namespace geomTestFunctions;
		//
		/**
		 * Получить линии, проходящую параллельно с заданной на указанном расстоянии
		 * @param line Исходна ломанная линии
		 * @param length Расстояние до новой линии, значение может быть отрицательным
		 */
		public static function generateBorder(line:FPGBrokenLine2d, length:Number):FPGBrokenLine2d
		{
			return new FPGBrokenLine2d(generateBorderPoints(line, length));
		}
		/**
		 * Получить массив точек, которые составляют рамку к заданной ломанной лнии
		 */
		private static function generateBorderPoints(line:FPGBrokenLine2d, length:Number):Vector.<FPGPoint2d>
		{
			var temp:Vector.<FPGPoint2d> = new Vector.<FPGPoint2d>();
			var generate:Vector.<FPGPoint2d> = new Vector.<FPGPoint2d>();
			var i:uint;
			var points:Vector.<FPGLineVertex2d> = line.points;
			var pc:uint = points.length-1;
			var p1:FPGPoint2d;
			var p2:FPGPoint2d;
			var p1h:FPGPoint2d;
			var p2h:FPGPoint2d;
			var p1prev:FPGPoint2d;
			var p2prev:FPGPoint2d;
			var cross:FPGPoint2d;
			for (i=0; i<pc; i++) {
				p1 = points[i];
				p2 = points[i+1];
				p1h = FPGPoint2dMath.rotatePointFromLine(length, p1, p1, p2);
				p2h = FPGPoint2dMath.rotatePointFromLine(length, p2, p1, p2);
				//
				if (i == 0) {
					generate.push(p1h);
				}
				if (i != 0) {
					cross = FPGPoint2dMath.crossLines(p1h, p2h, p1prev, p2prev);
					if (cross) {
						generate.push(cross);
					}
				}
				if (i == pc-1) {
					generate.push(p2h);
				}
				//
				p1prev = p1h;
				p2prev = p2h;
			}
			return generate;
		}
		
		/**
		 * Получить две линии, проходящие паралельна с двух сторой от заданной
		 */
		public static function generateStroke(line:FPGBrokenLine2d, length:Number):FPGBrokenLine2d
		{
			var points1:Vector.<FPGPoint2d> = generateBorderPoints(line, length);
			var points2:Vector.<FPGPoint2d> = generateBorderPoints(line, -length);
			points2 = FPGPoint2dMath.inversePoints(points2);
			var resList:Vector.<FPGPoint2d> = points1.concat(points2);
			resList.push(points1[0]);
			return new FPGBrokenLine2d(resList);
		}
	}
}