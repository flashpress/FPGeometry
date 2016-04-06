package ru.flashpress.geom.line
{
	import ru.flashpress.geom.point.FPGPoint2d;
    import ru.flashpress.geom.point.FPGPoint2dFactory;

    public class FPGLine2dFactory
	{

        public static function get AXIS_X():FPGLine2d
        {
            return new FPGLine2d(FPGPoint2dFactory.ZERO, FPGPoint2dFactory.AXIS_X);
        }

        public static function get AXIS_Y():FPGLine2d
        {
            return new FPGLine2d(FPGPoint2dFactory.ZERO, FPGPoint2dFactory.AXIS_Y);
        }

		/**
		 * Линия паралельная оси Абцисс
		 * @param y Значение Ординаты
		 */
		public static function lineX(y:Number=0):FPGLine2d
		{
			return new FPGLine2d(new FPGPoint2d(0, y), new FPGPoint2d(1, y));
		}

		
		/**
		 * Линия паралельная оси Ординат
		 * @param y Значение Абциссы
		 */
		public static function lineY(x:Number=0):FPGLine2d
		{
			return new FPGLine2d(new FPGPoint2d(x, 0), new FPGPoint2d(x, 1));
		}
		
		/**
		 * Линия проходящая через заданную точку, под заданным углом 
		 * @param rads Угол наклона линии
		 * @param x0 - Точка через которую проходит прямая под заданным углом
		 * @param y0 - Точка через которую проходит прямая под заданным углом
		 */
		public static function incline(rads:Number, x0:Number=0, y0:Number=0, length:uint=1, line:FPGLine2d=null):FPGLine2d
		{
			if (line != null) {
				rads += line.direction.angle;
			}
			return new FPGLine2d(new FPGPoint2d(x0, y0), new FPGPoint2d(x0+length*Math.cos(rads), y0+length*Math.sin(rads)));
		}
	}
}