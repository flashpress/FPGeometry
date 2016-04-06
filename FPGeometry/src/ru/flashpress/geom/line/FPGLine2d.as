package ru.flashpress.geom.line
{
	import flash.geom.Matrix;
	
	import ru.flashpress.geom.FPGElement2d;
	import ru.flashpress.geom.core.constants.TransformTypes;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;
	import ru.flashpress.geom.vector.FPGVector2d;

	/**
	 * Элемент описывающий прямую линию на плоскости
	 * @author Serious Sam
	 */
	public class FPGLine2d extends FPGElement2d
	{
		use namespace geometry2d;
		//
		// точки через которые проходит прямая
		geometry2d var _p1:FPGPoint2d;
		geometry2d var _p2:FPGPoint2d;
		//
		// Коэффициент уравнения прямой
		// Ax + By + C = 0;
		private var _a:Number;
		private var _b:Number;
		private var _c:Number;
		//
		// вектор нормали
        geometry2d var _normale:FPGVector2d;
		// вектор направления
        geometry2d var _direction:FPGVector2d;
		//
		// длина вектора
		geometry2d var _length:Number;
		//
		/**
		 * Конструктор
		 * @param p1 Первая точка через которую проходит прямая
		 * @param p2 Вторая точка через которую проходит прямая
		 * 
		 */
		public function FPGLine2d(p1:FPGPoint2d, p2:FPGPoint2d)
		{
			super();
			//
			this._direction = new FPGVector2d(0, 0);
			this._normale = new FPGVector2d(0, 0);
			this.reinit(p1, p2);
			this.changeEvent(TransformTypes.FREEDOM);
		}
		
		private function reinit(p1:FPGPoint2d, p2:FPGPoint2d):void
		{
			super.deleteChild(this._p1);
			this._p1 = p1;
			super.registerChild(this._p1, -1);
			//
			super.deleteChild(this._p2);
			this._p2 = p2;
			super.registerChild(this._p2, -1);
		}
		
		geometry2d override function applyMatrix(matrix:Matrix):void
		{
			super.lockChangeEvent = true;
			this._p1.transform(matrix);
			this._p2.transform(matrix);
			super.lockChangeEvent = false;
		}
		
		private var isABC:Boolean;
		private function getABC():void
		{
			this.isABC = true;
			var n:FPGVector2d = this.normale;
			this._a = -n._x;
			this._b = -n._y;
			this._c = this._p1._x*n._x + this._p1._y*n._y;
		}
		
		/**
		 * @private
		 */		
		protected override function changeEvent(tt:int):void
		{
			if (tt != 2) {
				//this._direction = new FPGVector2d();
				this._direction.update(this._p2._x-this._p1._x, this._p2._y-this._p1._y);
				this._length = -1;
				//this._normale = new FPGVector2d(-this._direction._y, this._direction._x);
				this._normale.update(-this._direction._y, this._direction._x);
			}
			this.isABC = false;
			//
			super.changeEvent(tt);
		}
		
		/**
		 * @private
		 */
		public override function toString():String
		{
			return '[FPGLine p1="'+this._p1+'", p2="'+this._p2+'"]';
		}
		
		/**
		 * Идентификатор линии. Формируется как строка id1+"-"+id2,
		 * где id1 и id2 - идентификаторы точек p1 и p2 соответственно.
		 */
		public function get id():String
		{
			return this._p1.id+'-'+this._p2.id;
		}
		
		/**
		 * @private
		 */
		public override function rotation(angle:Number, point:FPGPoint2d=null):void
		{
			if (point == null) {
				point = new FPGPoint2d((this._p1._x+this._p2._x)/2, (this._p1._y+this._p2._y)/2);
			}
			super.rotation(angle, point);
		}
		
		/**
		 * @private
		 */		
		public override function skew(sx:Number, sy:Number, point:FPGPoint2d=null):void
		{
			if (point == null) {
				point = new FPGPoint2d((this._p1._x+this._p2._x)/2, (this._p1._y+this._p2._y)/2);
			}
			super.skew(sx, sy, point);
		}
		
		
		/**
		 * @private
		 */
		public override function scale(sx:Number, sy:Number, point:FPGPoint2d=null):void
		{
			if (point == null) {
				point = new FPGPoint2d((this._p1._x+this._p2._x)/2, (this._p1._y+this._p2._y)/2);
			}
			super.scale(sx, sy, point);
		}
		
		/**
		 * Первая точка, через которую проходит прямая
		 */
		public function get p1():FPGPoint2d {return this._p1;}
		public function set p1(value:FPGPoint2d):void
		{
			super.deleteChild(this._p1);
			this._p1 = value;
			super.registerChild(this._p1);
			//
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		/**
		 * Вторая точка, через которую проходит прямая
		 */
		public function get p2():FPGPoint2d {return this._p2;}
		public function set p2(value:FPGPoint2d):void
		{
			super.deleteChild(this._p2);
			this._p2 = value;
			super.registerChild(this._p2);
			//
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		/**
		 * Длина отрезка p1-p2
		 */
		public function get length():Number
		{
			if (this._length != -1) return this._length;
			this._length = this._direction.module;
			return this._length;
		}
		
		/**
		 * Вектор нормали
		 */
		public function get normale():FPGVector2d
		{
			return this._normale;
		}
		
		/**
		 * Вектор направления
		 */
		public function get direction():FPGVector2d {return this._direction;}
		
		
		/**
		 * Обновить координаты точек
		 * @param p1 первая точка через которую проходит прямая
		 * @param p2 вторая точка через которую проходит прямая
		 */
		public function update(p1:FPGPoint2d, p2:FPGPoint2d):void
		{
			this.reinit(p1, p2);
			//
			this.dispatchChange(1);
		}
		
		
		/**
		 * Получить копию линии
		 */
		public function clone():FPGLine2d
		{
			return new FPGLine2d(this._p1.clone(), this._p2.clone());
		}
		
		/**
		 * Получить значение уравнения прямой Ax+By+C в заданной точке
		 */
		public function valueFromPoint(p:FPGPoint2d):Number
		{
			if (!this.isABC) this.getABC();
			return this._a*p._x + this._b*p._y + this._c;
		}
		
		/**
		 * Получить координату Y по заданной координате X
		 */
		public function yFromX(valueX:Number):Number
		{
			if (!this.isABC) this.getABC();
			return -(this._a*valueX + this._c)/this._b;
		}
		
		/**
		 * Получить координату X по заданной координате Y
		 */
		public function xFromY(valueY:Number):Number
		{
			if (!this.isABC) this.getABC();
			return -(this._b*valueY + this._c)/this._a;
		}
		
		private var xt:Number;
		private var yt:Number;
		/**
		 * Координаты точки по времени, время равное 0 соответствует точке p1,
		 * время равное 1 - p2.
		 */
		public function pointFromTime(t:Number):FPGPoint2d
		{
			xt = this._p1._x+t*(this._p2._x-this._p1._x);
			yt = this._p1._y+t*(this._p2._y-this._p1._y);
			//
			return new FPGPoint2d(xt, yt);
		}
		
		/**
		 * Время соответствующее заданной точке,
		 * время равное 0 соответствует точке p1, время равное 1 - p2.
		 * Подразумевается, что заданная точка p лежит на прямой. 
		 */
		public function timeFromPoint(p:FPGPoint2d):Number
		{
			return Math.sqrt(((p.x-this._p1.x)*(p.x-this._p1.x) + (p.y-this._p1.y)*(p.y-this._p1.y))/this._direction.module2);
		}
		
		/**
		 * Является ли линия одной точкой, т.е. точк p1 и p2 совпадают. Проверяется с точностью FPGeom2dMath.EXACTITUDE
		 * @see ru.flashpress.geom.core.constants.FPGeom2dMath#EXACTITUDE
		 */
		public function isZero():Boolean
		{
			return this._p1.compare(this._p2);
		}
		
		/**
		 * Сравнить две линии. Проверяется с точностью FPGeom2dMath.EXACTITUDE
		 * @param line Сравниваемая линия
		 * @param ignoreDirection Игнорировать направление.
		 * @see ru.flashpress.geom.core.constants.FPGeom2dMath#EXACTITUDE
		 */
		public function compare(line:FPGLine2d, ignoreDirection:Boolean):Boolean
		{
			if (this._p1.compare(line._p1) && this._p2.compare(line._p2)) {
				return true;
			}
			if (ignoreDirection) {
				return this._p1.compare(line._p2) && this._p2.compare(line._p1);
			}
			return false;
		}
	}
}