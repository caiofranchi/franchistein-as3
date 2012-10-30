package br.franchistein.utils
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	
	public class BasicLoader
	{
		public static function loadXML(pURL:String,pFncComplete:Function,...params):URLLoader {
			var urlLoader:URLLoader = new URLLoader();
			//
			urlLoader.load(new URLRequest(pURL));
			urlLoader.addEventListener(Event.COMPLETE,function(e:Event):void {
				var _xmlTemp:XML = new XML(e.currentTarget.data);
				//
				urlLoader.removeEventListener(Event.COMPLETE,arguments.callee)
				//
				params.unshift(_xmlTemp);
				pFncComplete.apply(null,params);
			});
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, function(evt:IOErrorEvent):void {
				trace("erro no carregamento do XML: ", pURL);
			});
			return urlLoader;
		}
		
		public static function loadSWF(pURL:String,pLoaderContext:LoaderContext=null,pFncComplete:Function=null,...params):Loader {
			var ldLoader:Loader = new Loader();
			//
			ldLoader.load(new URLRequest(pURL),pLoaderContext);
			ldLoader.contentLoaderInfo.addEventListener(Event.INIT,function(e:Event):void {
				
				//
				ldLoader.removeEventListener(Event.INIT,arguments.callee)
				//
				params.unshift(ldLoader.content);
				if(pFncComplete!=null) pFncComplete.apply(null,params);
			});
			
			//
			return ldLoader;
		}
		
		public static function loadImage(pURL:String,pLoaderContext:LoaderContext=null,pFncComplete:Function=null,...params):Loader {
			var ldLoader:Loader = new Loader();
			//
			ldLoader.load(new URLRequest(pURL),pLoaderContext);
			ldLoader.contentLoaderInfo.addEventListener(Event.INIT,function(e:Event):void {
				var bmpCarregado:Bitmap = ldLoader.content as Bitmap;
				//
				ldLoader.removeEventListener(Event.INIT,arguments.callee)
				//
				params.unshift(bmpCarregado);
				if(pFncComplete!=null) pFncComplete.apply(null,params);
			});
			//
			return ldLoader;
		}
		
		public static function loadImageIntoContainer(pURL:String,pDspContainer:DisplayObjectContainer,pLoaderContext:LoaderContext=null,pFncComplete:Function=null,...params):Loader {
			var ldLoader:Loader = BasicLoader.loadImage(pURL,pLoaderContext,function(e:Bitmap):void {
				var bmpCarregado:Bitmap = ldLoader.content as Bitmap;
				
				//
				ldLoader.removeEventListener(Event.INIT,arguments.callee)
				//
				pDspContainer.addChild(bmpCarregado);
				//
				if(pFncComplete!=null){
					params.unshift(bmpCarregado);
					pFncComplete.apply(null,params);
				}
			});
			return ldLoader;
		}
		
		public static function loadURL(pStrURL:String,pURLMethod:String,pArrParametros:Array,pFncComplete:Function=null,...params):URLLoader {
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest(pStrURL);
			var urlVariables:URLVariables = new URLVariables();
			//Preenchendo os parametros das variaveis
			for(var i:int=0;i<pArrParametros.length;i++){
				urlVariables[pArrParametros[i].param] = pArrParametros[i].value
			}
			//
			urlRequest.method = pURLMethod;
			urlRequest.data = urlVariables;
			//
			urlLoader.load(urlRequest);
			urlLoader.addEventListener(Event.COMPLETE,function(e:Event):void {
				urlLoader.removeEventListener(Event.COMPLETE,arguments.callee)
				//
				params.unshift(e);
				if(pFncComplete!=null) pFncComplete.apply(null,params);
			});
			return urlLoader;
		}
		public static function loadSound():void {
			
		}
	}
}