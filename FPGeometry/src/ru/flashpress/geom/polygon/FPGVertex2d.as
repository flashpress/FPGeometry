package ru.flashpress.geom.polygon
{
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;

	/**
	 * Вершина полигона
	 * @author Serious Sam
	 */
	public class FPGVertex2d extends FPGPoint2d
	{
		use namespace geometry2d;
		//
		/**
		 * @private
		 */
		geometry2d var _index:int;
		
		/**
		 * @private
		 */
		geometry2d var _leftEdge:FPGEdge2d;
		
		/**
		 * @private
		 */
		geometry2d var _rightEdge:FPGEdge2d;
		/**
		 * Конструкток
		 * @param _index Номер вершины
		 * @param _x Координата по X
		 * @param _y Координата по X
		 * @param _name Название вершины
		 * 
		 */
		public function FPGVertex2d(_index:int, _x:Number, _y:Number)
		{
			this._index = _index;
			super(_x, _y);
		}
		
		/**
		 * Ребро слева от вершины
		 */
		public function get leftEdge():FPGEdge2d {return _leftEdge;}
		
		/**
		 * Ребро справа от вершины
		 */
		public function get rightEdge():FPGEdge2d {return _rightEdge;}
		
		/**
		 * Создать копию вершины
		 */
		public override function clone():FPGPoint2d
		{
			var vertexClone:FPGVertex2d = new FPGVertex2d(this._index, this._x, this._y);
			vertexClone._leftEdge = this._leftEdge;
			vertexClone._rightEdge = this._rightEdge;
			return vertexClone;
		}
		
		/**
		 * @private
		 */
		public override function toString():String
		{
			return '[FPGVertex2d index="'+_index+'", xy="'+_x+'x'+_y+'", left="'+_leftEdge._index+'", right="'+_rightEdge._index+'", name="'+super.name+'"]';
		}
	}
}