package ru.flashpress.geom.curve.besier
{
	import ru.flashpress.geom.FPGElement2d;
	import ru.flashpress.geom.core.constants.TransformTypes;
	import ru.flashpress.geom.core.interfaces.IParametricEquation;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;
	
	/**
	 * @private
	 */
	public class FPGCurveBesier extends FPGElement2d implements IParametricEquation
	{
		use namespace geometry2d;
		//
		geometry2d var _p1:FPGPoint2d;
		geometry2d var _p2:FPGPoint2d;
		geometry2d var _p3:FPGPoint2d;
		geometry2d var _p4:FPGPoint2d;
		geometry2d var _points:Vector.<FPGPoint2d>;
		public function FPGCurveBesier(p1:FPGPoint2d=null, p2:FPGPoint2d=null, p3:FPGPoint2d=null, p4:FPGPoint2d=null)
		{
			super();
			this.reinit(p1, p2, p3, p4);
		}
		
		private function reinit(p1:FPGPoint2d, p2:FPGPoint2d, p3:FPGPoint2d, p4:FPGPoint2d):void
		{
			super.deleteChild(this._p1);
			this._p1 = p1;
			super.registerChild(this._p1);
			//
			super.deleteChild(this._p2);
			this._p2 = p2;
			super.registerChild(this._p2);
			//
			super.deleteChild(this._p3);
			this._p3 = p3;
			super.registerChild(this._p3);
			//
			super.deleteChild(this._p4);
			this._p4 = p4;
			super.registerChild(this._p4);
			//
			this._points = new <FPGPoint2d>[this._p1, this._p2, this._p3, this._p4];
		}
		
		public function get p1():FPGPoint2d {return this._p1;}
		public function set p1(value:FPGPoint2d):void
		{
			super.deleteChild(this._p1);
			this._p1 = value;
			super.registerChild(this._p1);
			//
			this._points[0] = this._p1;
			//
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		public function get p2():FPGPoint2d {return this._p2;}
		public function set p2(value:FPGPoint2d):void
		{
			super.deleteChild(this._p2);
			this._p2 = value;
			super.registerChild(this._p2);
			//
			this._points[1] = this._p2;
			//
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		public function get p3():FPGPoint2d {return this._p3;}
		public function set p3(value:FPGPoint2d):void
		{
			super.deleteChild(this._p3);
			this._p3 = value;
			super.registerChild(this._p3);
			//
			this._points[2] = this._p3;
			//
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		public function get p4():FPGPoint2d {return this._p4;}
		public function set p4(value:FPGPoint2d):void
		{
			super.deleteChild(this._p4);
			this._p4 = value;
			super.registerChild(this._p4);
			//
			this._points[3] = this._p4;
			//
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		public function update(p1:FPGPoint2d, p2:FPGPoint2d, p3:FPGPoint2d, p4:FPGPoint2d):void
		{
			reinit(p1, p2, p3, p4);
			//
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		public function pointFromTime(t:Number):FPGPoint2d
		{
			var t1:Number = 1-t;
			var x:Number = t1*t1*t1*_p1._x + 3*t*t1*t1*_p2._x + 3*t*t*t1*_p3._x + t*t*t*_p4._x;
			var y:Number = t1*t1*t1*_p1._y + 3*t*t1*t1*_p2._y + 3*t*t*t1*_p3._y + t*t*t*_p4._y;
			return new FPGPoint2d(x, y);
		}
	}
}