package ru.flashpress.geom.core.bounds
{
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;

	/**
	 * Ограничивающий прямоугольник
	 * @author Serious Sam
	 * 
	 */
	public class FPGBounds
	{
		use namespace geometry2d;
		//
		geometry2d var cleared:Boolean;
		//
		geometry2d var _x:Number;
		geometry2d var _y:Number;
		geometry2d var _width:Number;
		geometry2d var _height:Number;
		/**
		 * Конструктор
		 * @param x Координата X левого верхнего угла прямоугольника
		 * @param y Координата Y левого верхнего угла прямоугольника
		 * @param width Ширинв прямоугольника
		 * @param height Высота прямоугольника
		 * 
		 */
		public function FPGBounds(x:Number, y:Number, width:Number, height:Number)
		{
			this._x = x;
			this._y = y;
			this._width = width;
			this._height = height;
		}
		
		/**
		 * Координата X левого верхнего угла прямоугольника
		 */
		public function get x():Number {return this._x;}
		
		/**
		 * Координата Y левого верхнего угла прямоугольника
		 */
		public function get y():Number {return this._y;}
		
		/**
		 * Ширинв прямоугольника
		 */
		public function get width():Number {return this._width;}
		
		/**
		 * Высота прямоугольника
		 */
		public function get height():Number {return this._height;}
		
		/**
		 * Создать копию прямоугольника
		 * @private
		 */
		private function clone():FPGBounds
		{
			return new FPGBounds(this._x, this._y, this._width, this._height);
		}
		
		public function get points():Vector.<FPGPoint2d>
		{
			return new <FPGPoint2d>[new FPGPoint2d(this._x, 			this._y),
									new FPGPoint2d(this._x+this._width, this._y),
									new FPGPoint2d(this._x+this._width, this._y+this._height),
									new FPGPoint2d(this._x, 			this._y+this._height)]
		}
		
		public function get center():FPGPoint2d
		{
			return new FPGPoint2d(this._x+this._width/2, this._y + this._height/2);
		}
		
		/**
		 * @private
		 */		
		public function toString():String
		{
			return '[FPBounds: x="'+this._x+'", y="'+this._y+'", width="'+this._width+'", height="'+this._height+'"]';
		}
	}
}