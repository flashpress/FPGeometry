package ru.flashpress.geom.line.broken
{
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;
	
	/**
	 * Вершина ломанной линии
	 * @private
	 */
	public class FPGLineVertex2d extends FPGPoint2d
	{
		use namespace geometry2d;
		//
		geometry2d var _index:uint;
		geometry2d var _position:Number = 0;
		/**
		 * @private
		 */
		public function FPGLineVertex2d(index:uint, x:Number, y:Number)
		{
			super(x, y);
			//
			this._index = index;
		}
		
		/**
		 * Индекс точки в массиве точек линии
		 */
		public function get index():uint {return this._index;}
		
		/**
		 * Позиция(длина) точки начиная с первой точки
		 */
		public function get position():Number {return this._position;}
	}
}