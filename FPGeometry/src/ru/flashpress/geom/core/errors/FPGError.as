package ru.flashpress.geom.core.errors
{
	public class FPGError extends Error
	{
        public static const FIXED:int = 1;
		//
		public function FPGError(errorId:int, ...params)
		{
			var message:String = '';
			super(message, errorId);
		}
	}
}