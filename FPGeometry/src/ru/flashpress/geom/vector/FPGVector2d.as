package ru.flashpress.geom.vector
{
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;

	/**
	 * Элемент описывющий вектор на плоскости
	 * @author Serious Sam
	 */
	public class FPGVector2d extends FPGPoint2d
	{
		use namespace geometry2d;
		//
		/**
		 * Нулевой вектор
		 */
		public static const ZERO:FPGVector2d = new FPGVector2d(0, 0);
		
		/**
		 * Единичный вектор направленный вдоль оси X
		 */
		public static const ABSCISSA:FPGVector2d = new FPGVector2d(1, 0);
		
		/**
		 * Единичный вектор направленный вдоль оси Y
		 */
		public static const ORDINATE:FPGVector2d = new FPGVector2d(0, 1);
		//
		//
		//
		// угол поворота вектора
		private var _angle:Number;
		// длина вектора
		private var _module:Number;
		private var _module2:Number;
		/**
		 * Конструктор
		 * @param _x Координата по X
		 * @param _y Координата по Y
		 * 
		 */
		public function FPGVector2d(_x:Number, _y:Number)
		{
			super(_x, _y);
		}
		
		/**
		 * @private
		 */		
		protected override function changeEvent(tt:int):void
		{
			if (tt != 2 && tt != 5) {
				this._module = NaN;
				this._module2 = NaN;
			}
			if (tt != 2 && tt != 3) {
				this._angle = NaN;
			}
			//
			super.changeEvent(tt);
		}
		
		/**
		 * Угол поворота вектора, данное значение показывает
		 * на сколько необходимо повернуть вектор, направленный вдоль положительной оси X,
		 * так, что бы он совпал с текущим вектором. Если значение отрицательное,
		 * значит вектор необходимо повернуть против часовой стрелки.
		 * Значение не может выйти за рамки {-Math.PI..Math.PI].
		 */
		public function get angle():Number
		{
			if (isNaN(this._angle)) {
				this._angle = Math.atan2(this._y, this._x);
			}
			return this._angle;
		}
		
		/**
		 * Длина вектора
		 */
		public function get module():Number
		{
			if (isNaN(this._module)) {
				this._module = Math.sqrt(this._x*this._x + this._y*this._y);
			}
			return this._module;
		}
		
		/**
		 * Квадрат длина вектора
		 */
		public function get module2():Number
		{
			if (isNaN(this._module2)) {
				this._module2 = this._x*this._x + this._y*this._y;
			}
			return this._module2;
		}
		
		/**
		 * Нормировать вектор
		 */
		public function normalize():void
		{
			if (this.module != 0) {
				this._x /= this._module;
				this._y /= this._module;
				this._module = 1;
			} else {
				this._x = 0;
				this._y = 0;
			}
		}
		
		/**
		 * Повернуть на угол "delta" в радианах
		 */
		public function rotate(delta:Number):void
		{
			this._angle += delta;
			this.x = this._module*Math.cos(this._angle);
			this.y = this._module*Math.sin(this._angle);
		}
		
		/**
		 * Получить клона вектора
		 */
		public override function clone():FPGPoint2d
		{
			return new FPGVector2d(this._x, this._y);
		}
	}
}