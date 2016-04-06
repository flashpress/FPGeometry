package ru.flashpress.geom.ellipse
{
	import ru.flashpress.geom.core.constants.TransformTypes;
	import ru.flashpress.geom.core.interfaces.IParametricEquation;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;

	/**
	 * Эллипс
	 */
	public class FPGEllipse2d extends FPGBase implements IParametricEquation
	{
		use namespace geometry2d;
		//
		public function FPGEllipse2d(center:FPGPoint2d, a:Number, b:Number)
		{
			super(center, a, b);
		}
		
		
		/**
		 * Обновить параметр эллипса
		 * @param center Центр эллипса
		 * @param a Длина первой полуоси
		 * @param b Длина второй полуоси
		 * 
		 */
		public function update(center:FPGPoint2d, a:Number, b:Number):void
		{
			reinit(center, a, b);
			dispatchChange(TransformTypes.FREEDOM);
		}
		
		/**
		 * Длина первой полуоси
		 */
		public function get a():Number {return this._a;}
		public function set a(value:Number):void
		{
			this._a = value;
			this._a2 = value*value;
			//
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		/**
		 * Длина второй полуоси
		 */
		public function get b():Number {return this._b;}
		public function set b(value:Number):void
		{
			this._b = value;
			this._b2 = value*value;
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
			return super.pointContains(point);
		}
	}
}