package ru.flashpress.geom.polygon
{
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.line.FPGLine2d;
	import ru.flashpress.geom.point.FPGPoint2d;

	/**
	 * Ребро полигона
	 * @author Serios Sam
	 */
	public class FPGEdge2d extends FPGLine2d
	{
		use namespace geometry2d;
		//
		geometry2d var _index:int;
		/**
		 * Конструктор
		 * @param _index Номер ребра 
		 * @param p1 Первая точка отрезка
		 * @param p2 Вторая точка отрезка 
		 * 
		 */
		public function FPGEdge2d(_index:int, p1:FPGPoint2d, p2:FPGPoint2d)
		{
			super(p1, p2);
			this._index = _index;
		}
		
		/**
		 * Номер ребра при положительном обходе
		 */
		public function get index():int {return _index;}
		
		/**
		 * Создать копию ребра.
		 */
		public override function clone():FPGLine2d
		{
			var cloneEdge:FPGEdge2d = new FPGEdge2d(this._index, this._p1.clone(), this._p2.clone());
			return cloneEdge;
		}
		
		/**
		 * @private
		 */
		public override function toString():String
		{
			return '[FPGEdge2d index="'+index+'" p1="'+_p1+'", p2="'+_p2+'", name="'+super.name+'"]';
		}
	}
}