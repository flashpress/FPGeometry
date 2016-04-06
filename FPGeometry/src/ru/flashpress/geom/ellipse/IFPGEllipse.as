package ru.flashpress.geom.ellipse
{
	import flash.events.IEventDispatcher;
	
	import ru.flashpress.geom.point.FPGPoint2d;
	
	/**
	 * Интерфейс реализующий методы эллипса 
	 */
	public interface IFPGEllipse extends IEventDispatcher
	{
		/**
		 * Центр эллипса
		 */
		function get center():FPGPoint2d;
		function set center(value:FPGPoint2d):void;
		
		/**
		 * @private
		 */
		function get width():Number;
		/**
		 * @private
		 */
		function get height():Number;
		
		/**
		 * Получить координаты точки по времени 
		 * @param time Время от 0 до 1
		 */		
		function pointFromTime(time:Number):FPGPoint2d;
		
		/**
		 * Проверить лежит ли точка на окружности
		 */
		function pointContains(p:FPGPoint2d):Boolean;
	}
}