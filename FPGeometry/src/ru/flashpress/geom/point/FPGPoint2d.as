package ru.flashpress.geom.point
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import ru.flashpress.geom.FPGElement2d;
	import ru.flashpress.geom.core.constants.FPGeom2dMath;
	import ru.flashpress.geom.core.constants.TransformTypes;
	import ru.flashpress.geom.core.ns.geometry2d;
	
	/**
	 * Элемент описывающий точку на плоскости
	 * @author Serious Sam
	 */
	public class FPGPoint2d extends FPGElement2d implements IFPGPoint
	{
		use namespace geometry2d;
		//
		geometry2d var _x:Number;
		geometry2d var _y:Number;
		
		/**
		 * @private
		 */
		geometry2d var _id:String;
		/**
		 * Конструктор
		 * @param _x Координата точки по X
		 * @param _y Координата точки по Y
		 * @param _name Название точки
		 * 
		 */
		public function FPGPoint2d(x:Number=0, y:Number=0)
		{
			super();
			this._x = x;
			this._y = y;
		}
		
		private var _tmp:Point = new Point();
		private var _tmp2:Point;
		geometry2d override function applyMatrix(matrix:Matrix):void
		{
			this._tmp.x = this._x;
			this._tmp.y = this._y;
			_tmp2 = matrix.transformPoint(_tmp);
			this._x = _tmp2.x;
			this._y = _tmp2.y;
			this._id = null;
		}
		
		/**
		 * Идентификатор точки. Формирует как строка XXxYY,
		 * где XX и YY координаты округленные до FPGeom2dMath.EXACTITUDE.
		 * @see ru.flashpress.geom.core.constants.FPGeom2dMath#EXACTITUDE
		 */
		public function get id():String
		{
			if (this._id != null) return this._id;
			//
			this._id = uint(this._x/FPGeom2dMath.EXACTITUDE)*FPGeom2dMath.EXACTITUDE+'x'+uint(this._y/FPGeom2dMath.EXACTITUDE)*FPGeom2dMath.EXACTITUDE;
			//
			return this._id;
		}
		
		/**
		 * @private 
		 */		
		public override function toString():String
		{
			return '[FPGPoint x="'+this._x+'", y="'+this._y+'"]';
		}
		
		/**
		 * Текущая координата по X
		 */
		public function get x():Number {return _x;}
		public function set x(value:Number):void
		{
			this._x = value;
			this._id = null;
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		/**
		 * Текущая координата по Y
		 */
		public function get y():Number {return _y;}
		public function set y(value:Number):void
		{
			this._y = value;
			this._id = null;
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		/**
		 * Обновить координаты x и y
		 */
		public function update(_x:Number, _y:Number):void
		{
			this._x = _x;
			this._y = _y;
			this._id = null;
			this.dispatchChange(TransformTypes.FREEDOM);
		}

		/**
		 * Копировать значения из point в текуший объект
		 */
		public function copy(point:FPGPoint2d):void
		{
			this._x = point._x;
			this._y = point._y;
			this._id = point._id;
			this.dispatchChange(TransformTypes.FREEDOM);
		}

		/*
		public function addPoint(point:FPGPoint2d):void
		{
			this._x += point._x;
			this._y += point._y;
			this._id = null;
			this.change(TransformTypes.TRANSLATE);
		}
		
		
		public function subPoint(point:FPGPoint2d):void
		{
			this._x -= point._x;
			this._y -= point._y;
			this._id = null;
			this.change(TransformTypes.TRANSLATE);
		}
		*/
		

		/*
		public function multiply(d:Number):void
		{
			this._x *= d;
			this._y *= d;
			this._id = null;
			this.change(TransformTypes.SCALE);
		}
		*/
		
		/**
		 * Сравнить две точки. Проверяется с точностью FPGeom2dMath.EXACTITUDE.
		 * @see ru.flashpress.geom.core.constants.FPGeom2dMath#EXACTITUDE
		 */
		public function compare(point:FPGPoint2d):Boolean
		{
			return 	Math.abs(this._x-point._x) < FPGeom2dMath.EXACTITUDE &&
					Math.abs(this._y-point._y) < FPGeom2dMath.EXACTITUDE;
		}
		
		/**
		 * Получить копию точки.
		 */
		public function clone():FPGPoint2d
		{
			return new FPGPoint2d(this._x, this._y);
		}
		
		/**
		 * ПОлучить объект Point
		 */
		public function toPoint():Point
		{
			return new Point(this._x, this._y);
		}

		/**
		 * Поместить осовбожденный объект в пул
		 */
		public function release():void
		{
			FPGPoint2dFactory._pool.push(this);
		}
		
	}
}