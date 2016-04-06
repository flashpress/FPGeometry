package ru.flashpress.geom.polygon
{
	
	import ru.flashpress.geom.point.FPGPoint2d;

	/**
	 * Фабрика создания полигонов-примитивов
	 * @author Serious Sam
	 */
	public class FPGPolygon2dFactory
	{
		/**
		 * Создать полигон-прямоугольник
		 * @param x Координата левого верхнего угла по X
		 * @param y Координата левого верхнего угла по Y
		 * @param width Ширина прямоугольника
		 * @param height Высота прямоугольника
		 * @param name Назавние полигона
		 */
		public static function rectangle(x:Number, y:Number, width:Number, height:Number, name:String=null):FPGPolygon2d
		{
			var points:Vector.<FPGPoint2d> = new Vector.<FPGPoint2d>();
			points.push(new FPGPoint2d(x, y));
			points.push(new FPGPoint2d(x+width, y));
			points.push(new FPGPoint2d(x+width, y+height));
			points.push(new FPGPoint2d(x, y+height));
			return new FPGPolygon2d(points);
		}
		
		/**
		 * Создать полигон-окружность
		 * @param x Цент по X
		 * @param y Цент по Y
		 * @param radius Радиус
		 * @param count Количество углов
		 * @param name Назавние полигона
		 */
		public static function circle(x:Number, y:Number, radius:Number, count:int, name:String=null):FPGPolygon2d
		{
			var points:Vector.<FPGPoint2d> = new Vector.<FPGPoint2d>();
			var i:int;
			var delta:Number = Math.PI*2/count;
			var angle:Number = 0;
			for (i=0; i<count; i++) {
				angle = delta*i;
				points.push(new FPGPoint2d(x+radius*Math.cos(angle), y+radius*Math.sin(angle)));
			}
			return new FPGPolygon2d(points);
		}
		
		/**
		 * Создать полигон сегмент окружности
		 * @param x Цент по X
		 * @param y Цент по Y
		 * @param radius Радиус
		 * @param countAll Количество всех сегментов в окружности
		 * @param countSegments Количество видимых сегментов
		 * @param name Назавние полигона
		 */
		public static function circleSegment(x:Number, y:Number,
											 radius:Number,
											 countAll:int, countSegments:int,
											 name:String=null):FPGPolygon2d
		{
			var points:Vector.<FPGPoint2d> = new Vector.<FPGPoint2d>();
			points.push(new FPGPoint2d(x, y));
			var i:int;
			var delta:Number = Math.PI*2/countAll;
			var angle:Number = 0;
			for (i=0; i<countSegments; i++) {
				angle = delta*i;
				points.push(new FPGPoint2d(x+radius*Math.cos(angle), y+radius*Math.sin(angle)));
			}
			return new FPGPolygon2d(points);
		}
	}
}