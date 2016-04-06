package ru.flashpress.geom.line.math
{
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.line.FPGLine2d;
    import ru.flashpress.geom.point.FPGPoint2d;
    import ru.flashpress.geom.point.FPGPoint2d;
    import ru.flashpress.geom.point.math.FPGPoint2dMath;
    import ru.flashpress.geom.vector.FPGVector2d;
	import ru.flashpress.geom.vector.math.FPGVector2dMath;

	/**
	 * Математические операции двух линии
	 * @author Serious Sam
	 * http://flashpress.ru
	 */
	public class FPGLineToLine2dMath
	{
		use namespace geometry2d;
		//

        /**
         * Наименьший(!) угол между векторами, заданными точками p11-p12 и p21-p22.
         * Значение этого угла задается в радианах, и
         * не может выйти зна рамки [0..Math.PI], при любом направлении векторов.
         */
        public static function angleBetweenLines(l1:FPGLine2d, l2:FPGLine2d):Number
        {
            return FPGPoint2dMath.angleBetweenLines(l1._p1, l1._p2, l2._p1, l2._p2);
        }

        /**
         * Угол, на котороый необходимо повернуть вектор p11-p12, так, что бы он совпал с вектором p21-p22,
         * угол измеряется в радианах и может принимать значения [-Math.PI..Math.PI]
         */
        public static function angleDirectionLines(l1:FPGLine2d, l2:FPGLine2d):Number
        {
            return FPGPoint2dMath.angleDirectionLines(l1._p1, l1._p2, l2._p1, l2._p2);
        }

        /**
         * Угол, на который необходимо повернуть по часовой стрелке первый вектор(p11-p12) так,
         * что бы он совпал со вторым вектором(p21-p22), угол измеряется в радианах и
         * может принимать значение в рамках [0..Math.PI*2].
         */
        public static function angleToLines(l1:FPGLine2d, l2:FPGLine2d):Number
        {
            return FPGPoint2dMath.angleToLines(l1._p1, l1._p2, l2._p1, l2._p2);
        }
		
		/**
		 * Проверка на ортогональность двух линий
		 */
		public static function isOrthogonal(l1:FPGLine2d, l2:FPGLine2d):Boolean
		{
			return FPGVector2dMath.isOrthogonal(l1.normale, l2.normale);
		}
		
		/**
		 * Проверка на параллельность двух линий
		 */
		public static function isParallel(l1:FPGLine2d, l2:FPGLine2d):Boolean
		{
			return FPGVector2dMath.isParallel(l1.normale, l2.normale);
		}


		
		/**
		 * Получить расстояние между параллельными прямыми
		 */
		public static function length(l1:FPGLine2d, l2:FPGLine2d):Number
		{
			if (FPGLineToLine2dMath.isParallel(l1, l2)) {
				var vec:FPGVector2d = new FPGVector2d(l2._p1._x-l1._p1._x, l2._p1._y-l1._p1._y);
				var proj:FPGVector2d = FPGVector2dMath.projection(vec, l2.normale);
				return proj.module;
			} else {
				return -1;
			}
		}
		
		/**
		 * Проекция линии l1 на l2, если линии перпендикулярны, то метод вернет null.
		 */
		public static function projection(l1:FPGLine2d, l2:FPGLine2d):FPGLine2d
		{
			var lineHeight:FPGLine2d = FPGLineToPoint2dMath.lineHeight(l1._p1, l2);
			if (lineHeight == null) {
				return null;
			}
			var projection:FPGVector2d = FPGVector2dMath.projection(l1.direction, l2.direction);
			//
			var p1:FPGPoint2d = l1._p1.clone();
			//p1.addPoint(lineHeight.direction);
			p1.update(p1._x+lineHeight.direction._x, p1._y+lineHeight.direction._y);
			//
			var p2:FPGPoint2d = p1.clone();
			//p2.addPoint(projection);
			p2.update(p2._x+projection._x, p2._y+projection._y);
			return new FPGLine2d(p1, p2);
		}

        /**
         * Проекция отрезка(!) l1 на l2, если отрезки перпендикулярны, то метод вернет null.
         */
        public static function projectionPiece(l1:FPGLine2d, l2:FPGLine2d):FPGLine2d
        {
            var pos:int;
            var p1:FPGPoint2d = FPGPoint2dMath.projectionToLine(l1._p1, l2);
            pos = FPGLineToPoint2dMath.position(l2, p1);
            switch (pos) {
                case -1:
                        p1 = l2._p1;
                    break;
                case 1:
                    p1 = l2._p2;
                    break;
            }
            //
            var p2:FPGPoint2d = FPGPoint2dMath.projectionToLine(l1._p2, l2);
            pos = FPGLineToPoint2dMath.position(l2, p2);
            switch (pos) {
                case -1:
                    p2 = l2._p1;
                    break;
                case 1:
                    p2 = l2._p2;
                    break;
            }
            //
            if (p1.compare(p2)) return null;
            return new FPGLine2d(p1, p2);
        }
		
		/**
		 * Получить точку пересечения прямых.
		 * ВНИМАНИЕ! Здесь проверяется точка пересечения бесконечно длинных прямых.
		 */
		public static function crossLine(l1:FPGLine2d, l2:FPGLine2d):FPGPoint2d
		{
			var check_d:Number = (l2._p2._y-l2._p1._y)*(l1._p2._x-l1._p1._x) - (l2._p2._x-l2._p1._x)*(l1._p2._y-l1._p1._y);
			if (check_d == 0) {
				return null;
			}
			var check_a:Number = (l2._p2._x-l2._p1._x)*(l1._p1._y-l2._p1._y) - (l2._p2._y-l2._p1._y)*(l1._p1._x-l2._p1._x);
			var x0:Number = l1._p1._x+check_a*(l1._p2._x-l1._p1._x)/check_d;
			var y0:Number = l1._p1._y+check_a*(l1._p2._y-l1._p1._y)/check_d;
			return new FPGPoint2d(x0, y0);
		}
		
		/**
		 * Получить точку пересечения бесконечно длинной
		 * прямой и конечного отрезка
		 */
		public static function crossLineAndPiece(line:FPGLine2d, piece:FPGLine2d):FPGPoint2d
		{
			var point:FPGPoint2d = crossLine(line, piece);
			if (!point) return null;
			if (!FPGLineToPoint2dMath.checkSegment(piece, point)) return null;
			//
			return point;
		}
		
		
		private static var v1:Number;
		private static var v2:Number;
		/**
		 * Проверить пересекаются ли отрезки(!). 
		 * Отрезки считаются пересекающимися если обе точки одного отрезка лежат по разные стороны второго отрезка и наоборот.
		 * Касание считается пересечением(!).
		 */
		public static function isCrossPiece(l1:FPGLine2d, l2:FPGLine2d):Boolean
		{
			v1 = l1.valueFromPoint(l2._p1);
			v2 = l1.valueFromPoint(l2._p2);
			if (v1*v2 > 0) return false;
			v1 = l2.valueFromPoint(l1._p1);
			v2 = l2.valueFromPoint(l1._p2);
			if (v1*v2 > 0) return false;
			return true;
		}
		
		/**
		 * Найти точку пересечения отрезков(!). 
		 */
		public static function crossPiece(l1:FPGLine2d, l2:FPGLine2d):FPGPoint2d
		{
			if (isCrossPiece(l1, l2)) {
				return crossLine(l1, l2);
			} else {
				return null;
			}
		}
	}
}