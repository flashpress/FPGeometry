/**
 * Created by sam on 02.03.15.
 */
package ru.flashpress.geom.view.core
{
    public class FPGFillData
    {
        public static const RED:FPGFillData = new FPGFillData(0xff0000);
        public static const GREEN:FPGFillData = new FPGFillData(0x00ff00);
        public static const BLUE:FPGFillData = new FPGFillData(0x0000ff);
        //
        //
        //
        public var lineColor:int;
        public var lineAlpha:Number;
        public var lineThikness:int;
        public var fillColor:int = -1;
        public var fillAlpha:Number = 0;
        public var dotline:Boolean;
        public function FPGFillData(lineColor:int=-1, lineAlpha:Number=0.5, lineThikness:int=1)
        {
            this.lineColor = lineColor;
            this.lineAlpha = lineAlpha;
            this.lineThikness = lineThikness;
        }
    }
}
