package br.franchistein.performance
{
	import br.franchistein.navigation.debug.NavigationMode;
	import br.franchistein.utils.ArrayUtils;
	import br.franchistein.utils.ClassUtils;
	import br.franchistein.utils.DisplayUtils;
	import br.franchistein.utils.MemoryUtils;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.system.System;
	import flash.utils.describeType;

	/**
	 * 	This class works for manage a group of disposeable item's
	 *  
	 * 	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 	@author Caio Franchi
	 *  @version 0.1b
	 *	@tiptext
	 */	
	public class MemoryJanitor
	{
		private var strName						:String = "";
		
		private var arrItems					:Array
		private var arrEvents					:Array
		
		public static const DISPOSEABLES		:Array = ["shape","graphic","sprite","bitmap","movieclip","xml","sound","loader"]
					
		/**
		 *	Set the name of the Janitor Class
		 * 
		 * 	@param pStrJanitorName The name of the janitor
		 *
		 *	@return void
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public function MemoryJanitor(pStrJanitorName:String="")
		{	
			name = pStrJanitorName
			//
			arrItems = [];
			arrEvents = [];
		}
		
		/**
		 *	Register a object on the Janitor class
		 * 
		 * 	@param pObject Any disposeable object
		 *
		 *	@return void
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public function registerObject(pObject:Object):void {
			var _strClassOfObject:String = ClassUtils.getClassName(pObject);
			//
			if(DISPOSEABLES.toString().indexOf(_strClassOfObject.toLowerCase())!=-1){
				//o elemento é disposeable e será registrado
				if(!ArrayUtils.containValue(arrItems,arrItems)) arrItems.push({object:pObject,type:_strClassOfObject});
				//trace('added '+_strClassOfObject+' '+pObject.name+' To Janitor {'+name+'}');
			}else {
				//caso nao passe pelo primeiro filtro, verifico as classes herdadas
				var _strClassDisposeable:String = findFirstDisposeableClassInObject(pObject);
				if(_strClassDisposeable!="object"){
					if(!ArrayUtils.containValue(arrItems,arrItems))  arrItems.push({object:pObject,type:_strClassDisposeable});
				}else {
					//o elemento não é disposeable pela classe, joga exception
					throw new Error("O elemento:"+pObject+" não está registrado como um disposeable. Classe recebida:"+_strClassOfObject);
				}
			}
		}
		
		/**
		 *	Register a event on the Janitor class
		 * 
		 * 	@param pObject Any disposeable object that has an event listener
		 * 
		 *  @param pEventType The event type that will be disposed
		 * 
		 * 	@param pListener The Function listener that will be disposed
		 *
		 *	@return void
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public function registerEvent(pObject:Object,pEventType:String,pListener:Function):void {
			arrEvents.push({object:pObject,type:pEventType,listener:pListener});
		}
		
		public function removeEvent(pObject:Object,pEventType:String,pListener:Function):void {
			//
		}
		
		public function removeObject(pObject:Object):void {
			//ArrayUtils.
		}
		
		/**
		 *	Clear a unique event
		 * 
		 * 	@param pObject The target object that will be cleaned
		 * 
		 *  @param pStrEventType The type of the event that will be cleaned
		 * 
		 * 	@param pFncListenerFunction The Function listener that will be disposed
		 *
		 *	@return void
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public function cleanEvent(pObject:Object,pStrEventType:String,pFncListenerFunction:Function):void {
			pObject.removeEventListener(pStrEventType,pFncListenerFunction);
		}
		
		/**
		 *	Dispose a unique object
		 * 
		 * 	@param pObject The target object that will be cleaned
		 * 
		 *  @param pType The type of the dispose that the method will assume
		 *
		 *	@return void
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public function cleanItem(pObject:Object,pType:String):void {
			//
			switch(pType.toLowerCase()){
				case "sprite":
					var sprSprite:Sprite = pObject as Sprite
					//
					if(sprSprite.parent!=null) (sprSprite.parent as DisplayObjectContainer).removeChild(sprSprite);
					DisplayUtils.stopAll(sprSprite);
					DisplayUtils.removeAll(sprSprite);					
					//
					break;
				
				case "movieclip":
					var movMovieClip:MovieClip = pObject as MovieClip
					//
					if(movMovieClip.parent!=null) {
						try{
							  (movMovieClip.parent as DisplayObjectContainer).removeChild(movMovieClip);
						}catch(e:Error){
							//
							trace("erro");	
						}
					}
					
					movMovieClip.stop();
					//
					for(var i:int=1;i<movMovieClip.totalFrames+1;i++){
						movMovieClip.gotoAndStop(i);
						DisplayUtils.stopAll(movMovieClip);
					}	
					//
					movMovieClip.stop();
					DisplayUtils.removeAll(movMovieClip);
					
					
					break;
					
				case "bitmap":
					var bmpBitmap:Bitmap = pObject as Bitmap
					//
					bmpBitmap.bitmapData.dispose();
					
					break;
				
				case "shape":
					var shpShape:Shape = pObject as Shape
					//
					shpShape.graphics.clear();
					
					break;
				case "xml":
					var xmlXML:XML =  pObject as XML;
					
					if(System["disposeXML"]!=null) System["disposeXML"](xmlXML); //Só está disponível na versão FP 10.1 =(
					
					break;
				
				case "sound":
					var sndSound:Sound =  pObject as Sound;
					sndSound.close()
					
					break;
				
				case "loader":
					var ldLoader:Loader =  pObject as Loader;
					
					ldLoader.close()
					
					if(NavigationMode.getMajorVersion()>=10) 
						ldLoader.unloadAndStop();
					else						
						ldLoader.unload()
					
					break;
				
				case "object":
					
					pObject = null;
				
					break;
				default:
					if (pObject.dispose !=null) pObject.dispose();
					//throw new Error("O Item não pode ser limpo pois não foi reconhecido na lista de disposeables. -"+pType+"-");
					break
			}
		}
		
		/**
		 *	Dispose all the objects that have been registered on the Janitor
		 * 
		 * 	@param pObjectType The type of the objects that will be disposed
		 *
		 *	@return void
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public function clean(pStrType:String="both"):void {
						
			if(pStrType=="both"){
				
				//cleaning events
				for(i=0;i<arrEvents.length;i++){
					cleanEvent(arrEvents[i].object,arrEvents[i].type,arrEvents[i].listener);
				}
				
				//cleaning items
				for(var i:int=0;i<arrItems.length;i++){
					cleanItem(arrItems[i].object,arrItems[i].type);
				}
				
				
				
			}else if (pStrType=="event"){
				
				//cleaning events
				for(i=0;i<arrEvents.length;i++){
					cleanEvent(arrEvents[i].object,arrEvents[i].type,arrEvents[i].listener);
				}
				
			}else if (pStrType=="object"){
				
				//cleaning items
				for(i=0;i<arrItems.length;i++){
					cleanItem(arrItems[i].object,arrItems[i].type);
				}
				
			}
			//
			arrItems = []
			arrEvents = []
			
			MemoryUtils.forceGarbageCollection();
				
			//trace('cleaned Janitor {'+name+'}');
		}
		
		private function findFirstDisposeableClassInObject(pObjObject:Object):String {
			var xmlExtends:XMLList = describeType(pObjObject)..extendsClass;
			var _strRetorno:String = "Object";
			//
			for(var i:int=0;i<xmlExtends.length();i++){
				var _strFiltrado:String = ClassUtils.packageCleaner(String(xmlExtends[i].@type).toLowerCase());
				if(DISPOSEABLES.toString().indexOf(_strFiltrado)!=-1) {
					return _strFiltrado
				}
			}
			//
			return _strRetorno
		}
		
		//GETTERS & SETTERS
		
		public function get name():String {
			return strName;
		}
		
		public function set name(pStrName:String):void {
			strName = pStrName;
		}
		
	}
}