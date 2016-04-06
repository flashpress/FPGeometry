package ru.flashpress.geom.polygon.math
{
	import ru.flashpress.geom.core.bounds.FPGBoundsMath;
	import ru.flashpress.geom.core.constants.FPGeom2dMath;
	import ru.flashpress.geom.core.ns.geomTestFunctions;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;
	import ru.flashpress.geom.point.math.FPGPoint2dMath;
	import ru.flashpress.geom.polygon.FPGEdge2d;
	import ru.flashpress.geom.polygon.FPGPolygon2d;
	import ru.flashpress.geom.polygon.constants.PointInPolyStates;

	/**
	 * Математические операции Полигона и Точки
	 * @author Serious Sam
	 */
	public class FPGPolyToPoint2dMath
	{
		use namespace geometry2d;
		
		/**
		 * Положение точки относительно полигона. Метод вернет одну из констант класса PointInPolyState.
		 * @return Одна из констант класса PointInPolyStates
		 * @see ru.flashpress.geom.polygon.constants.PointInPolyStates
		 */
		public static function state(point:FPGPoint2d, poly:FPGPolygon2d):int
		{
			PointInPolyStates;
			use namespace geomTestFunctions;
			//
			var value:Number;
			var n:int = poly._vertexes.length;
			var i:int;
			var r:Number = 0;
			var l:Number = 0;
			var e:Number = 0;
			var end:int;
			for (i=0; i<n; i++) {
				end = i<n-1?i+1:0;
				value = FPGPoint2dMath._testNf2(poly._vertexes[i], poly._vertexes[end], point);
				if (value < -FPGeom2dMath.EXACTITUDE) {
					l = 1;
				} else if (value > FPGeom2dMath.EXACTITUDE) {
					r = 1;
				} else {
					e = 1;
				}
				if (Math.abs(l*r) > FPGeom2dMath.EXACTITUDE) {
					return -1;
				}
			}
			return 1-e;
		}
		
		private static var value:Number;
		private static var i:int;
		private static var edge:FPGEdge2d;
		private static var edges:Vector.<FPGEdge2d>;
		private static var r:Number = 0;
		private static var l:Number = 0;
		private static var e:Number = 0;
		private static var end:int;
		/**
		 * Проверить лежит ли точка внутри или на ребре выпуклого полигона. Метод корректно отработает только в случае, если полигон является выпуклым.
		 * Для определения выпуклости полигона, используйте метод FPGPolygon2d.isConvex();
		 */
		public static function contains(point:FPGPoint2d, poly:FPGPolygon2d):Boolean
		{
			edges = poly._edges;
			i = edges.length;
			while (i--) {
				edge = edges[i];
				value = edge.valueFromPoint(point);
				if (value > 0) return false;
			}
			return true;
		}
		
		/**
		 * Принадлежит ли точка габаритному прямоугольнику полигона. Габаритный прямоугольник полигона определяет свойство bounds:FPGBounds класса FPGPolygon2d
		 * @see ru.flashpress.geom.core.bounds.FPGBounds
		 */
		public static function gabariteAccess(point:FPGPoint2d, poly:FPGPolygon2d):Boolean
		{
			return FPGBoundsMath.pointContains(point, poly.bounds);
		}
	}
}