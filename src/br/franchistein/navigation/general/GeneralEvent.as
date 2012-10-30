package br.franchistein.navigation.general
{
	import br.franchistein.navigation.area.Ambient;
	import br.franchistein.navigation.area.Area;
	
	import flash.events.Event;

	public class GeneralEvent extends Event
	{
		//MODAL
		public static var OPEN_MODAL				:String = "onOpenModal";
		public static var CLOSE_MODAL				:String = "onCloseModal";
		
		//FULLSCREEN
		public static var OPEN_FULLSCREEN			:String = "onOpenFullScreen";
		public static var CLOSE_FULLSCREEN			:String = "onCloseFullScreen";
		
		//GENERAL SOUND
		public static var MUTE						:String = "onMute";
		public static var UNMUTE					:String = "onUnMute";
		
		//MISC
		public static var ON_RESIZE					:String = "onResize";
		public static var READY						:String = "onReady";
		
		public static var CHANGE_SWFADDRESS			:String = "onChangeSwfAddress";
		
		//
		public var area								:Ambient;
		//
		public function GeneralEvent(type:String,pAreaCurrent:Ambient=null,bubbles:Boolean=false,cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			//
			this.area = (pAreaCurrent == null) ? null : pAreaCurrent;
		}
	}
}