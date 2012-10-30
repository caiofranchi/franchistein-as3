package br.franchistein.player
{
	import flash.events.Event;
	
	public class PlayerEvent extends Event
	{
		public static const VERSION:Number = 1.0;
		
		public static const START:String = "init";
		public static const CHANGE_BANNER:String = "change";
		
		public static const BANNER_PROGRESS:String = "itemProgress";
		public static const BANNER_START:String = "itemStart";
		public static const BANNER_COMPLETE:String = "itemComplete";
		public static const BANNER_ERROR:String = "itemError";
		
		public static const QUEUE_START:String = "queueStart";
		public static const QUEUE_PROGRESS:String = "queueProgress";
		public static const QUEUE_COMPLETE:String = "queueComplete";
		
		public var content : *;

		public var fileType : int;

		public var bytesLoaded : Number = -1;

		public var bytesTotal : Number = -1;	

		public var percentage : Number = 0;

		public var queuepercentage : Number = 0;

		public var index : int;	

		public var width : Number;

		public var height : Number;
		
		public var isNext : Boolean;

		public var message : String = "";

		public var item : Object = null;

		public function PlayerEvent( type : String, currItem:Object, queuepercentage:Number, index:int,pIsNext:Boolean=true, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			this.fileType = (currItem.fileType == null) ? null : currItem.fileType;
			this.bytesLoaded = (currItem.bytesLoaded == null) ? null : currItem.bytesLoaded;
			this.bytesTotal = (currItem.bytesTotal == null) ? null : currItem.bytesTotal;
			this.percentage = (currItem.percentage == null) ? null : currItem.percentage;
			this.isNext = pIsNext;
			this.queuepercentage = queuepercentage;
			this.index = index;
			this.width = (currItem.width == null) ? null : currItem.width;
			this.height = (currItem.height == null) ? null : currItem.height;
			this.message = (currItem.message == null) ? null : currItem.message;
			this.item = (currItem == null) ? null : currItem;
			this.content = (currItem.content == null) ? null : currItem.content;
		}
		/* public function PlayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		*/
		public override function clone():Event {
			return new PlayerEvent(this.type,null,0,0, this.bubbles, this.cancelable);
		} 

	}
}