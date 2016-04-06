package ru.flashpress.geom.vector.math
{
	import ru.flashpress.geom.core.constants.FPGeom2dMath;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;
	import ru.flashpress.geom.vector.FPGVector2d;

	/**
	 * Математические операции вектора
	 * @author Serious Sam
	 */
	public class FPGVector2dMath
	{
		use namespace geometry2d;
		//
		/**
		 * Наименьший(!) угол между двумя векторами в радианах,
		 * значение этого угла не может выйти зна рамки [0..Math.PI], при любом направлении векторов. 
		 */
		public static function angleBetween(v1:FPGVector2d, v2:FPGVector2d):Number
		{
			var a:Number = v1.angle-v2.angle;
			if (Math.abs(a) > Math.PI) {
				a = Math.PI*2-Math.abs(a);
			}
			return Math.abs(a);
		}
		
		/**
		 * Угол, котороый необходимо повернуть вектор v1, так, что бы он совпал с вектором v2,
		 * угол измеряется в радианах и может принимать значения [-Math.PI..Math.PI]
		 */
		public static function angleDirection(v1:FPGVector2d, v2:FPGVector2d):Number
		{
			var a1:Number = Math.atan2(v1._y, v1._x);
			var a2:Number = Math.atan2(v2._y, v2._x);
			return a1-a2;
		}
		
		/**
		 * Угол, на который необходимо повернуть по часовой стрелке первый вектор(v1) так,
		 * что бы он совпал со вторым вектором(v2), угол измеряется в радианах и
		 * может принимать значение в рамках [0..Math.PI*2].
		 */
		public static function angleTo(v1:FPGVector2d, v2:FPGVector2d):Number
		{
			var a1:Number = Math.atan2(v1._y, v1._x);
			if (a1 < 0) a1 = Math.PI*2+a1;
			var a2:Number = Math.atan2(v2._y, v2._x);
			if (a2 < 0) a2 = Math.PI*2+a2;
			var a:Number = a2-a1;
			if (a < 0) a = Math.PI*2+a;
			return a;
		}
		
		/**
		 * Сколярное произведение двух векторов
		 */
		public static function scolar(v1:FPGPoint2d, v2:FPGPoint2d):Number
		{
			return v1._x*v2._x + v1._y*v2._y;
		}
		
		/**
		 * Проверка на ортогональность. Проверяется с точностью FPGeom2dMath.EXACTITUDE
		 * @see ru.flashpress.geom.core.constants.FPGeom2dMath#EXACTITUDE
		 */
		public static function isOrthogonal(v1:FPGVector2d, v2:FPGVector2d):Boolean
		{
			return scolar(v1, v2) < FPGeom2dMath.EXACTITUDE;
		}
		
		
		/**
		 * Проверка на паралельность. Угол сравнивается с точностью FPGeom2dMath.EXACTITUDE
		 * @see ru.flashpress.geom.core.constants.FPGeom2dMath#EXACTITUDE
		 */
		public static function isParallel(v1:FPGVector2d, v2:FPGVector2d):Boolean
		{
			var a:Number = angleBetween(v1, v2);
			return 	a < FPGeom2dMath.EXACTITUDE ||
					Math.PI-a < FPGeom2dMath.EXACTITUDE;
		}
		
		/**
		 * Проверка на сонаправленность. Проверяется с точностью FPGeom2dMath.EXACTITUDE
		 * @see ru.flashpress.geom.core.constants.FPGeom2dMath#EXACTITUDE
		 */
		public static function isCodirectional(v1:FPGVector2d, v2:FPGVector2d):Boolean
		{
			return Math.abs(scolar(v1, v2)-1) < FPGeom2dMath.EXACTITUDE;
		}
		
		/**
		 * Проверка на анти сонаправленность. Проверяется с точностью FPGeom2dMath.EXACTITUDE
		 * @see ru.flashpress.geom.core.constants.FPGeom2dMath#EXACTITUDE
		 */
		public static function isOpposite(v1:FPGVector2d, v2:FPGVector2d):Boolean
		{
			return scolar(v1, v2) + 1 < FPGeom2dMath.EXACTITUDE;
		}
		
		/**
		 * Получить проекцию вектора v1 на вектор v2, если вектора перпендикулярны,
		 * то возвращается нулевой вектор FPGVector2d.ZERO
		 * @see ru.flashpress.geom.vector.FPGVector2d#ZERO
		 */		
		public static function projection(v1:FPGVector2d, v2:FPGVector2d):FPGVector2d
		{
			var a:Number = angleBetween(v1, v2);
			if (Math.abs(a-Math.PI/2) < FPGeom2dMath.EXACTITUDE) {
				return FPGVector2d.ZERO;
			}
			var proj:FPGVector2d = v2.clone() as FPGVector2d;
			proj.normalize();
			var d:Number = v1.module*Math.cos(a);
			proj.update(proj._x*d, proj._y*d);
			return proj;
		}
	}
}