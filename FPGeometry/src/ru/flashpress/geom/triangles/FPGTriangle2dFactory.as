package ru.flashpress.geom.triangles
{
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;

	public class FPGTriangle2dFactory
	{
		use namespace geometry2d;
		//
		/**
		 * Правельный(равносторонний) треугольник
		 * @param center Центр
		 * @param side Длина стороны
		 * @param rotate Угол поворота
		 * @param rPoint Точка, относительно которой необходимо повернуть треугольник,
		 * если параметр не задан - используется точка center
		 */
		public static function equilateral(center:FPGPoint2d, side:Number, rotate:Number=0, rPoint:FPGPoint2d=null):FPGTriangle2d
		{
			var s2:Number = side*side;
			var h:Number = Math.sqrt(3)*side/2;
			var p1:FPGPoint2d = new FPGPoint2d(center._x, center._y-h*2/3);
			var p2:FPGPoint2d = new FPGPoint2d(center._x+side/2, center._y+h/3);
			var p3:FPGPoint2d = new FPGPoint2d(center._x-side/2, center._y+h/3);
			if (rotate != 0) {
				if (!rPoint) rPoint = center;
				p1.rotation(rotate, rPoint);
				p2.rotation(rotate, rPoint);
				p3.rotation(rotate, rPoint);
			}
			return new FPGTriangle2d(p1, p2, p3);
		}
		
		
		/**
		 * Прямоугольный треугольник, точка с прямым углом которого совпадает с началом координат,
		 * а катеты совпадают с осями абцисс и ординат и равны 1.
		 */
		public static function get origin():FPGTriangle2d
		{
			return new FPGTriangle2d(new FPGPoint2d(0, 0), new FPGPoint2d(1, 0), new FPGPoint2d(0, 1));
		}
	}
}