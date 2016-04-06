package ru.flashpress.geom.point.math
{
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import ru.flashpress.geom.core.bounds.FPGBounds;
	import ru.flashpress.geom.core.constants.FPGeom2dMath;
	import ru.flashpress.geom.core.ns.geomTestFunctions;
	import ru.flashpress.geom.core.ns.geometry2d;
    import ru.flashpress.geom.line.FPGLine2d;
    import ru.flashpress.geom.line.math.FPGLineToPoint2dMath;
    import ru.flashpress.geom.point.FPGPoint2d;
	import ru.flashpress.geom.point.FPGPoint2dFactory;
	import ru.flashpress.geom.vector.FPGVector2d;

    /**
	 * Математические операции точки
	 * @author Serious Sam
	 */
	public class FPGPoint2dMath
	{
		use namespace geomTestFunctions;
		use namespace geometry2d;
		
		private static var s1:Number;
		private static var s2:Number;
		private static var s3:Number;
		
		/**
		 * Наименьший(!) угол между векторами, заданными точками p11-p12 и p21-p22.
		 * Значение этого угла задается в радианах, и
		 * не может выйти зна рамки [0..Math.PI], при любом направлении векторов.
		 * @param p11 Первая точка первой линии
		 * @param p12 Вторая точка первой линии
		 * @param p21 Первая точка второй линии
		 * @param p22 Вторая точка второй линии
		 */
		public static function angleBetweenLines(p11:FPGPoint2d, p12:FPGPoint2d,
												 p21:FPGPoint2d, p22:FPGPoint2d
												):Number
		{
			var dx:Number = p12.x-p11.x;
			var dy:Number = p12.y-p11.y;
			var a1:Number = Math.atan(dy/dx);
			//
			dx = p22.x-p21.x;
			dy = p22.y-p21.y;
			var a2:Number = Math.atan(dy/dx);
			//
			var a:Number = a1-a2;
			if (a > Math.PI/2) {
				a = a-Math.PI;
			}
			if (a < -Math.PI/2) {
				a = a+Math.PI;
			}
			//
			return a;
		}
		
		/**
		 * Угол, на котороый необходимо повернуть вектор p11-p12, так, что бы он совпал с вектором p21-p22,
		 * угол измеряется в радианах и может принимать значения [-Math.PI..Math.PI]
		 */
		public static function angleDirectionLines(p11:FPGPoint2d, p12:FPGPoint2d,
												   p21:FPGPoint2d, p22:FPGPoint2d
													):Number
		{
			var a1:Number = Math.atan2((p12._y-p11._y), (p12._x-p11._x));
			var a2:Number = Math.atan2((p22._y-p21._y), (p22._x-p21._x));
			var a:Number = a2-a1;
			if (Math.abs(a) > Math.PI) {
				a = Math.abs(a)-Math.PI*2;
			}
			return a;
		}
		
		/**
		 * Угол, на который необходимо повернуть по часовой стрелке первый вектор(p11-p12) так,
		 * что бы он совпал со вторым вектором(p21-p22), угол измеряется в радианах и
		 * может принимать значение в рамках [0..Math.PI*2].
		 */
		public static function angleToLines(p11:FPGPoint2d, p12:FPGPoint2d,
											p21:FPGPoint2d, p22:FPGPoint2d
											):Number
		{
			var dx:Number = p12.x-p11.x;
			var dy:Number = p12.y-p11.y;
			var a1:Number = Math.atan2(dy, dx);
			if (a1 < 0) a1 = Math.PI*2+a1;
			//
			dx = p22.x-p21.x;
			dy = p22.y-p21.y;
			var a2:Number = Math.atan2(dy, dx);
			if (a2 < 0) a2 = Math.PI*2+a2;
			//
			var a:Number = a2-a1;
			if (a < 0) a = Math.PI*2+a;
			//
			return a;
		}
		
		/**
		 * Метод возвращает матрицу, которая преобразует линию p11-p12 в p21-p22
		 */
		public static function mathToLines(p11:FPGPoint2d, p12:FPGPoint2d,
										   p21:FPGPoint2d, p22:FPGPoint2d):Matrix
		{
			var angleTo:Number = FPGPoint2dMath.angleDirectionLines(p21, p22, p11, p12);
			var dir1:Point = new Point(p22._x-p21._x, p22._y-p21._y);
			var dir2:Point = new Point(p12._x-p11._x, p12._y-p11._y);
			var angle2:Number = Math.atan2(dir2.y, dir2.x);
			var scale:Number = Math.sqrt((dir1.x*dir1.x + dir1.y*dir1.y)/(dir2.x*dir2.x + dir2.y*dir2.y));
			//
			var matrix:Matrix = new Matrix();
			matrix.translate(-p11.x, -p11.y);
			matrix.rotate(-angle2);
			matrix.scale(scale, 1);
			matrix.rotate(angle2+angleTo);
			matrix.translate(p21.x, p21.y);
			//
			return matrix;
		}
		
		/**
		 * Коллинеарность трех точек. `Проверяется с точностью FPGeom2dMath.EXACTITUDE.
		 * @see ru.flashpress.geom.core.constants.FPGeom2dMath#EXACTITUDE
		 */
		public static function сollinearPoints(p1:FPGPoint2d, p2:FPGPoint2d, p3:FPGPoint2d):Boolean
		{
			s1 = p1._x*(p2._y-p3._y);
			s2 = -p1._y*(p2._x-p3._x);
			s3 = (p2._x*p3._y-p2._y*p3._x);
			return (s1+s2+s3) < FPGeom2dMath.EXACTITUDE;
		}
		
		private static var dx:Number;
		private static var dy:Number;
		/**
		 * Расстояние между двумя точками. 
		 */
		public static function length(p1:FPGPoint2d, p2:FPGPoint2d):Number
		{
			dx = p1._x-p2._x;
			dy = p1._y-p2._y;
			return Math.sqrt(dx*dx  + dy*dy); 
		}
		
		private static var point1:FPGPoint2d;
		private static var point2:FPGPoint2d;
		private static var index1:uint = 1;
		private static var index2:uint;
		private static var count:uint;
		private static var error:Boolean;
		public static function removeMatches(points:Vector.<FPGPoint2d>):void
		{
			count = points.length;
			while (index1 < count) {
				point1 = points[index1];
				index2 = 0;
				error = false;
				while (index2 < index1 && !error) {
					point2 = points[index2];
					if (point1.compare(point2)) {
						points.splice(index1, 1);
						count--;
						error = true;
					}
					index2++;
				}
				if (!error) {
					index1++;
				}
			}
		}
		
		/**
		 * Точка между двумя другими, заданная по времени
		 * @param p1 Первая точка 
		 * @param p2 Вторая точка
		 * @param time Если 0 значит точка совпадает с p1, если 1 - то p2
		 */
		public static function betweenForTime(p1:FPGPoint2d, p2:FPGPoint2d, time:Number):FPGPoint2d
		{
			return new FPGPoint2d(p1._x+(p2._x-p1._x)*time, p1._y+(p2._y-p1._y)*time);
		}
		
		/**
		 * Центр системы точек
		 */
		public static function centerPoints(points:Vector.<FPGPoint2d>):FPGPoint2d
		{
			var i:uint;
			var pc:uint = points.length;
			var point:FPGPoint2d;
			var x:Number = 0;
			var y:Number = 0;
			for (i=0; i<pc; i++) {
				point = points[i];
				x += point._x;
				y += point._x;
			}
			return new FPGPoint2d(x/pc, y/pc);
		}
		
		geometry2d static function rotatePointFromLine(size:Number, p0:FPGPoint2d, p1:FPGPoint2d, p2:FPGPoint2d):FPGPoint2d
		{
			var dir:Number = Math.abs(size)/size;
			size = Math.abs(size);
			//
			var dx:Number = p2._x-p1._x;
			var dy:Number = p2._y-p1._y;
			var nx:Number = -dir*dy;
			var ny:Number = dir*dx;
			var len:Number = Math.sqrt(nx*nx + ny*ny);
			nx /= len;
			ny /= len;
			return new FPGPoint2d(p0._x + size*nx, p0._y + size*ny);
		}
		
		/**
		 * Точка пересечения линий, образованных парами точкек p11-p12 и p21-p22 
		 * @param p11 Первая точка первой линии
		 * @param p12 Вторая точка первой линии
		 * @param p21 Первая точка второй линии
		 * @param p22 Вторая точка второй линии
		 */
		public static function crossLines(	p11:FPGPoint2d, p12:FPGPoint2d,
											p21:FPGPoint2d, p22:FPGPoint2d
										  ):FPGPoint2d
		{
			var check_d:Number = (p22._y-p21._y)*(p12._x-p11._x) - (p22._x-p21._x)*(p12._y-p11._y);
			if (check_d == 0) {
				return null;
			}
			var check_a:Number = (p22._x-p21._x)*(p11._y-p21._y) - (p22._y-p21._y)*(p11._x-p21._x);
			var x0:Number = p11._x+check_a*(p12._x-p11._x)/check_d;
			var y0:Number = p11._y+check_a*(p12._y-p11._y)/check_d;
			return new FPGPoint2d(x0, y0);
		}


        /**
         * Пересекаются ли отрезки
         */
		public static function isCrossPiece(p11:FPGPoint2d, p12:FPGPoint2d,
											p21:FPGPoint2d, p22:FPGPoint2d
											):Boolean
		{
            trace('isCrossPiece', p11,  p12, p21, p22);
			var a:Number = p12._y-p11._y;
			var b:Number = -(p12._x-p11._x);
			var c:Number = -p11._x*a-p11.y*b;
			//
			var v1:Number = a*p21._x + b*p21._y + c;
			var v2:Number = a*p22._x + b*p22._y + c;
            trace('v1*v2:1:', v1*v2);
			if (v1*v2 > 0) return false;
			//
			a = p22._y-p21._y;
			b = -(p22._x-p21._x);
			c = -p21._x*a-p21.y*b;
			v1 = a*p11._x + b*p11._y + c;
			v2 = a*p12._x + b*p12._y + c;
            trace('v1*v2:2:', v1*v2);
			if (v1*v2 > 0) return false;
			//
			return true;
		}
		
		/**
		 * Ограничивающий прямоугольник массива точек
		 */
		public static function boundsByPoints(points:Vector.<FPGPoint2d>):FPGBounds
		{
			if (!points || points.length == 0) return null;
			var point:FPGPoint2d = points[0];
			var xmin:Number = point._x;
			var ymin:Number = point._y;
			var xmax:Number = point._x;
			var ymax:Number = point._y;
			var i:int;
			var len:int = points.length;
			for (i=1; i<len; i++) {
				point = points[i];
				xmin = Math.min(xmin, point._x);
				ymin = Math.min(ymin, point._y);
				xmax = Math.max(xmax, point._x);
				ymax = Math.max(ymax, point._y);
			}
			return new FPGBounds(xmin, ymin, xmax-xmin, ymax-ymin);
		}

        /**
         * Проекция точки на прямую
         */
        public static function projectionToLine(point:FPGPoint2d, line:FPGLine2d):FPGPoint2d
        {
            var dir:FPGVector2d = line.direction;
            var temp:Number = dir._x*point._x + dir._y*point._y;

            var p2:FPGPoint2d = FPGPoint2dFactory.create();
            if (dir._y != 0) {
                p2._x = point.x != 1 ? 1 : 2;
                p2._y = (-dir._x*p2._x+temp)/dir._y;
            } else {
                p2._x = point._x;
                p2._y = line._p1._y;
            }
            if (point.compare(p2)) {
				p2.release();
                return null;
            }
            return FPGPoint2dMath.crossLines(line._p1, line._p2, point, p2);
        }

        /**
         * Проекция точки на отрезок
         */
        public static function projectionToPice(point:FPGPoint2d, line:FPGLine2d):FPGPoint2d
        {
            var temp:FPGPoint2d = projectionToLine(point, line);
            if (FPGLineToPoint2dMath.checkSegmentInLine(line, temp)) {
                return temp;
            } else {
                return null;
            }
        }

        /**
         * Получить центра масс по углам лучей выпущенных оз модной точки
         */
        public static function medianRay(point0:FPGPoint2d, rayPoints:Vector.<FPGPoint2d>):Number
        {
            var point1:FPGPoint2d = rayPoints[0];
            var aBegin:Number = Math.atan2(point1._y-point0._y, point1._x-point0._x);
            if (aBegin < 0) aBegin = Math.PI*2+aBegin;
            var i:int;
            var aCurret:Number;
            var sum:Number = 0;
            var point:FPGPoint2d;
            for (i=1; i<rayPoints.length; i++) {
                point = rayPoints[i];
                aCurret = angleDirectionLines(point0, point, point0, point1);
                sum += -aCurret;
            }
            var res:Number = aBegin+sum/(rayPoints.length);
            return res;
        }

        /**
         * Повернуть вектор на заданный угол
         * @param p0 Начальная точка ветокра
         * @param p1 Конечная точка ветокра
         * @param angle Угол поворота
         * @param length Расстояние между точкой p0 и искомой, если передать значение 0,
         * тогда будет использовано расстояние между p0 и p1.
         * Если необходимо найти только направление, тогда испольтзуйте значение 1,
         * это избавит от излишних расчетов и увеличит производительность.
         * @return Точка, которая вместе с точкой p0 образует вектор,
         * полученный из вектора p0p1 путем поворота на угол angle
         */
        public static function rotateLine(p0:FPGPoint2d, p1:FPGPoint2d, angle:Number, length:Number=0):FPGPoint2d
        {
            var dx:Number = p1._x-p0._x;
            var dy:Number = p1._y-p0._y;
            //
            var a:Number = Math.atan2(dy, dx);
            a += angle;
            if (length == 0) length = Math.sqrt(dx*dx+dy*dy);
            //
            return FPGPoint2dFactory.create(p0._x + length*Math.cos(a), p0._y + length*Math.sin(a));
        }


		
		/**
		 * Инвертировать массив точек
		 * @private
		 */
		geomTestFunctions static function inversePoints(points:Vector.<FPGPoint2d>):Vector.<FPGPoint2d>
		{
			var inverse:Vector.<FPGPoint2d> = new Vector.<FPGPoint2d>();
			if (points.length == 0) return inverse;
			var i:uint = points.length;
			while (i) {
				inverse.push(points[i-1]);
				i--;
			}
			return inverse;
		}
		
		
		
		private static var x1:Number;
		private static var y1:Number;
		private static var x2:Number;
		private static var y2:Number;
		/**
		 * @private
		 */
		geomTestFunctions static function _testNf2(p:FPGPoint2d, a:FPGPoint2d, b:FPGPoint2d):Number
		{
			x1 = p._x-a._x;
			y1 = p._y-a._y;
			x2 = b._x-a._x;
			y2 = b._y-a._y;
			return x1*y2 - y1*x2;
		}
	}
}