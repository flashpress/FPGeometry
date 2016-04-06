package ru.flashpress.geom.ellipse
{
	import ru.flashpress.geom.core.constants.FPGeom2dMath;
	import ru.flashpress.geom.core.constants.TransformTypes;
	import ru.flashpress.geom.core.interfaces.IParametricEquation;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;
	import ru.flashpress.geom.point.math.FPGPoint2dMath;
	
	/**
	 * Окружность
	 */
	public class FPGCircle2d extends FPGBase implements IParametricEquation
	{
		use namespace geometry2d;
		//
		geometry2d var _radius:Number;
		geometry2d var _radius2:Number;
		public function FPGCircle2d(center:FPGPoint2d, radius:Number)
		{
			super(center, radius, radius);
			this._radius = radius;
			this._radius2 = radius*radius;
		}
		
		/**
		 * Обновить параметры окружности
		 * @param center Центр окружности
		 * @param radius Радиус окружности
		 */
		public function update(center:FPGPoint2d, radius:Number):void
		{
			this._center = _center;
			this._radius = radius;
			this._radius2 = _radius*_radius;
			//
			this._a = _radius;
			this._a2 = _radius*_radius;
			this._b = _radius;
			this._b2 = _radius*_radius;
			//
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		/**
		 * Радиус окружности
		 */
		public function get radius():Number {return this._radius;}
		public function set radius(value:Number):void
		{
			this._radius = value;
			this._radius2 = _radius*_radius;
			//
			this._a = _radius;
			this._a2 = _radius*_radius;
			this._b = _radius;
			this._b2 = _radius*_radius;
			//
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		/**
		 * Получить координаты точки по времени 
		 * @param time Время от 0 до 1
		 */
		public override function pointFromTime(time:Number):FPGPoint2d
		{
			return super.pointFromTime(time);
		}
		
		/**
		 * Проверить лежит ли точка на окружности
		 */
		public override function pointContains(point:FPGPoint2d):Boolean
		{
			var len:Number = FPGPoint2dMath.length(point, _center);
			return Math.abs(len-_radius) < FPGeom2dMath.EXACTITUDE;
		}
		
		/**
		 * Проверить лежит ли точка внутри окружности
		 */
		public function pointInside(point:FPGPoint2d):Boolean
		{
			var len:Number = FPGPoint2dMath.length(point, _center);
			return len <= _radius;
		}
	}
}