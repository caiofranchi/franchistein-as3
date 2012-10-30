package br.franchistein.navigation.controller
{
	import br.franchistein.navigation.area.Ambient;
	import br.franchistein.navigation.area.Area;
	
	import flash.events.Event;

	public class ControllerEvent extends Event
	{
		
		//AREAS
		public static var OPEN_AMBIENT					:String = "openAmbient";
		
		public static var OPEN_TRANSITION_START			:String = "openTransitionStart";
		public static var OPEN_TRANSITION_COMPLETE		:String = "openTransitionComplete";
		public static var OPEN_TRANSITION_UPDATE		:String = "openTransitionUpdate";
		
		public static var CLOSE_TRANSITION_START		:String = "closeTransitionStart";
		public static var CLOSE_TRANSITION_COMPLETE		:String = "closeTransitionComplete";
		public static var CLOSE_TRANSITION_UPDATE		:String = "closeTransitionUpdate";
		
		public static var LOADING_AREA_START			:String = "onStartLoadingArea";
		public static var LOADING_AREA_PROGRESS			:String = "onStartLoadingAreaProgress";
		public static var LOADING_AREA_COMPLETE			:String = "onStartLoadingAreaComplete";
		//
		public var area									:Ambient;
		//
		public function ControllerEvent(type:String,pArea:Ambient=null,bubbles:Boolean=false,cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			//
			this.area = (pArea == null) ? null : pArea;
		}
	}
}