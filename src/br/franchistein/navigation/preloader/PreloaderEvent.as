package br.franchistein.navigation.preloader
{
	import flash.events.Event;

	public class PreloaderEvent extends Event
	{
		//PRELOADER EVENTS
		public static var FIRST_FRAME_READY			:String = "onFirstFrameReady";
		public static var SETUP						:String = "onConfigFinished";
		
		//QUEUE EVENTS
		public static var START_PRELOADING			:String = "onStartPreloading";
		public static var PROGRESS_PRELOADING		:String = "onProgressPreloading";
		public static var FINISH_PRELOADING			:String = "onFinishPreloading";
		
		//ITEM EVENTS
		public static var ITEM_START				:String = "onItemStart";
		public static var ITEM_PROGRESS				:String = "onItemProgress";
		public static var ITEM_COMPLETE				:String = "onItemComplete";
		public static var ITEM_ERROR				:String = "onItemError";
		
		//VARS
		public var numQueuePercentage				:Number;
		public var numItemPercentage				:Number;
		public var currentItem						:Object;
		//
		public function PreloaderEvent(type:String,pNumQueuePercentage:Number,pStrCurrentItem:Object,pNumPorcentagemItem:Number=0,bubbles:Boolean=false,cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.numQueuePercentage = (pNumQueuePercentage <= 0) ? 0 : pNumQueuePercentage;
			this.numItemPercentage = (pNumPorcentagemItem <= 0) ? 0 : pNumPorcentagemItem;
			this.currentItem = (pStrCurrentItem == null) ? null : pStrCurrentItem;
		}
	}
}