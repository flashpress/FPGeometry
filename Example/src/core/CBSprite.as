/**
 * Created by sam on 25.12.15.
 */
package core {
    import flash.display.Sprite;

    import ru.flashpress.callback.FPCaller;
    import ru.flashpress.callback.IFPTarget;

    public class CBSprite extends Sprite implements IFPTarget
    {
        private var _caller:FPCaller;
        public function CBSprite()
        {
            _caller = new FPCaller(null, this, callback);
        }

        public function get caller():FPCaller {return _caller;}

        protected function callback(chanel:String, data:Object, caller:*, fcaller:*):int
        {
            return 0;
        }
    }
}
