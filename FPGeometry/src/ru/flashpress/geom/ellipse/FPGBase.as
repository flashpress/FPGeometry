package ru.flashpress.geom.ellipse
{
	import ru.flashpress.geom.FPGElement2d;
	import ru.flashpress.geom.core.constants.FPGeom2dMath;
	import ru.flashpress.geom.core.constants.TransformTypes;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;
	
	/**
	 * @private
	 */
	internal class FPGBase extends FPGElement2d implements IFPGEllipse
	{
		use namespace geometry2d;
		//
		protected var _a:Number;
		protected var _a2:Number;
		protected var _b:Number;
		protected var _b2:Number;
		geometry2d var _center:FPGPoint2d;
		public function FPGBase(center:FPGPoint2d, a:Number, b:Number)
		{
			super();
			//
			reinit(center, a, b);
			changeEvent(TransformTypes.FREEDOM);
		}
		
		protected function reinit(center:FPGPoint2d, a:Number, b:Number):void
		{
			this._center = center.clone();
			this._a = a;
			this._a2 = a*a;
			this._b = b;
			this._b2 = b*b;
		}
		
		public function get center():FPGPoint2d {return this._center;}
		public function set center(value:FPGPoint2d):void
		{
			super.deleteChild(this._center);
			this._center = value;
			super.registerChild(this._center);
			//
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		/**
		 * @private
		 */
		public function get width():Number {return _a*2;}
		/**
		 * @private
		 */
		public function get height():Number {return _b*2;}
		
		/**
		 * Получить координаты точки по времени 
		 * @param time Время от 0 до 1
		 * @private
		 */
		public function pointFromTime(time:Number):FPGPoint2d
		{
			var angle:Number = 2*Math.PI*time;
			var xt:Number = this._center._x + this._a*Math.cos(angle);
			var yt:Number = this._center._y + this._b*Math.sin(angle);
			var res:FPGPoint2d = new FPGPoint2d(xt, yt);
			res.transform(_matrix);
			return res;
		}
		
		/**
		 * Принадлежит ли точка эллипсу
		 * @private
		 */		
		public function pointContains(point:FPGPoint2d):Boolean
		{
			var dx:Number = point._x-this._center._x;
			var dy:Number = point._y-this._center._y;
			var res:Number = dx*dx/this._a2 + dy*dy/this._b2;
			return Math.abs(res-1) < FPGeom2dMath.EXACTITUDE;
		}
	}
}