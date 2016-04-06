package ru.flashpress.geom.core.matrix
{
	import flash.geom.Matrix;

	/**
	 * @private
	 */
	public function matrixIsDefault(matrix:Matrix):Boolean
	{
		if (matrix.a == 1 && matrix.b == 0 && matrix.c == 0 && matrix.d == 1 && matrix.tx == 0 && matrix.ty == 0) {
			return true;
		}
		return false;
	}
}