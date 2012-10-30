package br.franchistein.navigation.menu
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public interface IMenuButton
	{
		function activate(e:Event=null):void 
		function deactivate(e:Event=null):void
		function rollOver(e:MouseEvent=null):void 
		function rollOut(e:MouseEvent=null):void
		
		/*
		function set numIndice(pIntIndex:int):void
		function get numIndice():int
		
		function get isLockeable():Boolean
		function set isLockeable():void
		*/
	}
}