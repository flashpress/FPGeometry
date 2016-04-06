package ru.flashpress.geom.curve.parabola
{
	import flash.geom.Matrix;
	
	import ru.flashpress.geom.FPGElement2d;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;
	
	/**
	 * 
	 * @author sam
	 * @private
	 */
	public class FPCurveParabola extends FPGElement2d
	{
		use namespace geometry2d;
		public function FPCurveParabola(a:Number=NaN, b:Number=NaN, c:Number=NaN)
		{
			super();
			if (!isNaN(a) && !isNaN(b) && !isNaN(c)) {
				update(a, b, c);
			}
		}
		
		private var p1:FPGPoint2d = new FPGPoint2d();
		private var p2:FPGPoint2d = new FPGPoint2d();
		private var p3:FPGPoint2d = new FPGPoint2d();
		private function reinit():void
		{
			p1.x = 0;
			p1.y = this._a*this.p1._x*this.p1._x + this._b*this.p1._x + this.c;
			//
			p2.x = 1;
			p2.y = this._a*this.p2._x*this.p2._x + this._b*this.p2._x + this.c;
			//
			p3.x = -1;
			p3.y = this._a*this.p3._x*this.p3._x + this._b*this.p3._x + this.c;
		}
		
		private function getAbc():void
		{
			var x1:Number = p1._x;
			var y1:Number = p1._y;
			var x2:Number = p2._x;
			var y2:Number = p2._y;
			var x3:Number = p3._x;
			var y3:Number = p3._y;
			this._a = (y3 - (x3*(y2-y1) + x2*y1-x1*y2)/(x2-x1)) / (x3*(x3-x1-x2) + x1*x2);
			this._b = (y2-y1)/(x2-x1) - _a *(x1+x2);
			this._c = (x2*y1 - x1*y2)/(x2-x1) + _a*x1*x2;
		}
		
		geometry2d var _a:Number;
		public function get a():Number {return this._a;}
		public function set a(value:Number):void
		{
			this._a = value;
			this.reinit();
		}
		
		geometry2d var _b:Number;
		public function get b():Number {return this._b;}
		public function set b(value:Number):void
		{
			this._b = value;
			this.reinit();
		}
		
		geometry2d var _c:Number;
		public function get c():Number {return this._c;}
		public function set c(value:Number):void
		{
			this._c = value;
			this.reinit();
		}
		
		private var _apex:FPGPoint2d;
		public function get apex():FPGPoint2d
		{
			if (_apex) return _apex;
			_apex = new FPGPoint2d(-_b/(2*_a), -_b*_b/(4*_a) + c);
			return _apex;
		}
		
		private var _focus:FPGPoint2d;
		public function get focus():FPGPoint2d
		{
			if (_focus) return _focus;
			_focus = new FPGPoint2d(apex.x, apex.y + 1/(4*_a));
			return _focus;
		}
		
		public function update(a:Number, b:Number, c:Number):void
		{
			this._a = a;
			this._b = b;
			this._c = c;
			this.reinit();
		}

public override function transform(matrix:Matrix):void {
        }
        public override function get matrix():Matrix {return null;}
        public override function set matrix(value:Matrix):void {
        }
        public override function translate(tx:Number, ty:Number):void
		{
			this.p1.translate(tx, ty);
			this.p2.translate(tx, ty);
			this.p3.translate(tx, ty);
			getAbc();
		}
		
		public override function scale(sx:Number, sy:Number, point:FPGPoint2d=null):void
		{
			this.p1.scale(sx, sy, point);
			this.p2.scale(sx, sy, point);
			this.p3.scale(sx, sy, point);
			getAbc();
		}
		
		public override function rotation(angle:Number, point:FPGPoint2d=null):void
		{
			this.p1.rotation(angle, point);
			this.p2.rotation(angle, point);
			this.p3.rotation(angle, point);
			getAbc();
		}
	}
}