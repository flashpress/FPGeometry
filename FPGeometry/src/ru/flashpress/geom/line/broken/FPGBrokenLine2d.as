package ru.flashpress.geom.line.broken
{
	import flash.geom.Matrix;
	
	import ru.flashpress.geom.FPGElement2d;
	import ru.flashpress.geom.core.bounds.FPGBounds;
	import ru.flashpress.geom.core.constants.FPGeom2dMath;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;
	import ru.flashpress.geom.point.math.FPGPoint2dMath;
	import ru.flashpress.geom.polygon.FPGEdge2d;
	
	/**
	 * @private
	 */
	public class FPGBrokenLine2d extends FPGElement2d
	{
		use namespace geometry2d;
		//
        geometry2d var _points:Vector.<FPGLineVertex2d>;
        geometry2d var _centerPoints:FPGPoint2d;
        geometry2d var _length:Number = -1;
        geometry2d var _isSelfCrossing:Object;
		// ограничивающий прямоугольник
        geometry2d var _bounds:FPGBounds;
		public function FPGBrokenLine2d(points:Vector.<FPGPoint2d>=null)
		{
			super();
			this.reinit(points);
		}
		
		private function reinit(points:Vector.<FPGPoint2d>):void
		{
			//
			var i:uint;
			var point:FPGPoint2d;
			var pc:uint;
			if (this._points) {
				pc = this._points.length;
				for (i=0; i<pc; i++) {
					point = this._points[i];
					this.deleteChild(point);
				}
			}
			//
			this._points = new Vector.<FPGLineVertex2d>();
			if (points) {
				pc = points.length;
				var vertex:FPGLineVertex2d;
				var prev:FPGLineVertex2d;
				for (i=0; i<pc; i++) {
					point = points[i];
					vertex = new FPGLineVertex2d(i, point._x, point._y);
					this._points.push(vertex);
					this.registerChild(vertex);
					//
					if (prev) {
						this._length += FPGPoint2dMath.length(prev, vertex);
						vertex._position = this._length;
					} else {
						vertex._position = 0;
					}
					prev = vertex;
					//
				}
				for (i=0; i<_points.length; i++) {
					vertex = _points[i];
				}
			} else {
				this._length = 0;
			}
		}
		
		private function resetLength():void
		{
			this._length = 0;
			//
			var i:uint;
			var point:FPGPoint2d;
			var pc:uint;
			//
			pc = this._points.length;
			var vertex:FPGLineVertex2d;
			var prev:FPGLineVertex2d;
			for (i=0; i<pc; i++) {
				vertex = this._points[i];
				//
				if (prev) {
					this._length += FPGPoint2dMath.length(prev, vertex);
					vertex._position = this._length;
				} else {
					vertex._position = 0;
				}
				prev = vertex;
			}
		}
		
		
		/**
		 * @private
		 */
		protected override function changeEvent(tt:int):void
		{
			_centerPoints = null;
			if (tt == 1 || tt == 3 || tt == 4 ) {
				resetLength();
			}
			//
			this._bounds = null;
			//
			if (tt == 1) {
				_isSelfCrossing = null;
				_isClosing = null;
			}
			//
			super.changeEvent(tt);
		}
		
		/**
		 * Применить матрицу преобразования ко всем вершинам полигона
		 * @param matrix
		 * @private
		 */
		geometry2d override function applyMatrix(matrix:Matrix):void
		{
			var vc:int = this._points.length;
			// флаг запрещающий
			// отправку событий об изменении точек/точки 
			super.lockChangeEvent = true;
			// применяем матрицу ко всем вершинам
			var i:uint;
			var point:FPGPoint2d;
			for (i=0; i<vc; i++) {
				point = this._points[i];
				point.transform(matrix);
			}
			// убиваем флаг
			super.lockChangeEvent = false;
		}
		
		/**
		 * @private
		 */
		public override function rotation(angle:Number, point:FPGPoint2d=null):void
		{
			if (point == null) {
				point = this.centerPoints;
			}
			super.rotation(angle, point);
		}
		
		/**
		 * @private
		 */
		public override function skew(sx:Number, sy:Number, point:FPGPoint2d=null):void
		{
			if (point == null) {
				point = this.centerPoints;
			}
			super.skew(sx, sy, point);
		}
		
		/**
		 * @private
		 */
		public override function scale(sx:Number, sy:Number, point:FPGPoint2d=null):void
		{
			if (point == null) {
				point = this.centerPoints;
			}
			super.scale(sx, sy, point);
		}
		
		/**
		 * Центр системы точек ломанной линии
		 */
		public function get centerPoints():FPGPoint2d
		{
			if (this._centerPoints) return _centerPoints;
			//
			var i:uint;
			var pc:uint = points.length;
			var point:FPGPoint2d;
			var x:Number = 0;
			var y:Number = 0;
			for (i=0; i<pc; i++) {
				point = points[i];
				x += point._x;
				y += point._x;
			}
			this._centerPoints = new FPGPoint2d(x/pc, y/pc);
			//
			return this._centerPoints;
		}
		
		private var vertex:FPGLineVertex2d;
		private var minX:Number;
		private var minY:Number;
		private var maxX:Number;
		private var maxY:Number;
		/**
		 * Ограничивающий прямоугольник
		 */
		final public function get bounds():FPGBounds
		{
			if (_bounds != null) {
				return _bounds;
			}
			//
			// вычисляем ограничивающий прямоугольник
			vertex = this._points[0];
			minX = vertex._x;
			minY = vertex._y;
			maxX = vertex._x;
			maxY = vertex._y;
			const vc:int = this._points.length;
			var i:int;
			for (i=0; i<vc; i++) {
				vertex = this._points[i];
				minX = Math.min(minX, vertex._x);
				minY = Math.min(minY, vertex._y);
				maxX = Math.max(maxX, vertex._x);
				maxY = Math.max(maxY, vertex._y);
			}
			this._bounds = new FPGBounds(minX, minY, maxX-minX, maxY-minY);
			return _bounds;
		}
		
		/**
		 * Массив точек ломанной линии
		 */
		public function get points():Vector.<FPGLineVertex2d> {return this._points.slice();}
		
		/**
		 * Обновить местоположение точек ломанной линии 
		 */
		public function update(value:Vector.<FPGPoint2d>):void
		{
			this.reinit(value);
			this.dispatchChange(1);
		}
		
		/**
		 * Длина ломанной линии
		 */
		public function get length():Number {return _length;}
		
		/**
		 * Получить местоположение точки на ломанной линии по заданному времени,
		 * где время 0 соответствует местоположениею первой точки, а 1 - последней.
		 */
		public function pointFromTime(t:Number):FPGPoint2d
		{
			if (t < 0) t = 0;
			if (t > 1) t = 1;
			//
			var i:uint = 0;
			var end:FPGLineVertex2d;
			var vertex:FPGLineVertex2d;
			var vc:uint = this._points.length;
			while (i < vc && !end) {
				vertex = this._points[i];
				if (vertex._position/this._length >= t) {
					end = vertex;
				}
				i++;
			}
			if (Math.abs(end._position/this._length-t) < FPGeom2dMath.EXACTITUDE) return new FPGPoint2d(end._x, end._y);
			var start:FPGLineVertex2d = this._points[end._index-1];
			var t1:Number = start._position/this._length;
			var t2:Number = end._position/this._length;
			var percent:Number = (t-t1)/(t2-t1);
			var xt:Number = start._x+percent*(end._x-start._x);
			var yt:Number = start._y+percent*(end._y-start._y);
			return new FPGPoint2d(xt, yt);
		}
		
		
		/**
		 * Является ли ломанная линия самопересекающейся
		 */
		public function get isSelfCrossing():Boolean
		{
			if (_isSelfCrossing != null) return _isSelfCrossing as Boolean;
			//
			var count:int = this._points.length;
			var efge:FPGEdge2d;
			var i:int;
			var j:int;
			var i2:int = count-2;
			var j1:int;
			var j2:int;
			for (i=0; i<i2; i++) {
				j1 = i+2;
				j2 = count-1;
				for (j=j1; j<j2; j++) {
					if (FPGPoint2dMath.isCrossPiece(this._points[i],
													this._points[i+1],
													this._points[j],
													this._points[j+1]))
					{
						this._isSelfCrossing = true;
						return this._isSelfCrossing;
					}
				}
			}
			//
			return _isSelfCrossing as Boolean;
		}
		
		private var _isClosing:Object;
		public function get isClosing():Boolean
		{
			if (_isClosing != null) return _isClosing as Boolean;
			//
			//
			return _isClosing as Boolean;
		}
	}
}