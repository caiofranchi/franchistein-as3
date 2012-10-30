package br.franchistein.event.custom
{
	import flash.events.Event;
	
	public class CustomEvent extends Event 
	{
		public static const COMPLETE:String = "onComplete";
		public static const CHANGE:String = "onChange";
		public static const START:String = "onStart";
		
		public var id	:String;
		public var dataObj	:Object;
		
		public function CustomEvent(type:String,strID:String="", dataObj:Object = null) 
		{
			this.dataObj = dataObj;
			this.id = strID;
			
			super(type, false, false);
		}
		
		override public function clone():Event
		{
			return new CustomEvent(type, dataObj);
		}
	}
}