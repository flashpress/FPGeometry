package ru.flashpress.geom.polygon.constants
{
	/**
	 * Пересечение бесконечной прямой и полигона
	 * Возвращает результаты выполнения метода FPGPolygon2dMath.CrossLineState
	 * @author Serious Sam
	 * http://flashpress.ru
	 */
	public class PointInPolyStates
	{
		/**
		 * Точка внутри полигона
		 */
		public static const IN:int = 1;
		
		/**
		 * Точк лежит на ребре полигона
		 */
		public static const EDGE:int = 0;
		
		/**
		 * Точка вне полигона
		 */
		public static const OUT:int = -1;
	}
}