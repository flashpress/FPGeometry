/**
 * Created by sam on 06.04.16.
 */
package core {
    import flash.net.SharedObject;

    public class Share
    {
        private static var sharedObject:SharedObject;
        private static var inited:Boolean;
        private static function init():void
        {
            sharedObject = SharedObject.getLocal('share');
            inited = true;
        }

        public static function open(name:String, defValue:*=null):*
        {
            if (!inited) init();
            return sharedObject.data.hasOwnProperty(name) ? sharedObject.data[name] : defValue;
        }

        public static function save(name:String, value:*):void
        {
            if (!inited) init();
            sharedObject.data[name] = value;
        }
    }
}
