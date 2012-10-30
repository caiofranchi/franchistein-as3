package br.franchistein.navigation.area
{
	import flash.events.Event;

	public class AreaEvent extends Event
	{
		//GENERAL EVENTS
		public static var OPEN_TRANSITION_START		:String = "openTransitionStart";
		public static var OPEN_TRANSITION_COMPLETE	:String = "openTransitionComplete";
		public static var OPEN_TRANSITION_UPDATE	:String = "openTransitionUpdate";
		
		public static var CLOSE_TRANSITION_START	:String = "closeTransitionStart";
		public static var CLOSE_TRANSITION_COMPLETE	:String = "closeTransitionComplete";
		public static var CLOSE_TRANSITION_UPDATE	:String = "closeTransitionUpdate";
		//
		public var area								:Area 
		//
		public function AreaEvent(type:String,pArea:Area = null,bubbles:Boolean=false,cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.area = (pArea == null) ? null : pArea;
		}
	}
}