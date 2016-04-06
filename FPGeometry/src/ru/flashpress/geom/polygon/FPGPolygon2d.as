package ru.flashpress.geom.polygon
{
	import flash.geom.Matrix;
	
	import ru.flashpress.geom.FPGElement2d;
	import ru.flashpress.geom.core.bounds.FPGBounds;
	import ru.flashpress.geom.core.ns.geomTestFunctions;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.line.math.FPGLineToLine2dMath;
	import ru.flashpress.geom.point.FPGPoint2d;
	import ru.flashpress.geom.point.math.FPGPoint2dMath;
	import ru.flashpress.geom.polygon.math.FPGPolyToPoly2dMath;
	import ru.flashpress.geom.triangles.FPGTriangle2d;

	/**
	 * Полигон на плоскости
	 * @author Serious Sam
	 */
	public class FPGPolygon2d extends FPGElement2d
	{
		use namespace geometry2d;
		//
		// вершины полигона
		geometry2d var _vertexes:Vector.<FPGVertex2d>;
		// ребра полигона
		geometry2d var _edges:Vector.<FPGEdge2d>;
		// ограничивающий прямоугольник
		geometry2d var _bounds:FPGBounds;
		public function FPGPolygon2d(points:Vector.<FPGPoint2d>)
		{
			super();
			this._bounds = new FPGBounds(0, 0, 0, 0);
			this._bounds.cleared = true;
			this.reinit(points);
		}
		
		//geometry2d var squareComplete:Boolean;
		private var _square:Number = -1;
		private var _centerWeight:FPGPoint2d;
		private var _centerPoints:FPGPoint2d;
		private var _isConvex:Object;
		private var _isSelfCrossing:Object;
		//
		private function getSquare():void
		{
			this._square = 0;
			var triangleCenter:FPGPoint2d;
			var triangleSquare:Number;
			var tempCenterX:Number = 0;
			var tempCenterY:Number = 0;
			var i:int;
			var count:int = this._vertexes.length;
			for (i=1; i < count-1; i++) {
				triangleCenter = FPGPolyToPoly2dMath.triangleCenter(this._vertexes[0], this._vertexes[i], this._vertexes[i+1]);
				triangleSquare = FPGPolyToPoly2dMath.triangleSquare(this._vertexes[0], this._vertexes[i], this._vertexes[i+1]);
				//
				tempCenterX += triangleSquare*triangleCenter._x;
				tempCenterY += triangleSquare*triangleCenter._y;
				//
				this._square += triangleSquare;
			}
			//
			tempCenterX /= this._square;
			tempCenterY /= this._square;
			this._centerWeight = new FPGPoint2d(tempCenterX, tempCenterY);
		}
		
		private function setEdgesName(baseName:String):void
		{
			var i:int;
			var count:int = this._edges.length;
			var edge:FPGEdge2d;
			for (i=0; i<count; i++) {
				edge = this._edges[i];
				edge.name = baseName+'.e'+i;
			}
		}
		private function setVertexesName(baseName:String):void
		{
			var i:int;
			var count:int = this._vertexes.length;
			var vertex:FPGVertex2d;
			for (i=0; i<count; i++) {
				vertex = this._vertexes[i];
                vertex.name = baseName + '.v' + i;
            }
		}
		public override function set name(value:String):void
		{
			var _name:String = value;
			var index:int = _name.indexOf('{e}');
			var nameToEdge:Boolean;
			var nameToVertexes:Boolean; 
			if (index != -1) {
				_name = _name.slice(0, index)+_name.slice(index+3, _name.length);
				nameToEdge = true;
			}
			index = _name.indexOf('{v}');
			if (index != -1) {
				_name = _name.slice(0, index)+_name.slice(index+3, _name.length);
				nameToVertexes = true;
			}
			if (nameToEdge) {
				setEdgesName(_name);
			}
			if (nameToVertexes) {
				setVertexesName(_name);
			}
			super.name = _name;
		}
		
		
		
		/**
		 * Вершины были изменены
		 * @private
		 */		
		protected override function changeEvent(tt:int):void
		{
			this._centerWeight = null;
			_centerPoints = null;
			if (tt == 1 || tt == 3) {
				this._square = -1;
			}
			if (tt == 1) {
				this._isConvex = null;
				_isSelfCrossing = null;
			}
			this._bounds.cleared = true;
			//
			super.changeEvent(tt);
		}
		
		/**
		 * Применить матрицу преобразования ко всем вершинам полигона
		 * @param matrix
		 */
		geometry2d override function applyMatrix(matrix:Matrix):void
		{
			var vc:int = this._vertexes.length;
			// флаг запрещающий
			// отправку событий об изменении точек/точки 
			super.lockChangeEvent = true;
			// применяем матрицу ко всем вершинам
			for (i=0; i<vc; i++) {
				vx = this._vertexes[i];
				vx.transform(matrix);
			}
			// убиваем флаг
			super.lockChangeEvent = false;
		}
		
		/**
		 * @private
		 */
		geometry2d function reinit(points:Vector.<FPGPoint2d>):void
		{
			var i:int;
			// увибаем все события с существующих ребер
			var edge:FPGEdge2d;
			var vertex:FPGVertex2d;
			var vc:int;
			if (_vertexes != null) {
				vc = this._vertexes.length;
				for (i=0; i<vc; i++) {
					vertex = this._vertexes[i];
					super.deleteChild(vertex);
				}
			}
			//
			this._vertexes = new Vector.<FPGVertex2d>();
			this._vertexes.length = points.length;
			this._vertexes.fixed = true;
			//
			this._edges = new Vector.<FPGEdge2d>();
			this._edges.length = points.length;
			this._edges.fixed = true;
			//
			var point:FPGPoint2d = points[0];
			//
			var prevEdge:FPGEdge2d;
			var prevVertex:FPGVertex2d;
			var pc:int = points.length;
			for (i=0; i<pc; i++) {
				point = points[i];
				vertex = new FPGVertex2d(i, point._x, point._y);
				super.registerChild(vertex, -2);
				this._vertexes[i] = vertex;
				//
				if (prevVertex) {
					edge = new FPGEdge2d(i-1, prevVertex, vertex);
					//registerChild(edge);
					this._edges[i-1] = edge;
					prevVertex._rightEdge = edge;
					vertex._leftEdge = edge;
				}
				//
				prevVertex = vertex;
				prevEdge = edge;
			}
			//
			edge = new FPGEdge2d(i-1, prevVertex, this._vertexes[0]);
			//registerChild(edge);
			prevVertex._rightEdge = edge;
			this._edges[_edges.length-1] = edge;
			this._vertexes[0]._leftEdge = edge;
		}
		
		// public methods ************************************************
		
		/**
		 * Массив вершин полигона.
		 */
		public function get vertexes():Vector.<FPGVertex2d> {return this._vertexes.slice(0, this._vertexes.length);}
		
		/**
		 * Массив ребер полигона
		 */
		public function get edges():Vector.<FPGEdge2d> {return this._edges.slice(0, this._edges.length);}
		
		
		private var vx:FPGVertex2d;
		private var minX:Number;
		private var minY:Number;
		private var maxX:Number;
		private var maxY:Number;
		/**
		 * Ограничивающий прямоугольник
		 */
		final public function get bounds():FPGBounds
		{
			if (!this._bounds.cleared) {
				return this._bounds;
			}
			//
			// вычисляем ограничивающий прямоугольник
			this.vx = this._vertexes[0];
			this.minX = this.vx._x;
			this.minY = this.vx._y;
			this.maxX = this.vx._x;
			this.maxY = this.vx._y;
			const vc:int = this._vertexes.length;
			var i:int;
			for (i=1; i<vc; i++) {
				this.vx = this._vertexes[i];
				this.minX = this.minX < this.vx._x ? this.minX : this.vx._x;
				this.minY = this.minY < this.vx._y ? this.minY : this.vx._y;
				this.maxX = this.maxX > this.vx._x ? this.maxX : this.vx._x;
				this.maxY = this.maxY > this.vx._y ? this.maxY : this.vx._y;
			}
			this._bounds._x = this.minX;
			this._bounds._y = this.minY;
			this._bounds._width = this.maxX-this.minX;
			this._bounds._height = this.maxY-this.minY;
			this._bounds.cleared = false;
			return this._bounds;
		}
		
		/**
		 * @private
		 */
		public override function rotation(angle:Number, point:FPGPoint2d=null):void
		{
			if (point == null) {
				point = this.centerWeight;
			}
			super.rotation(angle, point);
		}
		
		/**
		 * @private
		 */
		public override function skew(sx:Number, sy:Number, point:FPGPoint2d=null):void
		{
			if (point == null) {
				point = this.centerWeight;
			}
			super.skew(sx, sy, point);
		}
		
		/**
		 * @private
		 */
		public override function scale(sx:Number, sy:Number, point:FPGPoint2d=null):void
		{
			if (point == null) {
				point = this.centerWeight;
			}
			super.scale(sx, sy, point);
		}
		
		/**
		 * Обновить точки полигона
		 */		
		public function update(points:Vector.<FPGPoint2d>):void
		{
			this.reinit(points);
			this.dispatchChange(1);
		}
		
		/**
		 * Площадь полигона
		 */
		final public function get square():Number
		{
			if (this._square == -1) {
				this.getSquare();
			}
			return this._square;
		}
		
		/**
		 * Центр-масс полигона
		 */
		final public function get centerWeight():FPGPoint2d
		{
			if (this._square == -1 || !_centerWeight) {
				this.getSquare();
			}
			return this._centerWeight.clone();
		}
		
		/**
		 * Центр системы точек, т.е. среднее арифметическое координат всех точек
		 */
		final public function get centerPoints():FPGPoint2d
		{
			if (!this._centerPoints) {
				var i:uint = this._vertexes.length;
				var point:FPGPoint2d;
				var sumX:Number = 0;
				var sumY:Number = 0;
				while (i) {
					point = this._vertexes[i-1];
					sumX += point._x;
					sumY += point._y;
					i--;
				}
				this._centerPoints = new FPGPoint2d(sumX/this._vertexes.length,
													sumY/this._vertexes.length);
			}
			return this._centerPoints.clone();
		}
		
		
		
		/**
		 * Проверить полигон на выпуклость
		 * @param poly
		 */
		final public function isConvex():Boolean
		{
			if (this._isConvex != null) return this._isConvex as Boolean;
			use namespace geomTestFunctions;
			//
			var n:int = this._vertexes.length;
			var c:Number = FPGPoint2dMath._testNf2(this._vertexes[n-1], this._vertexes[0], this._vertexes[1]);
			var s:Number;
			var res:Number;
			var i:int;
			var end:FPGVertex2d;
			for (i=1; i<n; i++) {
				end = i <n-1 ? this._vertexes[i+1] : end = this._vertexes[0];
				s = FPGPoint2dMath._testNf2(this._vertexes[i-1], this._vertexes[i], end);
				res = c*s;
				if (res < 0) {
					this._isConvex = false;
					return this._isConvex;
				}
			}
			this._isConvex = true;
			return this._isConvex;
		}
		
		/**
		 * Является ли полигон самопересекающимся.
		 * Метод работает медленно, т.к. проверяет пересечения двух не граниных ребер(отрезков)
		 */
		final public function isSelfCrossing():Boolean
		{
			if (this._isSelfCrossing != null) return this._isSelfCrossing as Boolean;
			//
			var count:int = this._edges.length;
			var count1:int = count;
			var efge:FPGEdge2d;
			var i:int;
			var j:int;
			var j1:int;
			var j2:int;
			for (i=0; i<count1; i++) {
				if (i == 0) {
					j1 = 2;
					j2 = count-2;
				} else {
					j1 = i+2;
					j2 = count-1;
				}
				for (j=j1; j<=j2; j++) {
					if (FPGLineToLine2dMath.isCrossPiece(this._edges[i], this._edges[j])) {
						this._isSelfCrossing = true;
						return this._isSelfCrossing;
					}
				}
			}
			//
			this._isSelfCrossing = false;
			return this._isSelfCrossing;
		}
		
		
		/**
		 * Сумма всех внутренних углов полигона, при условии что полигон не является самопересекающимся.
		 * Если полигон является самопересекающимся, то определить сумму углов можно с помощью метода FPGPolygon2d.sumAnglesSC .
		 * Метод FPGPolygon2d.sumAngles работает быстрее в разы чем FPGPolygon2d.sumAnglesSC .
		 * Является ли полигон самопересекающимся можно определить с помощью свойства FPGPolygon2d.isSelfCrossing,
		 * будьте осторожны с применением этого метода, т.к. он работает очень медленно.
		 * @see ru.flashpress.geom.polygon.FPGPolygon2d#isSelfCrossing
		 */
		public function get sumAngles():Number
		{
			var a:Number = Math.PI*2/this._vertexes.length;
			return this._vertexes.length*(Math.PI-a);
		}
		
		/**
		 * Сумма всех внутренних углов произвольного полигона, в том числе и самопересекающегося.
		 * Если полиогн не является самопересекающимся, то лучше использовать свойство FPGPolygon2d.sumAngles, т.к. оно работает быстрее в разы.
		 * Является ли полигон самопересекающимся можно определить с помощью свойства FPGPolygon2d.isSelfCrossing,
		 * будьте осторожны с применением этого метода, т.к. он работает очень медленно.
		 * @see ru.flashpress.geom.polygon.FPGPolygon2d#sumAngles
		 * @see ru.flashpress.geom.polygon.FPGPolygon2d#isSelfCrossing
		 */
		public function get sumAnglesSC():Number
		{
			//
			var sum:Number = 0;
			var i:uint;
			var count:uint = this._vertexes.length;
			var angle:Number;
			var next:int;
			var prev:int;
			for (i=0; i<count; i++) {
				next = i+1;
				if (next > count-1) next = 0;
				prev = i-1;
				if (prev < 0) prev = count-1;
				angle = FPGPoint2dMath.angleToLines(this._vertexes[i], this._vertexes[next],
													this._vertexes[i], this._vertexes[prev]
													);
				sum += angle;
			}
			return sum;
		}
		
		private var i:int;
		/**
		 * Получить клона полигона
		 */
		public function clone():FPGPolygon2d
		{
			var clonePoints:Vector.<FPGPoint2d> = new Vector.<FPGPoint2d>();
			const vc:int = this._vertexes.length;
			for (i=0; i<vc; i++) {
				clonePoints.push(this._vertexes[i].clone());
			}
			return new FPGPolygon2d(clonePoints);
		}
	}
}