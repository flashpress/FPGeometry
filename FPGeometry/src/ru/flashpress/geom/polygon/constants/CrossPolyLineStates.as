package ru.flashpress.geom.polygon.constants
{
	/**
	 * Пересечение бесконечной прямой и полигона
	 * Возвращает результаты выполнения метода FPGPolygon2dMath.CrossLineState
	 * @author Serious Sam
	 * http://flashpress.ru
	 */
	public class CrossPolyLineStates
	{
		/**
		 * Пересекает
		 */
		public static const CROSS:int = 1;
		
		/**
		 * Касается
		 */
		public static const INEDGE:int = 0;
		
		/**
		 * Не пересекает
		 */
		public static const NOCROSS:int = -1;
	}
}