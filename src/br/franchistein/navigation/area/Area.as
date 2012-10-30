package br.franchistein.navigation.area
{
	import br.franchistein.display.SpriteDestroy;
	import br.franchistein.navigation.library.Library;
	import br.franchistein.navigation.menu.AbstractMenuButton;
	
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public dynamic class Area extends SpriteDestroy
	{
		public var areThis					:Area;
		
		private var dispatcher				:EventDispatcher = new EventDispatcher()
				
		//config vars
		public var id						:String;
		public var active					:Boolean = true;
		public var type						:String;
		public var tag						:String;
		
		public var isPermalinkEnabled		:Boolean = true;
		
		public var menuButton				:AbstractMenuButton;
		
		protected var dspReferencia			:DisplayObjectContainer		
		//
		public function Area(pDspReference:DisplayObjectContainer=null,pLibArea:Library=null)
		{
			areThis = this;
			//
			//dispatcher = new EventDispatcher();
			dspReferencia = pDspReference;
			if(dspReferencia==null) dspReferencia = areThis.parent as DisplayObjectContainer
		}
		//NAVIGATION
		public function open(pStrOpenAmbient:String=null):void
		{
			dispatch(AreaEvent.OPEN_TRANSITION_START);
			//
			TweenLite.to(areThis,1,{alpha:1,onComplete:function():void {
				dispatch(AreaEvent.OPEN_TRANSITION_COMPLETE);
			},onUpdate:function():void {
				dispatch(AreaEvent.OPEN_TRANSITION_UPDATE);
			}});
		}
		
		public function close():void
		{
			dispatch(AreaEvent.CLOSE_TRANSITION_START);
			//
			TweenLite.to(areThis,1,{alpha:0,onComplete:function():void {
				dispatch(AreaEvent.CLOSE_TRANSITION_COMPLETE);
			},onUpdate:function():void {
				dispatch(AreaEvent.CLOSE_TRANSITION_UPDATE);
			}});
		}
		
		public function pause():void {
		
		}
		
		public function resume():void {
			
		}
		//
		public function mute():void {
			
		}
		
		public function unMute():void {
			
		}
		
		public function realign(e:Event=null):void
		{
			//realinha o conteúdo interno
		}
				
		public function dispatch(pStrEventName:String,...params):void {
			dispatchEvent(new AreaEvent(pStrEventName,areThis as Area));
		}
		
		//GETTERS AND SETTERS
		
		//EVENT DISPATCHER
		/*override public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function dispatchEvent(evt : Event) : Boolean {
			return dispatcher.dispatchEvent(evt);
		}
		
		override public function hasEventListener(type : String) : Boolean {
			return dispatcher.hasEventListener(type);
		}
		
		override public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		override public function willTrigger(type : String) : Boolean {
			return dispatcher.willTrigger(type);
		}*/
	}
}