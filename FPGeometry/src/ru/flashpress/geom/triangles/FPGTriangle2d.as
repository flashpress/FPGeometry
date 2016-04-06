package ru.flashpress.geom.triangles
{
	import flash.geom.Matrix;
	
	import ru.flashpress.geom.FPGElement2d;
	import ru.flashpress.geom.core.constants.TransformTypes;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.line.FPGLine2d;
	import ru.flashpress.geom.line.FPGLine2dFactory;
	import ru.flashpress.geom.line.math.FPGLineToLine2dMath;
	import ru.flashpress.geom.line.math.FPGLineToPoint2dMath;
	import ru.flashpress.geom.point.FPGPoint2d;
	import ru.flashpress.geom.point.math.FPGPoint2dMath;
	import ru.flashpress.geom.polygon.FPGPolygon2d;

	/**
	 * Трегольник на плоскости
	 * @author Serious Sam
	 */
	public class FPGTriangle2d extends FPGElement2d
	{
		use namespace geometry2d;
		//
		geometry2d var _pointA:FPGPoint2d;
		geometry2d var _pointB:FPGPoint2d;
		geometry2d var _pointC:FPGPoint2d;
		//
		geometry2d var _square:Number = -1;
		geometry2d var _centroid:FPGPoint2d;
		geometry2d var _orthocentre:FPGPoint2d;
		geometry2d var _bisectorCenter:FPGPoint2d;
		//
		private var _sideAB:Number = -1;
		private var _sideBC:Number = -1;
		private var _sideCA:Number = -1;
		private var _angleA:Number = -1;
		private var _angleB:Number = -1;
		private var _angleC:Number = -1;
		//
		/**
		 * Конструктор
		 * @param a Первая точка трегольника
		 * @param b Вторая точка трегольника
		 * @param c Третья точка трегольника
		 * 
		 */
		public function FPGTriangle2d(p1:FPGPoint2d, p2:FPGPoint2d, p3:FPGPoint2d)
		{
			super();
			reinit(p1, p2, p3);
			//
			var cx:Number = (this._pointA.x+this._pointB.x+this._pointC.x)/3;
			var cy:Number = (this._pointA.y+this._pointB.y+this._pointC.y)/3;
			this._centroid = new FPGPoint2d(cx, cy);
		}
		
		private function reinit(p1:FPGPoint2d, p2:FPGPoint2d, p3:FPGPoint2d):void
		{
			super.deleteChild(this._pointA);
			this._pointA = p1;
			super.registerChild(this._pointA);
			//
			super.deleteChild(this._pointB);
			this._pointB = p2;
			super.registerChild(this._pointB);
			//
			super.deleteChild(this._pointC);
			this._pointC = p3;
			super.registerChild(this._pointC);
		}
		
		/**
		 * Применить матрицу преобразования ко всем вершинам полигона
		 * @param matrix
		 */
		geometry2d override function applyMatrix(matrix:Matrix):void
		{
			// флаг запрещающий
			// отправку событий об изменении точек/точки 
			super.lockChangeEvent = true;
			// применяем матрицу ко всем вершинам
			p1.transform(matrix);
			p2.transform(matrix);
			p3.transform(matrix);
			// убиваем флаг
			super.lockChangeEvent = false;
		}
		
		/**
		 * @private
		 */		
		protected override function changeEvent(tt:int):void
		{
			// TransformTypes.FREEDOM | TransformTypes.SCALE
			if (tt == 1 || tt == 3) {
				this._square = -1;
			}
			//
			var cx:Number = (this._pointA.x+this._pointB.x+this._pointC.x)/3;
			var cy:Number = (this._pointA.y+this._pointB.y+this._pointC.y)/3;
			this._centroid = new FPGPoint2d(cx, cy);
			//
			if (tt == 1 || tt == 3 || tt == 4) {
				_angleA = -1;
				_angleB = -1;
				_angleC = -1;
				_sideAB = -1;
				_sideBC = -1;
				_sideCA = -1;
			}
			//
			this._orthocentre = null;
			this._bisectorCenter = null;
			this._bisectorA = null;
			this._bisectorB = null;
			this._bisectorC = null;
			this._cHeightAB = null;
			this._cHeightBC = null;
			this._cHeightCA = null;
			//
			super.changeEvent(tt);
		}
		
		/**
		 * Первая точка трегольника
		 */
		public function get p1():FPGPoint2d {return this._pointA;}
		public function set p1(value:FPGPoint2d):void
		{
			super.deleteChild(this._pointA);
			this._pointA = value;
			super.registerChild(this._pointA);
			//
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		/**
		 * Вторая точка трегольника
		 */
		public function get p2():FPGPoint2d {return this._pointB;}
		public function set p2(value:FPGPoint2d):void
		{
			super.deleteChild(this._pointB);
			this._pointB = value;
			super.registerChild(this._pointB);
			//
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		/**
		 * Третья точка трегольника
		 */
		public function get p3():FPGPoint2d {return this._pointC;}
		public function set p3(value:FPGPoint2d):void
		{
			super.deleteChild(this._pointC);
			this._pointC = value;
			super.registerChild(this._pointC);
			//
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		/**
		 * Обновить координаты точек
		 * @param p1 Первая точка треугольника
		 * @param p2 Вторая точка треугольника
		 * @param p3 Третья точка треугольника
		 */
		public function update(p1:FPGPoint2d, p2:FPGPoint2d, p3:FPGPoint2d):void
		{
			reinit(p1, p2, p3);
			//
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		/**
		 * Площадь треугольника.
		 */
		public function get square():Number
		{
			if (_square != -1) return _square;
			//
			var dx1:Number = this._pointB._x-this._pointA._x;
			var dy1:Number = this._pointB._y-this._pointA._y;
			var a1:Number = Math.atan2(dy1, dx1);
			var m1:Number = Math.sqrt(dx1*dx1 + dy1*dy1);
			//
			var dx2:Number = this._pointC._x-this._pointA._x;
			var dy2:Number = this._pointC._y-this._pointA._y;
			var a2:Number = Math.atan2(dy2, dx2);
			var m2:Number = Math.sqrt(dx2*dx2 + dy2*dy2);
			//
			var angle:Number = Math.abs(a1-a2);
			_square =  m1*m2*Math.sin(angle)/2;
			return _square;
		}
		
		/**
		 * Длина стороны ab
		 */		
		public function get sideAB():Number
		{
			if (this._sideAB != -1) return this._sideAB;
			var dx:Number = this._pointA.x-this._pointB.x;
			var dy:Number = this._pointA.y-this._pointB.y;
			this._sideAB = Math.sqrt(dx*dx + dy*dy);
			return this._sideAB;
		}
		
		/**
		 * Длина стороны bc
		 */	
		public function get sideBC():Number
		{
			if (this._sideBC != -1) return this._sideBC;
			var dx:Number = this._pointB.x-this._pointC.x;
			var dy:Number = this._pointB.y-this._pointC.y;
			this._sideBC = Math.sqrt(dx*dx + dy*dy);
			return this._sideBC;
		}
		
		/**
		 * Длина стороны ca
		 */	
		public function get sideCA():Number
		{
			if (this._sideCA != -1) return this._sideCA;
			var dx:Number = this._pointC.x-this._pointA.x;
			var dy:Number = this._pointC.y-this._pointA.y;
			this._sideCA = Math.sqrt(dx*dx + dy*dy);
			return this._sideCA;
		}
		
		/**
		 * Угол в первой точке трегольника
		 */	
		public function get angleA():Number
		{
			if (this._angleA != -1) return this._angleA;
			this._angleA = FPGPoint2dMath.angleToLines(this._pointA, this._pointB, this._pointA, this._pointC);
			return this._angleA;
		}
		
		/**
		 * Угол во второй точке трегольника
		 */
		public function get angleB():Number
		{
			if (this._angleB != -1) return this._angleB;
			this._angleB = FPGPoint2dMath.angleToLines(this._pointB, this._pointC, this._pointB, this._pointA);
			return this._angleB;
		}
		
		/**
		 * Угол в третьей точке трегольника
		 */
		public function get angleC():Number
		{
			if (this._angleC != -1) return this._angleC;
			this._angleC = FPGPoint2dMath.angleToLines(this._pointC, this._pointA, this._pointC, this._pointB);
			return this._angleC;
		}
		
		/**
		 * Уравнение прямой проходящей через точки A и B
		 */
		public function get lineAB():FPGLine2d {return new FPGLine2d(this._pointA.clone(), this._pointB.clone());}
		/**
		 * Уравнение прямой проходящей через точки B и C
		 */
		public function get lineBC():FPGLine2d {return new FPGLine2d(this._pointB.clone(), this._pointC.clone());}
		/**
		 * Уравнение прямой проходящей через точки C и A
		 */
		public function get lineCA():FPGLine2d {return new FPGLine2d(this._pointC.clone(), this._pointA.clone());}
		
		/**
		 * Уравнение высоты опущенной из точки A на противоположную сторону
		 */
		public function get heightA():FPGLine2d  {return FPGLineToPoint2dMath.lineHeight(_pointA, lineBC);}
		/**
		 * Уравнение высоты опущенной из точки B на противоположную сторону
		 */
		public function get heightB():FPGLine2d  {return FPGLineToPoint2dMath.lineHeight(_pointB, lineCA);}
		/**
		 * Уравнение высоты опущенной из точки C на противоположную сторону
		 */
		public function get heightC():FPGLine2d  {return FPGLineToPoint2dMath.lineHeight(_pointC, lineAB);}
		
		private var _cHeightAB:FPGLine2d;
		/**
		 * Серединный перпендикуляр опущенный на сторону AB
		 */
		public function get cHeightAB():FPGLine2d
		{
			if (_cHeightAB) return _cHeightAB;
			//
			var x1:Number = p1._x+(p2._x-p1._x)*0.5;
			var y1:Number = p1._y+(p2._y-p1._y)*0.5;
			_cHeightAB = FPGLine2dFactory.incline(Math.PI/2, x1, y1, 150, lineAB);
			return _cHeightAB;
		}
		
		private var _cHeightBC:FPGLine2d;
		/**
		 * Серединный перпендикуляр опущенный на сторону BC
		 */
		public function get cHeightBC():FPGLine2d
		{
			if (_cHeightBC) return _cHeightBC;
			//
			var x1:Number = p2._x+(p3._x-p2._x)*0.5;
			var y1:Number = p2._y+(p3._y-p2._y)*0.5;
			_cHeightBC = FPGLine2dFactory.incline(Math.PI/2, x1, y1, 150, lineBC);
			return _cHeightBC;
		}
		
		private var _cHeightCA:FPGLine2d;
		/**
		 * Серединный перпендикуляр опущенный на сторону CA
		 */
		public function get cHeightCA():FPGLine2d
		{
			if (_cHeightCA) return _cHeightCA;
			//
			var x1:Number = p3._x+(p1._x-p3._x)*0.5;
			var y1:Number = p3._y+(p1._y-p3._y)*0.5;
			_cHeightCA = FPGLine2dFactory.incline(Math.PI/2, x1, y1, 150, lineCA);
			return _cHeightCA;
		}
			
		
		/**
		 * Уравнение медианы опущенной из точки A на противоположную сторону
		 */
		public function get medianA():FPGLine2d 
		{
			return new FPGLine2d(this._pointA.clone(), lineBC.pointFromTime(0.5));
		}
		/**
		 * Уравнение медианы опущенной из точки A на противоположную сторону
		 */
		public function get medianB():FPGLine2d 
		{
			return new FPGLine2d(this._pointB.clone(), lineCA.pointFromTime(0.5));
		}
		/**
		 * Уравнение медианы опущенной из точки A на противоположную сторону
		 */
		public function get medianC():FPGLine2d 
		{
			return new FPGLine2d(this._pointC.clone(), lineAB.pointFromTime(0.5));
		}
		
		private var _bisectorA:FPGLine2d;
		/**
		 * Биссектриса угла A
		 */
		public function get bisectorA():FPGLine2d
		{
			if (this._bisectorA == null) {
				_bisectorA = this.lineAB.clone();
				var a:Number = this.angleA/2;
				_bisectorA.rotation(a, this.p1);
			}
			return this._bisectorA;
		}
		
		private var _bisectorB:FPGLine2d;
		/**
		 * Биссектриса угла B
		 */
		public function get bisectorB():FPGLine2d
		{
			if (this._bisectorB == null) {
				_bisectorB = this.lineBC.clone();
				var a:Number = this.angleB/2;
				_bisectorB.rotation(a, this.p2);
			}
			return this._bisectorB;
		}
		
		private var _bisectorC:FPGLine2d;
		/**
		 * Биссектриса угла C
		 */
		public function get bisectorC():FPGLine2d
		{
			if (this._bisectorC == null) {
				_bisectorC = this.lineCA.clone();
				var a:Number = this.angleC/2;
				_bisectorC.rotation(a, this.p3);
			}
			return this._bisectorC;
		}
		
		/**
		 * Центроид - геометрический центр треугольника, точка пересечения медин треугольника.
		 */
		public function get centroid():FPGPoint2d {return this._centroid.clone();}
		
		/**
		 * Ортоцентр - точка пересечения высот треугольника
		 */
		public function get orthoCentre():FPGPoint2d
		{
			if (!this._orthocentre) {
				this._orthocentre = FPGLineToLine2dMath.crossLine(heightA, heightB);
			}
			return this._orthocentre.clone();
		}
		
		/**
		 * Точка пересечения биссектрис
		 */
		public function get inCentre():FPGPoint2d
		{
			if (!this._bisectorCenter) {
				this._bisectorCenter = FPGLineToLine2dMath.crossLine(bisectorA, bisectorB);
			}
			return this._bisectorCenter.clone();
		}
		
		/**
		 * Получить копию треугольника
		 */
		public function clone():FPGTriangle2d
		{
			return new FPGTriangle2d(this._pointA.clone(), this._pointB.clone(), this._pointC.clone());
		}
		
		
		/**
		 * @private
		 */
		public override function rotation(angle:Number, point:FPGPoint2d=null):void
		{
			if (point == null) {
				point = this.centroid;
			}
			super.rotation(angle, point);
		}
		
		/**
		 * @private
		 */
		public override function skew(sx:Number, sy:Number, point:FPGPoint2d=null):void
		{
			if (point == null) {
				point = this.centroid;
			}
			super.skew(sx, sy, point);
		}
		
		/**
		 * @private
		 */
		public override function scale(sx:Number, sy:Number, point:FPGPoint2d=null):void
		{
			if (point == null) {
				point = this.centroid;
			}
			super.scale(sx, sy, point);
		}
		
		
		/**
		 * Создать объект полигон на основе этого треугольника
		 * @param link Если задать значение true, то при изменении координат точек треугольника,
		 * будут менятьс координаты точек полигона, и наооборот
		 */
		public function toPolygon(link:Boolean=false):FPGPolygon2d
		{
			var points:Vector.<FPGPoint2d> = new Vector.<FPGPoint2d>();
			points.push(this._pointA);
			points.push(this._pointB);
			points.push(this._pointC);
			var poly:FPGPolygon2d = new FPGPolygon2d(points);
			if (link) {
				this.update(poly._vertexes[0], poly._vertexes[1], poly._vertexes[2]);
			}
			return poly;
		}
	}
}