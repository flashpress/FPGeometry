package ru.flashpress.geom.line.math
{
	import ru.flashpress.geom.core.constants.FPGeom2dMath;
	import ru.flashpress.geom.core.ns.geomTestFunctions;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.line.FPGLine2d;
	import ru.flashpress.geom.line.constants.OrientLinePoint2d;
	import ru.flashpress.geom.point.FPGPoint2d;
	import ru.flashpress.geom.point.math.FPGPoint2dMath;
	import ru.flashpress.geom.vector.FPGVector2d;
	import ru.flashpress.geom.vector.math.FPGVector2dMath;

	/**
	 * Математические операции Линии и Точки
	 * @author Serious Sam
	 * 
	 */
	public class FPGLineToPoint2dMath
	{
		use namespace geometry2d;
		use namespace geomTestFunctions;
		//
		/**
		 * Проверить принадлежит ли точка p отрезку p1-p2
		 */
		public static function checkSegment(line:FPGLine2d, p:FPGPoint2d):Boolean
		{
			var e:Number = FPGeom2dMath.EXACTITUDE;
			if (Math.abs(line.valueFromPoint(p)) > e) return false;
			var mod:Number = line.length;
			var vec_p1:FPGVector2d = new FPGVector2d(line._p1._x-p._x, line._p1._y-p._y);
			if (vec_p1.module - mod > e) return false;
			//
			var vec_p2:FPGVector2d = new FPGVector2d(line._p2._x-p._x, line._p2._y-p._y);
			if (vec_p2.module - mod > e) return false;
			//
			return true;
		}
		
		/**
		 * Проверить принадлежит ли точка p отрезку p1-p2, при условии что точка лежит на этой линии.
		 */
		public static function checkSegmentInLine(line:FPGLine2d, p:FPGPoint2d):Boolean
		{
			var e:Number = FPGeom2dMath.EXACTITUDE;
			var vec_line:FPGVector2d = new FPGVector2d(line._p2._x-line._p1._x, line._p2._y-line._p1._y);
			var mod:Number = vec_line.module;
			var vec_p1:FPGVector2d = new FPGVector2d(line._p1._x-p._x, line._p1._y-p._y);
			if (vec_p1.module - mod > e) return false;
			//
			var vec_p2:FPGVector2d = new FPGVector2d(line._p2._x-p._x, line._p2._y-p._y);
			if (vec_p2.module - mod > e) return false;
			//
			return true;
		}
		
		
		/**
		 * Получить уравнение перпендикуляра отпущенного из точки point на прямую line.
		 */
		public static function lineHeight(point:FPGPoint2d, line:FPGLine2d):FPGLine2d
		{
			var dir:FPGVector2d = line.direction;
			var temp:Number = dir._x*point._x + dir._y*point._y;
			
			var p2:FPGPoint2d = new FPGPoint2d();
			if (dir._y != 0) {
				p2._x = point.x != 1 ? 1 : 2;
				p2._y = (-dir._x*p2._x+temp)/dir._y;
			} else {
				p2._x = point._x;
				p2._y = line._p1._y;
			}
			if (point.compare(p2)) {
				return null;
			}
			return new FPGLine2d(point.clone(), FPGPoint2dMath.crossLines(line._p1, line._p2, point, p2));
		}
		
		/**
		 * Проверить положение точки относительно линии. Метод вернет одну из констант класса OrientLinePoint2d.
		 * @return Одно из значений OrientLinePoint2d
		 * @see ru.flashpress.geom.line.constants.OrientLinePoint2d
		 */
		public static function orient(line:FPGLine2d, p:FPGPoint2d, viewTest:Boolean=false):String
		{
			if (viewTest && line._p1._x > line._p2._x) {
				line = new FPGLine2d(line._p2, line._p1);
			}
			var p1:FPGPoint2d = line._p1;
			var p2:FPGPoint2d = line._p2;
			//
			//if (p1._x == p._x && p1._y == p._y) {
			if (p1.compare(p)) {
				// точка лежит на левой вершине
				return  OrientLinePoint2d.BELONGS_LEFT;
			}
			//if (p2._x == p._x && p2._y == p._y) {
			if (p2.compare(p)) {
				// точка лежит на правой вершине
				return OrientLinePoint2d.BELONGS_RIGHT;
			}
			
			var res:Number = line.valueFromPoint(p);
			if (res != 0) {
				res = res/Math.abs(res);
			}
			switch (res) {
				case 1 :
					// точка лежит НАД линией
					return OrientLinePoint2d.ABOVE_LINE; 
				case 0 :
					if (!FPGLineToPoint2dMath.checkSegmentInLine(line, p)) {
						// точка лежит на линии (бесконечно длинной)
						return OrientLinePoint2d.INLINE;
					} else {
						// точка лежит на отрезке
						return OrientLinePoint2d.INPIECE;
					}
					break;
				case -1 :
					// точка лежит ПОД линией
					return OrientLinePoint2d.UNDER_LINE;
					break;
			}
			return null;
		}

        /**
         * Позиция точки НА(!) линии:
         * если -1, значит точка лежит слева от line.p1,
         * сли 1, значит точка лежит справа от line.p2,
         * если 0 - значит точка лежит внутри отрезка.
         * Подразумевается что точка point лежит на линии line.
         */
        public static function position(line:FPGLine2d, point:FPGPoint2d):int
        {
            var p1:FPGPoint2d = line._p1;
            var p2:FPGPoint2d = line._p2;
            var module2:Number = line._direction.module2;
            var t:Number = Math.sqrt(((point.x-p1.x)*(point.x-p1.x) + (point.y-p1.y)*(point.y-p1.y))/module2);
            if (t > 1) return 1;
            t = ((point.x-p2.x)*(point.x-p2.x) + (point.y-p2.y)*(point.y-p2.y))/module2;
            if (t > 1) return -1;
            return 0;
        }
		
		/**
		 * @private 
		 */		
		geomTestFunctions static function pointInSegments(point:FPGPoint2d, center:FPGPoint2d, points:Vector.<FPGPoint2d>):int
		{
			var checkVec:FPGVector2d = new FPGVector2d(point._x-center._x, point._y-center._y);
			//
			var vectors:Vector.<FPGVector2d> = new Vector.<FPGVector2d>();
			var vec:FPGVector2d;
			var i:uint;
			var c:uint = points.length;
			var p:FPGPoint2d;
			var firstVec:FPGVector2d;
			for (i=0; i<c; i++) {
				p = points[i];
				vec = new FPGVector2d(p._x-center._x, p._y-center._y);
				vectors.push(vec);
				if (i == 0) {
					firstVec = vec;
				}
				//
				vec = vec.clone() as FPGVector2d;
				vec.update(-vec._x, -vec._y);
				vectors.push(vec);
			}
			vectors = vectors.sort(sortVectorsByAngle);
			c = vectors.length;
			var checkAngle:Number;
			var nextVec:FPGVector2d;
			var firstIndex:uint = vectors.indexOf(firstVec);
			for (i=0; i<c; i++) {
				vec = vectors[i];
				checkAngle = FPGVector2dMath.angleTo(vec, checkVec);
				nextVec = i < c-1 ? vectors[i+1] : vectors[0];
				if (checkAngle <= FPGVector2dMath.angleTo(vec, nextVec)) {
					var res:int = i-firstIndex;
					if (res < 0) res = c+res;
					return res;
				}
			}
			return -1;
		}
		private static function sortVectorsByAngle(v1:FPGVector2d, v2:FPGVector2d):Number
		{
			if (v1.angle > v2.angle) return 1;
			if (v1.angle < v2.angle) return -1;
			return 0;
		}
	}
}