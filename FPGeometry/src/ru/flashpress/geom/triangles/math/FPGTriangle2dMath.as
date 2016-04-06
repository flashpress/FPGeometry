package ru.flashpress.geom.triangles.math
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.ellipse.FPGCircle2d;
	import ru.flashpress.geom.line.math.FPGLineToLine2dMath;
	import ru.flashpress.geom.point.FPGPoint2d;
	import ru.flashpress.geom.triangles.FPGTriangle2d;

	/**
	 * @private
	 */
	public class FPGTriangle2dMath
	{
		use namespace geometry2d;
		
		/**
		 * Радиус описанной окружности
		 */
		public static function describedRadius(triangle:FPGTriangle2d):Number
		{
			var radius:Number;
			if (triangle._square != -1) {
				radius = triangle.sideAB*triangle.sideBC*triangle.sideCA/(4*triangle.square);
			} else {
				radius = triangle.sideAB/(2*Math.sin(triangle.angleC));
			}
			return radius;
		}
		
		/**
		 * Описанная окружность
		 */
		public static function describedCircle(triangle:FPGTriangle2d):FPGCircle2d
		{
			var radius:Number = describedRadius(triangle);
			var center:FPGPoint2d = FPGLineToLine2dMath.crossLine(triangle.cHeightAB, triangle.cHeightBC);
			return new FPGCircle2d(center, radius);
		}
		
		/**
		 * Радиус вписанной окружности
		 */
		public static function inscribedRadius(triangle:FPGTriangle2d):Number
		{
			var p:Number = (triangle.sideAB+triangle.sideBC+triangle.sideCA)/2;
			return triangle.square/p;
		}
		
		/**
		 * Вписанная окружность
		 */		
		public static function inscribedCirlce(triangle:FPGTriangle2d):FPGCircle2d
		{
			var radius:Number = inscribedRadius(triangle);
			return new FPGCircle2d(triangle.inCentre, radius);
		}
		
		private static var abc1:ABC;
		private static var abc2:ABC;
		private static var ZERO:Point = new Point(0, 0);
		private static var ABSCISSA:Point = new Point(1, 0);
		/**
		 * Метод возвращает матрицу, которая преобразовывает треугольник triangle1 в triangle2
		 */
		public static function mathToTriangle(triangle1:FPGTriangle2d, triangle2:FPGTriangle2d):Matrix
		{
			var p11:Point = triangle2.p1.toPoint();
			var p12:Point = triangle2.p2.toPoint();
			var p13:Point = triangle2.p3.toPoint();
			//
			var p21:Point = triangle1.p1.toPoint();
			var p22:Point = triangle1.p2.toPoint();
			var p23:Point = triangle1.p3.toPoint();
			//
			var matrix:Matrix = new Matrix();
			matrix.translate(-p21.x, -p21.y);
			//
			//
			var rotate1:Number = angleToLines(p11, p12, ZERO, ABSCISSA);
			p12 = pointRotate(p12, rotate1, p11);
			p13 = pointRotate(p13, rotate1, p11);
			var rotate2:Number = angleToLines(p21, p22, ZERO, ABSCISSA);
			p21 = pointRotate(p21, rotate2, p21);
			p22 = pointRotate(p22, rotate2, p21);
			p23 = pointRotate(p23, rotate2, p21);
			matrix.rotate(rotate2);
			//
			//
			var h1:Number = Math.abs(p11.y-p13.y);
			if (!abc1) abc1 = new ABC();
			abc1.update(p11, p12);
			if (!abc2) abc2 = new ABC();
			abc2.update(p21, p22);
			if (abc1.value(p13)*abc2.value(p23) < 0) {
				h1 *= -1;
			}
			var h2:Number = Math.abs(p21.y-p23.y);
			var sideAB1:Number = Math.sqrt((p11.x-p12.x)*(p11.x-p12.x) + (p11.y-p12.y)*(p11.y-p12.y));
			var sideAB2:Number = Math.sqrt((p21.x-p22.x)*(p21.x-p22.x) + (p21.y-p22.y)*(p21.y-p22.y));
			var sx:Number = sideAB1/sideAB2;
			var sy:Number = h1/h2;
			matrix.scale(sx, sy);
			p21 = pointScale(p21, sx, sy);
			p22 = pointScale(p22, sx, sy);
			p23 = pointScale(p23, sx, sy);
			//
			//
			var skew1:Number = (p11.x-p13.x)/(p11.y-p13.y);
			var skew2:Number = (p21.x-p23.x)/(p21.y-p23.y);
			matrix.concat(new Matrix(1, 0, skew1-skew2));
			//
			//
			matrix.rotate(-rotate1);
			matrix.translate(triangle2.p1._x, triangle2.p1._y);
			//
			return matrix;
		}
		
		private static function pointRotate(p:Point, angle:Number, o:Point):Point
		{
			var matrix:Matrix = new Matrix();
			matrix.translate(-o.x, -o.y);
			matrix.rotate(angle);
			matrix.translate(o.x, o.y);
			p = matrix.transformPoint(p);
			return p;
		}
		private static function pointScale(p:Point, sx:Number, sy:Number):Point
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(sx, sy);
			return matrix.transformPoint(p);
		}
		
		private static function angleToLines(p11:Point, p12:Point,
											p21:Point, p22:Point
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
	}
}
import flash.geom.Point;

import ru.flashpress.geom.core.ns.geometry2d;
import ru.flashpress.geom.point.FPGPoint2d;

class ABC
{
	use namespace geometry2d;
	//
	public var a:Number;
	public var b:Number;
	public var c:Number;
	public function ABC(p1:Point=null, p2:Point=null)
	{
		if (p1 && p2) {
			update(p1, p2);
		}
	}
	
	public function update(p1:Point, p2:Point):void
	{
		a = (p2.y - p1.y);
		b = -(p2.x - p1.x);
		c = -a*p1.x - b*p1.y;
	}
	
	public function value(p:Point):Number
	{
		return a*p.x + b*p.y + c;
	}
	
	public function toString():String
	{
		return a.toFixed(2)+'|'+b.toFixed(2)+'|'+c.toFixed(2);
	}
}

class Point3d extends Point
{
	public var z:Number;
	public function Point3d(x:Number, y:Number, z:Number)
	{
		super(x, y);
		this.z = z;
	}
}