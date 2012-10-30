package br.franchistein.display
{
	import br.franchistein.performance.MemoryJanitor;
	import br.franchistein.utils.DisplayUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class SpriteDestroy extends Sprite
	{
		private var isDisposeable		:Boolean = false;
		private var isDisposed			:Boolean = false;
		
		private var sprThis				:SpriteDestroy
		
		private var memJanitor			:MemoryJanitor
		public function SpriteDestroy()
		{
			super();
			
			sprThis = this;
			
			//
			memJanitor = new MemoryJanitor(sprThis.name);
			//
			memJanitor.registerObject(sprThis);
			
			//pegando os objetos de dentro e colocando na janitor
			var _arrDisplaysInternos:Array = DisplayUtils.getAllFrom(sprThis);
			//
			for(var i:int=0;i<_arrDisplaysInternos.length;i++){
				memJanitor.registerObject(_arrDisplaysInternos[i]);
			}
			//
			_arrDisplaysInternos = [];
			//
			addEventListener(Event.REMOVED_FROM_STAGE,onMovieClipRemoved);
			//
			memJanitor.registerEvent(sprThis,Event.REMOVED_FROM_STAGE,onMovieClipRemoved);
		}
		
		override public function addChild(p:DisplayObject):DisplayObject {
			memJanitor.registerObject(p);
			//
			return super.addChild(p);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			memJanitor.removeObject(child);
			//
			return super.removeChild(child);
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			memJanitor.registerEvent(sprThis,type,listener);
			//
			super.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		private function onMovieClipRemoved(e:Event):void {
			isDisposed = true;
			if(isDisposeable) dispose();
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			memJanitor.removeEvent(sprThis,type,listener);
			//
			super.removeEventListener(type,listener,useCapture);
		}		
		
		public function dispose():void {
			if(isDisposed) return;
			
			isDisposed = true;
			//
			memJanitor.clean();			
			//
			sprThis = null
		}
		
		//GETTERS & SETTERS
		
		public function get autoDisposeable():Boolean {
			return isDisposeable;
		}
		
		public function set autoDisposeable(pIsDisposeable:Boolean):void {
			isDisposeable = pIsDisposeable;
		}
	}
}