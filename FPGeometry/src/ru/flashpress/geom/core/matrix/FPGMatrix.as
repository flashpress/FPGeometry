package ru.flashpress.geom.core.matrix
{
	
	import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.point.FPGPoint2d;

	/**
	 * Матрица произвольной размерности
	 * @author Serious Sam
	 * @private
	 */
	public class FPGMatrix
	{
		use namespace geometry2d;
		//
		private var _values:Vector.<Vector.<Number>>;
		private var _sizeM:uint;
		private var _sizeN:uint;
		
		public function FPGMatrix(arr:Vector.<Vector.<Number>>) {
			_values = arr;
			_sizeM = _values.length;
			_sizeN = _values[0].length;
		}
		public function get sizeM():uint {return _sizeM;}
		public function get sizeN():uint {return _sizeN;}
		
		public function get values():Vector.<Vector.<Number>> {return _values;}
		
		/**
		 * Получить копию матрицы
		 */
		public function clone():FPGMatrix {
			var i:uint;
			var j:uint;
			var arr:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
			for (i=0; i<_values.length; i++) {
				arr[i] = new Vector.<Number>();
				for (j=0; j<_values[i].length; j++) {
					arr[i].push(_values[i][j])
				}
			}
			return new FPGMatrix(arr);
		}
		
		public function toString():String {
			var str:String = '**** Matrix2d ****\r';
			var i:uint;
			var j:uint;
			var k:uint;
			var sum:String;
			for (i=0; i<_sizeM; i++) {
				sum = '';
				for (j=0; j<_sizeN; j++) {
					if (sum != '') {
						sum += ', '
					}
					sum += _values[i][j]
				}
				str += sum+'\r';
			}
			str += '***********\r';
			return str;
		}
		
		/**
		 * Транспонированная матрица
		 */
		public function transponition():FPGMatrix
		{
			var arr:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
			var i:uint;
			var j:uint;
			arr.length = _sizeN;
			for (i=0; i<_sizeN; i++) {
				arr[i] = new Vector.<Number>();
				for (j=0; j<_sizeM; j++) {
					arr[i][j] = _values[j][i]
				}
			}
			return new FPGMatrix(arr)
		}
		
		
		/**
		 * сложение матриц
		 * @param matrix
		 * @param z
		 * @return 
		 */
		public function addition(matrix:FPGMatrix, z:Number=1):FPGMatrix
		{
			var new_arr:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
			if (_sizeN == matrix.sizeN && _sizeM == matrix.sizeM) {
				var target_arr:Vector.<Vector.<Number>> = matrix.values;
				var i:uint;
				var j:uint;
				new_arr.length = _sizeM;
				for (i=0; i<_sizeM; i++) {
					if (!new_arr[i]) {
						new_arr[i] = new Vector.<Number>();
					}
					for (j=0; j<_sizeN; j++) {
						new_arr[i][j] = _values[i][j] + z*target_arr[i][j];
					}
				}
				return new FPGMatrix(new_arr);
			} else {
				trace('ВНИМАНИЕ! сложение матриц не возможно!!!!!');
				return null;
			}
		}
		
		/**
		 * Умножение матрицы на число
		 * @param k
		 * @return
		 */
		public function resize(k:Number):FPGMatrix
		{
			var newValues:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
			var i:uint;
			var j:uint;
			newValues.length = _sizeM;
			for (i=0; i<_sizeM; i++) {
				if (!newValues[i]) {
					newValues[i] = new Vector.<Number>();
				}
				for (j=0; j<_sizeN; j++) {
					newValues[i][j] = _values[i][j]*k;
				}
			}
			return new FPGMatrix(newValues);
		}
		
		/**
		 * Произведение двух матриц
		 * @param matrix
		 * @return 
		 */
		public function multiplication(matrix:FPGMatrix):FPGMatrix
		{
			var newValues:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
			if (_sizeN == matrix.sizeM) {
				var target_arr:Vector.<Vector.<Number>> = matrix.values;
				var newM:uint = _sizeM;
				var newN:uint = matrix.sizeN;
				var newS:uint = _sizeN;
				//
				var i:uint;
				var j:uint;
				var k:uint;
				var element:Number;
				newValues.length = newM;
				for (i=0; i<newM; i++) {
					if (!newValues[i]) {
						newValues[i] = new Vector.<Number>();
					}
					for (j=0; j<newN; j++) {
						element = 0;
						for (k=0; k<newS; k++) {
							element += _values[i][k] * target_arr[k][j];
						}
						newValues[i][j] = element;
					}
				}
				return new FPGMatrix(newValues);
			} else {
				trace('ВНИМАНИЕ! умножение матриц не возможно!!!!!');
				return null;
			}
		}
		
		
		
		/**
		 * Вычислить модуль матрицы
		 * @return 
		 */		
		public function module():Number
		{
			return reversModule(_values);
		}
		private function reversModule(arr_revers:Vector.<Vector.<Number>>):Number
		{
			if (arr_revers.length == 1 && arr_revers[0].length == 1) {
				return arr_revers[0][0]
			}
			var res:Number = 0;
			var i:uint;
			var j:uint;
			var arr_top:Vector.<Number> = arr_revers[0];
			var z:Number = 1;
			var dop_matrix:FPGMatrix;
			for (i=0; i<arr_top.length; i++) {
				dop_matrix = dopMatrix(arr_revers, 0, i);
				res += z*arr_revers[0][i]*reversModule(dop_matrix.values);
				z *= -1;
			}
			return res
		}
		
		/**
		 * Дополнительная матрица
		 */
		public function dopMatrix(checkValues:Vector.<Vector.<Number>>, i:Number, j:Number):FPGMatrix
		{
			var arr:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
			var m:Number;
			var n:Number;
			for (m=0; m<checkValues.length; m++) {
				if (m != i) {
					var temp_arr:Vector.<Number> = new Vector.<Number>();
					for (n=0; n<checkValues[m].length; n++) {
						if (n != j) {
							temp_arr.push(checkValues[m][n]);
						}
					}
					arr.push(temp_arr);
				}
			}
			return new FPGMatrix(arr);
		}
		
		
		/**
		 * Преобразовать точку
		 * @param point
		 * @return 
		 */
		public function resetPoint(point:FPGPoint2d):FPGPoint2d
		{
			var arr:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
			var temp:Vector.<Number> = new Vector.<Number>();
			temp.push(point._x);
			arr.push(temp);
			temp = new Vector.<Number>();
			temp.push(point._y);
			arr.push(temp);
			temp = new Vector.<Number>();
			temp.push(1);
			arr.push(temp);
			
			var m:FPGMatrix = new FPGMatrix(arr);
			var m2:FPGMatrix = this.clone();
			var res_m:FPGMatrix = m2.multiplication(m);
			var arr_points:Vector.<Vector.<Number>> = res_m.values;
			return new FPGPoint2d(arr_points[0][0], arr_points[1][0]);
		}
	}
}