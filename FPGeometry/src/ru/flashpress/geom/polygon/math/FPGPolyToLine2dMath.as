package ru.flashpress.geom.polygon.math
{
	import ru.flashpress.geom.core.constants.FPGeom2dMath;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.line.FPGLine2d;
	import ru.flashpress.geom.line.math.FPGLineToLine2dMath;
	import ru.flashpress.geom.point.FPGPoint2d;
	import ru.flashpress.geom.point.math.FPGPoint2dMath;
	import ru.flashpress.geom.polygon.FPGEdge2d;
	import ru.flashpress.geom.polygon.FPGPolygon2d;
	import ru.flashpress.geom.polygon.constants.CrossPolyLineStates;

	/**
	 * Математические операции Полигона и Линии
	 * @author Serious Sam
	 */
	public class FPGPolyToLine2dMath
	{
		use namespace geometry2d;
		//
		/**
		 * Положение бесконечной прямой относительно полигона
		 * Метод вернет одну из констант класса CrossPolyLineStates
		 * @return Метод вернёт одну из констант класса CrossPolyLineStates
		 * @see ru.flashpress.geom.polygon.constants.CrossPolyLineStates
		 */
		public static function state(poly:FPGPolygon2d, line:FPGLine2d):int
		{
			var point:FPGPoint2d;
			var value:Number;
			var n:int = poly._vertexes.length;
			var i:int;
			var r:Number = 0;
			var l:Number = 0;
			var e:Number = 0;
			for (i=0; i<n; i++) {
				point = poly._vertexes[i];
				value = line.valueFromPoint(point);
				if (value < -FPGeom2dMath.EXACTITUDE) {
					l = 1;
				} else if (value > FPGeom2dMath.EXACTITUDE) {
					r = 1;
				} else {
					e = 1;
				}
				if (Math.abs(l*r) > FPGeom2dMath.EXACTITUDE) {
					return 1;
				}
			}
			return e-1;
		}
		
		/**
		 * Точки пересечения бесконечной линии и полигона
		 */
		public static function crossPoints(poly:FPGPolygon2d, line:FPGLine2d):Vector.<FPGPoint2d>
		{
			var points:Vector.<FPGPoint2d> = new Vector.<FPGPoint2d>();
			var index:int = 0;
			var edges:Vector.<FPGEdge2d> = poly._edges;
			var count:int = edges.length;
			var edge:FPGEdge2d;
			var point:FPGPoint2d;
			while (index < count) {
				edge = edges[index];
				point = FPGLineToLine2dMath.crossLineAndPiece(line, edge);
				if (point) {
					points.push(point);
				}
				index++;
			}
			return points;
		}
		
		/**
		 * Пересечение полигона и отрезка(!). Результатом будет та часть исходного отрезка(!), которая лежит внутри полигона.
		 * Не путайте пересечение бесконечной прямой и конечного отрезака, в данном случае проверяется пересечение отрезка определенной длины.
		 * Если вы хотите определить перемечение полигона и бесконечной прямой, воспользуйтесь методом FPGPolyToLine2dMath.state(...)
		 */
		public static function crossPiece(poly:FPGPolygon2d, line:FPGLine2d):FPGLine2d
		{
			var _state:int = state(poly, line);
			if (_state == CrossPolyLineStates.NOCROSS) {
				return null;
			}
			var p1:FPGPoint2d = line._p1;
			var p1In:Boolean = FPGPolyToPoint2dMath.gabariteAccess(p1, poly) && FPGPolyToPoint2dMath.state(p1, poly) >= 0;
			//
			var p2:FPGPoint2d = line._p2;
			var p2In:Boolean = FPGPolyToPoint2dMath.gabariteAccess(p2, poly) && FPGPolyToPoint2dMath.state(p2, poly) >= 0;
			//
			var points:Vector.<FPGPoint2d> = new Vector.<FPGPoint2d>();
			if (p1In) points.push(p1.clone());
			if (!p1In || !p2In) {
				var i:int;
				var j:int;
				var edges:Vector.<FPGEdge2d> = poly._edges;
				var edge:FPGEdge2d;
				var ec:int = edges.length;
				var cross:FPGPoint2d;
				var add:Boolean;
				for (i=0; i<ec; i++) {
					edge = edges[i];
					cross = FPGLineToLine2dMath.crossPiece(edge, line);
					if (cross != null) {
						add = true;
						j = 0;
						while (add && j < points.length) {
							if (cross.compare(points[j])) {
								add = false;
							}
							j++;
						}
						if (add) {
							points.push(cross);
						}
					}
				}
			}
			if (p2In) {
				var addP2:Boolean = true;
				var n:int = points.length;
				for (i=0; i<n; i++) {
					if (points[i].compare(p2)) {
						addP2 = false;
						break;
					}
				}
				if (addP2) {
					points.push(p2.clone());
				}
			}
			//
			if (points.length < 2) return null;
			//
			return new FPGLine2d(points[0], points[1]);
		}
		
		/**
		 * Вычесть полигон из отрезка. Результатом будет массив отрезков которые лежат вне полигона.
		 * @return Массив отрезков FPGLine2d
		 */
		public static function subPiece(poly:FPGPolygon2d, line:FPGLine2d):Vector.<FPGLine2d>
		{
			var subLines:Vector.<FPGLine2d> = new Vector.<FPGLine2d>();
			if (state(poly, line) == CrossPolyLineStates.NOCROSS) {
				subLines.push(line.clone());
				return subLines;
			}
			var p1:FPGPoint2d = line._p1;
			var p1Out:Boolean = !FPGPolyToPoint2dMath.gabariteAccess(p1, poly) || FPGPolyToPoint2dMath.state(p1, poly) <= 0;
			//
			var p2:FPGPoint2d = line._p2;
			var p2Out:Boolean = !FPGPolyToPoint2dMath.gabariteAccess(p2, poly) || FPGPolyToPoint2dMath.state(p2, poly) <= 0;
			//
			var points:Vector.<FPGPoint2d> = new Vector.<FPGPoint2d>();
			if (p1Out || p2Out) {
				var edges:Vector.<FPGEdge2d> = poly._edges;
				var edge:FPGEdge2d;
				var ec:int = edges.length;
				var cross:FPGPoint2d;
				var add:Boolean;
				var i:int = 0;
				var j:int;
				while (i<ec && points.length < 2) {
					edge = edges[i];
					cross = FPGLineToLine2dMath.crossPiece(edge, line);
					if (cross != null) {
						add = true;
						j = 0;
						while (add && j < points.length) {
							if (cross.compare(points[j])) {
								add = false;
							}
							j++;
						}
						if (add) {
							points.push(cross);
						}
					}
					i++;
				}
			} else {
				return subLines;
			}
			if (p1Out && p2Out && points.length == 0) {
				subLines.push(line.clone());
				return subLines;
			}
			//
			if (!p1Out) {
				subLines.push(new FPGLine2d(points[0], p2.clone()));
			} else if (!p2Out) {
				subLines.push(new FPGLine2d(p1.clone(), points[0]));
			} else {
				if (points.length == 1) {
					points.push(points[0].clone());
				}
				var l1:Number = FPGPoint2dMath.length(p1.clone(), points[0]);
				var l2:Number = FPGPoint2dMath.length(p1.clone(), points[1]);
				if (l1 < l2) {
					if (l1 != 0) {
						subLines.push(new FPGLine2d(p1.clone(), points[0]));
					}
					if (FPGPoint2dMath.length(points[1], p2) != 0) {
						subLines.push(new FPGLine2d(points[1], p2.clone()));
					}
				} else {
					if (l2 != 0) {
						subLines.push(new FPGLine2d(p1.clone(), points[1]));
					}
					if (FPGPoint2dMath.length(points[0], p2) != 0) {
						subLines.push(new FPGLine2d(points[0], p2.clone()));
					}
				}
			}
			//
			return subLines;
		}
	}
}