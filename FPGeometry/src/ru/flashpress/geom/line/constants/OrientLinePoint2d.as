package ru.flashpress.geom.line.constants
{
	/**
	 * Константы показывающие где находится точка относительно прямой линии
	 * @author Serious Sam
	 */
	public class OrientLinePoint2d
	{
		
		/**
		 * Точка лежит НАД линией
		 */
		public static const ABOVE_LINE:String = 'aboveLine';
		
		/**
		 * Точка лежит ПОД линией (в том направлении куда смотрит нормаль)
		 */
		public static const UNDER_LINE:String = 'underLine';
		
		/**
		 * Точка лежит внутри отрезка
		 */
		public static const INPIECE:String = 'inpiece';
		
		/**
		 * Точка лежит на линии ВНЕ отрезка
		 */
		public static const INLINE:String = 'inline';
		
		/**
		 * Точка лежит на левой точке линии
		 */
		public static const BELONGS_LEFT:String = 'belongsLeft';
		
		/**
		 * Точка лежит на правой точке линии
		 */
		public static const BELONGS_RIGHT:String = 'belongsRight';
	}
}