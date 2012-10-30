package br.franchistein.navigation.area
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public interface IArea extends IEventDispatcher
	{
		function open(pStrOpenAmbient:String=null):void;
		function close():void;
		function realign(pEvent:Event=null):void;
		function mute():void;
		function unMute():void;
		function pause():void;
		function resume():void;
		function dispose(pEvent:Event=null):void;
		function dispatch(pStrEventName:String,...params):void
	}
}