package ru.flashpress.geom
{
	import flash.geom.Matrix;
	
	import ru.flashpress.callback.FPCaller;
	import ru.flashpress.geom.core.constants.TransformTypes;
	import ru.flashpress.geom.core.matrix.matrixIsDefault;
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;

	/**
	 * Базовый класс для всех геометрических элементов
	 * @author Serious Sam
	 */
	public class FPGElement2d extends FPCaller
	{
		public static const CHANGE:String = 'geomChange';
		//
		//
		//
		use namespace geometry2d;
		//
		private var _name:String;
		public function FPGElement2d()
		{
			super();
		}

        /**
         * @private
         */
        protected var lockChangeEvent:Boolean;
		/**
		 * @private
		 */		
		protected override function callback(chanel:String, data:Object, caller:*, fcaller:*):int
		{
            var oldDrop:Boolean = this.lockChangeEvent;
            this.lockChangeEvent = true;
            this.changeEvent(data as int);
            this.lockChangeEvent = oldDrop;
            //
            if (lockChangeEvent) {
                return FPCaller.STOP_PROPOGATION;
            }
            //
            return super.callback(chanel, data, caller, fcaller);
		}

		/**
		 * Был изменен сам элемент
		 * или один из его дочерних
		 * @private
		 */
		protected function dispatchChange(tt:int, bubble:Boolean=true):void
		{
            super.dispatchCallback(CHANGE, tt, bubble);
		}
        protected function changeEvent(tt:int):void
        {

        }
		
		/**
		 * Зарегистрировать дочерний элемент для того что бы слушать события изменения.
		 * Приоритет здесь необходим для того, что бы при изменении координат точки,
		 * ребро(FPGEdge2d) получало событие раньше чем полигон(FPGPolygon2d)
		 * @param child
		 * @param priority Приоритет события
		 * @private
		 */
		final protected function registerChild(child:FPGElement2d, priority:int=0):void
		{
			child.registerTarget(CHANGE, this, priority);
		}
		
		/**
		 * Убить слушателя события
		 * @param child
		 * @private
		 */
		final protected function deleteChild(child:FPGElement2d):void
		{
			if (child != null) {
				child.deleteForTarget(this);
			}
		}

		geometry2d function applyMatrix(matrix:Matrix):void {}
        geometry2d var _matrix:Matrix = new Matrix();
		private var isChangeMatrix:Boolean;
		
		/**
		 * Имя элемента.
		 */
		public function get name():String {return _name;}
		public function set name(value:String):void
		{
			this._name = value;
		}
		
		/**
		 * Текущая матрица преобразования элемента.
		 * Если присвоить матрицу, то действие предыдущих преобразований анулируется,
		 * и применяется новая трансформация.
		 */
		public function get matrix():Matrix {return this._matrix.clone();}
		public function set matrix(value:Matrix):void
		{
			if (matrixIsDefault(value)) return;
			var _applyMatrix:Matrix;
			if (isChangeMatrix) {
				this._matrix.invert();
				_applyMatrix = new Matrix();
				_applyMatrix.concat(this._matrix);
				_applyMatrix.concat(value);
			} else {
				_applyMatrix = value;
			}
			isChangeMatrix = true;
			this._matrix = value.clone();
			this.applyMatrix(_applyMatrix);
			this.dispatchChange(TransformTypes.FREEDOM);
		}
		
		/**
		 * Удалить трансформацию, и вернуть элемент в исходное состояние.
		 */
		public function removeTransform():void
		{
			if (this.isChangeMatrix) {
				this.isChangeMatrix = false;
				var invert:Matrix = this._matrix.clone();
				invert.invert();
				var restore:Matrix = new Matrix();
				restore.concat(invert);
				//
				this._matrix = new Matrix();
				this.applyMatrix(restore);
				this.dispatchChange(TransformTypes.FREEDOM);
			}
		}
		
		/**
		 * Применить к элементу произвольную трансформацию. Данная матрица контактируется с текущей матрицей преобразования.
		 * @param matrix Матрица преобразования.
		 */
		public function transform(matrix:Matrix):void
		{
			this.isChangeMatrix = true;
			this._matrix.concat(matrix);
			this.applyMatrix(matrix);
			this.dispatchChange(TransformTypes.FREEDOM);
		}

		/**
		 * Применить к элементу трансформацию смещения
		 * @param tx Смещение по X
		 * @param ty Смещение по Y
		 */
		public function translate(tx:Number, ty:Number):void
		{
			this.isChangeMatrix = true;
			this._matrix.translate(tx, ty);
			this.applyMatrix(new Matrix(1, 0, 0, 1, tx, ty));
			this.dispatchChange(TransformTypes.TRANSLATE);
		}
		
		/**
		 * Применить к элементу трансформацию сжатия/растяжения
		 * @param sx Сжатие по X
		 * @param sy Сжатие по Y
		 * @param point Точка относительно который происходит поворот.
		 * Если параметр не задан, происходит поворот относительно геометрического центра объета.
		 * <b>ВНИМАНИЕ!</b> Если вы попытаетесь повернуть полигон без использования параметра point,
		 * то для определения геометрического центра, будут использованы тригометреские функции, которые могут привести к падению производительности.
		 */
		public function scale(sx:Number, sy:Number, point:FPGPoint2d=null):void
		{
			this.isChangeMatrix = true;
			var matrix:Matrix = new Matrix();
			if (point != null) {
				matrix.translate(-point._x, -point._y);
				this._matrix.translate(-point._x, -point._y);
			}
			matrix.concat(new Matrix(sx, 0, 0, sy));
			this._matrix.scale(sx, sy);
			if (point != null) {
				matrix.translate(point._x, point._y);
				this._matrix.translate(point._x, point._y);
			}
			this.applyMatrix(matrix);
			this.dispatchChange(TransformTypes.SCALE);
		}
		
		/**
		 * Применить к элементу трансформацию поворота.
		 * @param angle Угол поворота в радианах
		 * @param point Точка относительно который происходит поворот.
		 * Если параметр не задан, происходит поворот относительно геометрического центра объета.
		 * <b>ВНИМАНИЕ!</b> Если вы попытаетесь повернуть полигон без использования параметра point,
		 * то для определения геометрического центра, будут использованы тригометреские функции, которые могут привести к падению производительности.
		 * 
		 */
		public function rotation(angle:Number, point:FPGPoint2d=null):void
		{
			this.isChangeMatrix = true;
			var matrix:Matrix = new Matrix();
			if (point != null) {
				matrix.translate(-point._x, -point._y);
				this._matrix.translate(-point._x, -point._y);
			}
			matrix.rotate(angle);
			this._matrix.rotate(angle);
			if (point != null) {
				matrix.translate(point._x, point._y);
				this._matrix.translate(point._x, point._y);
			}
			this.applyMatrix(matrix);
			this.dispatchChange(TransformTypes.ROTATION);
		}
		
		/**
		 * Применить к элементу трансформацию искажения. 
		 * @param sx Искажение по X
		 * @param sy Искажение по Y
		 * @param point Точка относительно который происходит искажение.
		 * Если параметр не задан, искажение происходит  относительно геометрического центра объета.
		 * <b>ВНИМАНИЕ!</b> Если вы попытаетесь повернуть полигон без использования параметра point,
		 * то для определения геометрического центра, будут использованы тригометреские функции, которые могут привести к падению производительности.
		 */
		public function skew(sx:Number, sy:Number, point:FPGPoint2d=null):void
		{
			this.isChangeMatrix = true;
			var resMatrix:Matrix = new Matrix();
			if (point != null) {
				resMatrix.translate(-point._x, -point._y);
				this._matrix.translate(-point._x, -point._y);
			}
			var matrx:Matrix = new Matrix(1, sy, sx);
			resMatrix.concat(matrx);
			this._matrix.concat(matrx);
			//
			if (point != null) {
				resMatrix.translate(point._x, point._y);
				this._matrix.translate(point._x, point._y);
			}
			//
			this.applyMatrix(resMatrix);
			this.dispatchChange(TransformTypes.SKEW);
		}
	}
}