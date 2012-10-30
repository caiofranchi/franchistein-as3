package br.franchistein.scroll
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class ScrollDestroy extends MovieClip implements IEventDispatcher
	{
		private var scrDestroyThis			:ScrollDestroy
		
		private var sciScrollInterface		:ScrollInterface
		
		//Config
		public var numSpeed					:Number = 3;
		private var numRefreshRate			:Number = 0;		
		private var strDirection			:String = ScrollDirections.VERTICAL;
		
		//Handlers
		private var tmRefresh				:Timer
		private var isEnabled				:Boolean = true;
		private var evtDispatcher			:EventDispatcher
		//		
		public function ScrollDestroy(pStrDirection:String,pScrollInterface:ScrollInterface=null,pSpeed:Number = 3,pRefreshRate:Number=0,pNumFalseValue:Number=0)
		{
			scrDestroyThis = this;
			//
			tmRefresh =  = new Timer();
			evtDispatcher = new EventDispatcher();
			//pStrDirection,pSpeed
			if(pScrollInterface)
				scrollInterface = pScrollInterface;
			else
				autoConfig();
		}
		//config
		public function refresh():void {
			
		}
		
		//Moving
		public function moveToPosition():void {
		
		}
		
		public function moveToPercent():void {
		
		}
		
		public function move(pNumInterval:Number):void {
		
		}
		
		public function moveUp(pNumInterval:Number=-1):void {
		
		}
		
		public function moveDown(pNumInterval:Number=-1):void {
			
		}
		
		//Controlling
		public function startNavigation():void {
			//start navigation
		}
		public function resumeScrolling():void {
			//resume scrolling content
		}
		public function stopScrolling():void {
			//stop scrolling content
		}
		
		//garbage collecting
		public function dispose():void {
			
			//event listeners
			
			//null
			scrDestroyThis = null
		}
		//PRIVATE FUNCTIONS
		
		//Auto searching all interface itens
		private function autoConfig(pDspContainer:MovieClip):void {
			var sciScrollInterfaceTemp:ScrollInterface;
			//
			//sciScrollInterfaceTemp.configButtons();
			//sciScrollInterfaceTemp.configContent();
			//
			scrollInterface = sciScrollInterfaceTemp;
		}
		//clean and config the scroll interface
		private function updateInterface():void {			
			//removing all event listeners
			removeAllListeners();
			
			//adding event listeners
			setAllListeners();
		}
		//setting all listeners of the interface
		private function setAllListeners():void {
		
		}
		//removing all listeners of the interface
		private function removeAllListeners():void {
			
		}
		//EVENTS
		
		//GETTERS AND SETTERS
		
		public function get enabled ():Boolean {
			return isEnabled;
		}
		public function set enabled(pIsEnabled:Boolean):void {
			 
		}
		
		public function get scrollInterface():ScrollInterface {
			return sciScrollInterface;
		}
		public function set scrollInterface(pScrollInterface:ScrollInterface):void {
			sciScrollInterface = pScrollInterface;
			//
			updateInterface();
		}
		
		public function get refreshRate():Number {
			return numRefreshRate;
		}
		
		public function set refreshRate(pNumRefreshRate:Number):void {
			numRefreshRate = pNumRefreshRate;
			//
			if(numRefreshRate>0) {
				tmRefresh = new Timer(numRefreshRate);
				tmRefresh.start()
				//
					if(!tmRefresh.hasEventListener(TimerEvent.TIMER)) tmRefresh.addEventListener(TimerEvent.TIMER,onTimerRefresh);
			}else {
				tmRefresh.stop();
			}
		}
		//EVENTS
		private function onMouseDownButtonUp(e:MouseEvent):void {
			
		}
		private function onMouseDownButtonDown(e:MouseEvent):void {
			
		}
		private function onBackgroundClick(e:MouseEvent):void {
			//
			dispatchEvent(new ScrollDestroyEvents(ScrollDestroyEvents.ON_BACKGROUND_CLICK));
		}
		private function onMouseWheelThis(e:MouseEvent):void {
			//
			dispatchEvent(new ScrollDestroyEvents(ScrollDestroyEvents.ON_SCROLL_WHEEL));
		}
		//DISPATCHER
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void {
			evtDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(evt:Event) : Boolean {
			return evtDispatcher.dispatchEvent(evt);
		}
		
		public function hasEventListener(type:String) : Boolean {
			return evtDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void {
			evtDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String) : Boolean {
			return evtDispatcher.willTrigger(type);
		}
	}
}