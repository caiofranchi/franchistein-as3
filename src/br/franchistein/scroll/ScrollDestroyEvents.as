package br.franchistein.scroll
{
	import flash.events.Event;
	
	public class ScrollDestroyEvents extends Event
	{
		
		//GENERAL EVENTS
		public static const ON_START_SCROLLING		:String = "startScrolling";
		public static const ON_UPDATE_SCROLLING		:String = "updateScrolling";
		public static const ON_COMPLETE_SCROLLING	:String = "completeScrolling";
		
		//INTERFACE EVENTS
		public static const ON_SCROLL_WHEEL			:String = "scrollWheel";
		public static const ON_DRAGGING				:String = "scrollDragging";		
		public static const ON_BACKGROUND_CLICK		:String = "onBackgroundClick";
		public static const ON_CLICK_UP				:String = "onClickUp";
		public static const ON_CLICK_DOWN			:String = "onClickDown";
		
		//VARS
		public var direction						:String;
		public var speed							:Number;
		public var positionChanged					:Number;
		
		//POSITIONS	//TODO: Study to see the better way of puting this in the Main class
		public var numStartXPosition				:Number;
		public var numFinalXPosition				:Number;
		public var numStartYPosition				:Number;
		public var numFinalYPosition				:Number;
		
		//
		public var numCurrentPercentage				:Number
		
		//
		public function ScrollDestroyEvents(type:String,bubbles:Boolean=false,cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			//this.combo = (combo == null) ? null : combo;
			/* this.value = (combo == null && combo.selectedItem==null) ? null : combo.selectedItem.value;
			this.label = (combo == null && combo.selectedItem==null) ? null : combo.selectedItem.label; */
		}
	}
	
}