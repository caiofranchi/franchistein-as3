package br.franchistein.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;

	public class DisplayUtils
	{		
		public static function localToLocal(pFrom:DisplayObject, pTo:DisplayObject, pPoint:Point):Point {
			return pTo.globalToLocal(pFrom.localToGlobal(pPoint));
		}
		
		//Locking
		public static function lockDisplayObject(...params):void {
			for(var i:int=0;i<params.length;i++){
				var dspObject:DisplayObjectContainer = params[i] as DisplayObjectContainer;
				dspObject.mouseEnabled = dspObject.mouseChildren = false;
			}
			
		}		
		public static function unlockDisplayObject(...params):void {
			for(var i:int=0;i<params.length;i++){
				var dspObject:DisplayObjectContainer = params[i] as DisplayObjectContainer;
				dspObject.mouseEnabled = dspObject.mouseChildren = true;
			}		
		}
		public static function lockAllDisplayObject(pContainer:DisplayObjectContainer):void {
			for(var i:int=0;i<pContainer.numChildren;i++){
				try{
					var mov:DisplayObjectContainer = pContainer.getChildAt(i) as DisplayObjectContainer
					lockDisplayObject(mov);
				}catch(e:Error){}
			}
		}
		public static function unlockAllDisplayObject(pContainer:DisplayObjectContainer):void {
			for(var i:int=0;i<pContainer.numChildren;i++){
				try{
					var mov:DisplayObjectContainer = pContainer.getChildAt(i) as DisplayObjectContainer
					unlockDisplayObject(mov);
				}catch(e:Error){}
			}
		}
		//
		public static function findInside(pStrChildName:String,pDspObjectContainer:DisplayObjectContainer):DisplayObject {
			var _dspRetorno:DisplayObject
			//
			for(var i:int=0;i<pDspObjectContainer.numChildren;i++){
				var _dspObject:Object = pDspObjectContainer.getChildAt(i) as Object;
				if(_dspObject.name==pStrChildName){
					//caso tenha achado
					_dspRetorno = _dspObject as DisplayObject
				}else {
					//caso nao, procura dentro recursivamente
					try {
						_dspRetorno = findInside(pStrChildName,_dspObject as DisplayObjectContainer);
					}catch(e:Error){}
				}
				if(_dspRetorno!=null) return _dspRetorno;
			}
			//
			return _dspRetorno;
		}
		//
		public static function removeAll(pContainer:DisplayObjectContainer):Array {
			var _arrTemp:Array = [];
			//
			while(pContainer.numChildren > 0 ) {
				_arrTemp.push(pContainer.getChildAt(0));
				pContainer.removeChildAt(0);
			}
			//
			return _arrTemp;
		}
		//
		public static function getAllFrom(pContainer:DisplayObjectContainer):Array {
			var _arrItems:Array = [];
			//
			for(var i:int=0;i<pContainer.numChildren;i++){
				try{
					_arrItems.push(pContainer.getChildAt(i));
				}catch(e:Error){
					throw new Error("Erro ao tentar guardar o objeto.");
				}
			}
			//
			return _arrItems;
		}
		//
		public static function stopAll(pContainer:DisplayObjectContainer):void {
			for(var i:int=0;i<pContainer.numChildren;i++){
				try{
					var mov:MovieClip = pContainer.getChildAt(i) as MovieClip
					mov.stop()
				}catch(e:Error){}
			}
		}
		public static function resumeAll(pContainer:DisplayObjectContainer):void {
			for(var i:int=0;i<pContainer.numChildren;i++){
				try{
					var mov:MovieClip = pContainer.getChildAt(i) as MovieClip
					mov.play()
				}catch(e:Error){}
			}
		}
	}
}