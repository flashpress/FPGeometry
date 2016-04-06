package ru.flashpress.geom.core.interfaces
{
	import flash.events.IEventDispatcher;
	
	import ru.flashpress.geom.point.FPGPoint2d;

	public interface IParametricEquation extends IEventDispatcher
	{
		function pointFromTime(time:Number):FPGPoint2d;
	}
}