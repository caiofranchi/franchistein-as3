package br.franchistein.display
{
	import br.franchistein.performance.MemoryJanitor;
	import br.franchistein.utils.DisplayUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * 	This class is a optimized version of the MOVIECLIP Class, with garbage collection integration and new methods
	 *  
	 * 	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 	@author Caio Franchi
	 *  @version 0.1b
	 *	@tiptext
	 */	
	public dynamic class MovieClipDestroy extends MovieClip
	{
		//VARS
		private var mcdThis				:MovieClipDestroy;
		
		private var fncFuture			:Function
			
		private var arrParams			:Array;
		
		private var numFinishFrame		:*;
		
		private var isDisposeable		:Boolean = false;
		private var isDisposed			:Boolean = false;
		
		private var memJanitor			:MemoryJanitor
				
		
		public function MovieClipDestroy()
		{
			super();
			mcdThis = this;
			
			//
			memJanitor = new MemoryJanitor(mcdThis.name);
			//
			memJanitor.registerObject(mcdThis);
			
			//pegando os objetos de dentro e colocando na janitor
			var _arrDisplaysInternos:Array = DisplayUtils.getAllFrom(mcdThis);
			//
			for(var i:int=0;i<_arrDisplaysInternos.length;i++){
				memJanitor.registerObject(_arrDisplaysInternos[i]);
			}
			//
			_arrDisplaysInternos = [];
			//
			addEventListener(Event.REMOVED_FROM_STAGE,onMovieClipRemoved);
			//
			memJanitor.registerEvent(mcdThis,Event.REMOVED_FROM_STAGE,onMovieClipRemoved);
		}
		
		public function gotoAndPlayUntil(pFrameStart:*,pFrameFinish:*,pFunction:Function=null,...params):void {
			mcdThis.removeEventListener(Event.ENTER_FRAME,onEnterFrameUntil);
			//
			mcdThis.gotoAndPlay(pFrameStart);
			mcdThis.addEventListener(Event.ENTER_FRAME,onEnterFrameUntil);
			//
			numFinishFrame = pFrameFinish;
			fncFuture = pFunction;
			arrParams = params;
		}
		
		public function rewindUntil(pFrom:*,pTo:*,pFunction:Function=null,...params):void {
			mcdThis.removeEventListener(Event.ENTER_FRAME,onEnterFrameUntil);
			mcdThis.gotoAndStop(pFrom);
			mcdThis.addEventListener(Event.ENTER_FRAME,function(e:Event):void {
				
				if(mcdThis.currentFrame==pTo ){
					//finish
					mcdThis.removeEventListener(Event.ENTER_FRAME,arguments.callee);
					mcdThis.stop();
					if(pFunction!=null) pFunction.apply(mcdThis,params);
				}else {
					if(mcdThis.currentFrame==1)
						mcdThis.gotoAndStop(mcdThis.totalFrames);
					else
						mcdThis.prevFrame();
				}
			});
		}
				
		public function dispose():void {
			if(isDisposed) return;
			
			isDisposed = true;
			//
			memJanitor.clean();			
			//
			mcdThis = null
		}
		
		//GETTERS & SETTERS
		
		public function get autoDisposeable():Boolean {
			return isDisposeable;
		}
		
		public function set autoDisposeable(pIsDisposeable:Boolean):void {
			isDisposeable = pIsDisposeable;
		}
		
		//EVENTS
		
		private function onEnterFrameUntil(e:Event):void {
			if(mcdThis.currentFrame==numFinishFrame || mcdThis.currentFrameLabel==numFinishFrame){
				//finish
				mcdThis.removeEventListener(Event.ENTER_FRAME,onEnterFrameUntil);
				mcdThis.stop();
				if(fncFuture!=null) fncFuture.apply(mcdThis,arrParams);
			}			
		}
		
		private function onMovieClipRemoved(e:Event):void {
			isDisposed = true;
			if(isDisposeable) dispose();
		}
		
		//OVERRIDED METHODS
		
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
			memJanitor.registerEvent(mcdThis,type,listener);
			//
			super.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			memJanitor.removeEvent(mcdThis,type,listener);
			//
			super.removeEventListener(type,listener,useCapture);
		}		
	}
}