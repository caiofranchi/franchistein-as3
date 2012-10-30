package br.franchistein.navigation.modal
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class AbstractModal extends MovieClip implements IModal
	{
		public var modThis					:AbstractModal;
		
		public function AbstractModal()
		{
			modThis = this;
		}
		
		public function open():void
		{
		}
		
		public function close():void
		{
		}
		
		public function realign(e:Event=null):void
		{
		}
	}
}