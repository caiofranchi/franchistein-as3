package br.franchistein.navigation.preloader
{
	import br.franchistein.navigation.library.Library;
	import br.franchistein.tracking.TrackingControl;
	import br.franchistein.tracking.modules.AnalyticsModule;
	import br.franchistein.utils.ClassUtils;
	import br.franchistein.utils.StringUtils;
	
	import com.asual.swfaddress.SWFAddress;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.utils.getQualifiedClassName;
	
	/*
	 * Preloader Class
	 * @author Caio Franchi
	*/
	public class Preloader extends Sprite
	{		
		protected var prdThis				:Preloader
		
		public var strPathBase				:String = "";
		public var strIDOpeningArea			:String = "";
		private var strXMLPath				:String = "";
				
		private var xmlLoader				:URLLoader
		
		private var hasStartedPreloading	:Boolean = false;
		
		public var numPorcentagemGeral		:Number = 0;
		public var intCurrentItem			:int=0
			
		private var isIgnoreErrors			:Boolean = true;
		
		public var xmlMain					:XML;
		public var xmlListAreas				:XMLList
		
		public var arrPreloadedItems		:Array = [];
		public var arrDemmandItems			:Array = [];
		public var arrIgnoredItems			:Array = [];
		
		public var arrAmbientes				:Array = [];
		
		public var xmllInfoMain				:XMLList = new XMLList();
		//
		public var libPreloader				:Library = new Library("PreloadedLibrary");
		//
		public function Preloader(pXMLPath:String,pIgnoreErrors:Boolean = true)
		{			
			prdThis = this;
			
			
			//finding current path
			if(Capabilities.playerType == 'PlugIn' || Capabilities.playerType == 'ActiveX'){
				//browser
				strPathBase = "";
			}else {
				//local
				strPathBase = "../";
			}
			//
			pXMLPath = StringUtils.basicReplace(pXMLPath,"{root}",strPathBase);
			//
			strXMLPath =  pXMLPath;
			isIgnoreErrors = pIgnoreErrors;
		}
		
		public function setup():void {
			//
			SWFAddress.onInit = function():void {
				xmlLoader = new URLLoader();
				xmlLoader.load(new URLRequest(strXMLPath)); // xmlLoader = BasicLoader.loadXML(strXMLPath,onCompleteLoadingXML);
				xmlLoader.addEventListener(Event.COMPLETE,onCompleteLoadingXML);
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,onErrorLoadingXML);
			}
		}
		
		public function startPreloading():void {
			//
			dispatchEvent(new PreloaderEvent(PreloaderEvent.START_PRELOADING,numPorcentagemGeral,arrPreloadedItems[intCurrentItem]));
			//
			loadNextItem();
			//
			hasStartedPreloading = true;
		}
		
		public function addItemToLoad(pItemPath:String,pItemName:String,pItemType:String,pInfoObj:Object=null):void {

			var _strFileType:String = StringUtils.extractFileExtension(pItemPath);
			var _isBin:Boolean = false;
			if(_strFileType=="jpg" || _strFileType=="swf" || _strFileType=="png") _isBin = true;
			
			if((String(pInfoObj.loadingType)=="preloaded") || (String(pInfoObj.loadingType)=="demmand" && pItemType==PreloaderItemType.AREA && pItemName==strIDOpeningArea)) {
				//if the item must be preloaded or is on demmand but is the entrance area of the main
				arrPreloadedItems.push({path:pItemPath,name:pItemName,loadingType:pItemType,info:pInfoObj,isBin:_isBin});
			}else if(String(pInfoObj.loadingType)=="demmand"){
				arrDemmandItems.push({path:pItemPath,name:pItemName,loadingType:pItemType,info:pInfoObj,isBin:_isBin});
			}
		}
		
		public function addIgnoredItem(pItemPath:String,pItemName:String,pItemType:String,pInfoObj:Object=null):void {
			arrIgnoredItems.push({path:pItemPath,name:pItemName,loadingType:pItemType,info:pInfoObj});
		}
		
		public function dispose():void {
			arrPreloadedItems = [];
		}
		
		//COMMANDS
		public function configGeneralAt(pDspContainer:DisplayObjectContainer):void {
			//
			var clsMainClass:Class = ClassUtils.getClassByMovieLoaded(libPreloader.getItemFromGroup("General",PreloaderItemType.MAIN),xmlMain..main["class"]);
			var sprMainFounded:DisplayObject = new clsMainClass();
			var clsGeneralClass:Class = sprMainFounded.loaderInfo.applicationDomain.getDefinition(getQualifiedClassName(sprMainFounded)) as Class //ClassUtils.getClassByObject(sprMain,sprMain);
			var sprGeneralFinal:DisplayObject = new clsGeneralClass();
			//
			try {
				sprGeneralFinal["config"](prdThis);
			}catch(e:Error){
				throw new Error(e.message,e.errorID);
			}
			//
			pDspContainer.addChild(sprGeneralFinal);
		}
		
		//INTERNALS
		private function loadNextItem():void {
			
			var obj:Object = arrPreloadedItems[intCurrentItem];
			//
			if(obj.isBin) {
				var ld:Loader = new Loader();
				var cxt:LoaderContext = new LoaderContext();
				cxt.applicationDomain = ApplicationDomain.currentDomain;
				ld.load(new URLRequest(obj.path),cxt);
				//
				ld.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onItemProgress);
				ld.contentLoaderInfo.addEventListener(Event.INIT,onItemComplete);
				ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onItemError);
				//
			}else {
				var ldURL:URLLoader = new URLLoader();
				ldURL.load(new URLRequest(obj.path));
				//
				ldURL.addEventListener(ProgressEvent.PROGRESS,onItemProgress);
				ldURL.addEventListener(Event.COMPLETE,onItemComplete);
				ldURL.addEventListener(IOErrorEvent.IO_ERROR,onItemError);
			}
			dispatchEvent(new PreloaderEvent(PreloaderEvent.ITEM_START,numPorcentagemGeral,arrPreloadedItems[intCurrentItem]));
		}
		private function onQueueProgress():void {
			//
			dispatchEvent(new PreloaderEvent(PreloaderEvent.PROGRESS_PRELOADING,numPorcentagemGeral,arrPreloadedItems[intCurrentItem]));
		}
		
		private function onQueueComplete():void {
			//
			dispatchEvent(new PreloaderEvent(PreloaderEvent.FINISH_PRELOADING,numPorcentagemGeral,arrPreloadedItems[intCurrentItem]));
		}
		//
		private function onItemProgress(e:ProgressEvent):void {
			//
			numPorcentagemGeral = (e.bytesLoaded * 100 / e.bytesTotal) / arrPreloadedItems.length + (intCurrentItem * 100 / arrPreloadedItems.length);
			//
			onQueueProgress();
			//
			dispatchEvent(new PreloaderEvent(PreloaderEvent.ITEM_PROGRESS,numPorcentagemGeral,arrPreloadedItems[intCurrentItem],(e.bytesLoaded / e.bytesTotal)*100));
		}
		private function onItemComplete(e:Event):void {
			//
			dispatchEvent(new PreloaderEvent(PreloaderEvent.ITEM_COMPLETE,numPorcentagemGeral,arrPreloadedItems[intCurrentItem]));
			//
			//adding item to the right group of the main library
			if(arrPreloadedItems[intCurrentItem].isBin) {
				arrPreloadedItems[intCurrentItem].item = e.currentTarget.loader.content;
			}else {
				arrPreloadedItems[intCurrentItem].item = e.currentTarget.data;
			}
			libPreloader.addItemToGroup(arrPreloadedItems[intCurrentItem].name,arrPreloadedItems[intCurrentItem].item,arrPreloadedItems[intCurrentItem].loadingType); //.addGroupToLibrary(xmlListMain.loadingType);
			//
			if(intCurrentItem<arrPreloadedItems.length-1){
				//
				intCurrentItem++;
				loadNextItem();
			}else {
				//queue finished
				onQueueComplete();
			}
		}
		private function onItemError(e:Event):void {
			//
			if(isIgnoreErrors){
				if(intCurrentItem+1<arrPreloadedItems.length-1){
					intCurrentItem++;
					loadNextItem();
				}else {
					onQueueComplete();
				}
			}else {
				throw new Error("Swf não encontrado:"+arrPreloadedItems[intCurrentItem].info.path);
			}
			//
			dispatchEvent(new PreloaderEvent(PreloaderEvent.ITEM_ERROR,numPorcentagemGeral,arrPreloadedItems[intCurrentItem]));
		}
		//EVENTS
		private function onErrorLoadingXML(e:IOErrorEvent):void
		{			
			throw new IOError("XML de preloading não encontrado:"+strXMLPath);
		}
		
		private function onCompleteLoadingXML(e:Event):void
		{		
			xmlLoader.removeEventListener(Event.COMPLETE,onCompleteLoadingXML);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onErrorLoadingXML);
			//
			var strXMLFilter:String = StringUtils.basicReplace((e.currentTarget.data).toString(),"{root}",strPathBase);
			xmlMain = new XML(strXMLFilter);
			strXMLFilter = StringUtils.basicReplace((e.currentTarget.data).toString(),"{url}",xmlMain..main.url);
			xmlMain = new XML(strXMLFilter);
			//
			
			//parsing the preloader config
			var xmlListMain:XMLList = xmlMain..main;
			xmllInfoMain = xmlListMain;
			xmlListAreas = xmlMain..areas.area;
			var xmlListAssets:XMLList = xmlMain..assets.item;
			//
			if(strIDOpeningArea==""){
				//if we don't have any area seted to open
				if(SWFAddress.getPathNames()[0]!=undefined || SWFAddress.getPathNames()[0]=="" || SWFAddress.getPathNames()[0]=="/") {
					strIDOpeningArea = SWFAddress.getPathNames()[0];					
				}else {
					strIDOpeningArea = String(xmlListMain.initialAreaName);
				}
			}
			//
			addItemToLoad(xmlListMain.path,xmlListMain.name,PreloaderItemType.MAIN,xmlListMain);			
			
			//configuring the library that the preloader will send to main
			libPreloader.addGroupToLibrary(PreloaderItemType.MAIN);
			libPreloader.addGroupToLibrary(PreloaderItemType.AREA);
			libPreloader.addGroupToLibrary(PreloaderItemType.ASSET);
			
			//areas
			for (var i:int = 0; i < xmlListAreas.length(); i++)
			{
				if(String(xmlListAreas[i].ignore)=="true"){
					//item será ignorado para fazer o preloading
					addIgnoredItem(xmlListAreas[i].path,xmlListAreas[i].name,PreloaderItemType.AREA,xmlListAreas[i]);
				}else {
					if(String(xmlListAreas[i].type).indexOf("content")!=-1) addItemToLoad(xmlListAreas[i].path,xmlListAreas[i].name,PreloaderItemType.AREA,xmlListAreas[i]);
					//
					arrAmbientes.push(xmlListAreas[i]);
				}
				
			}
			
			//assets
			for (i = 0; i < xmlListAssets.length(); i++)
			{
				if(String(xmlListAssets[i].ignore)=="true"){
					//item será ignorado para fazer o preloading
					addIgnoredItem(xmlListAssets[i].path,xmlListAssets[i].name,PreloaderItemType.ASSET,xmlListAssets[i]);
				}else {
					addItemToLoad(xmlListAssets[i].path,xmlListAssets[i].name,PreloaderItemType.ASSET,xmlListAssets[i]);
				}
			}
			 
			if(xmllInfoMain.ua!="" || xmllInfoMain.ua){
				//verificando se existe uma tag de analytics principal para o projeto
				var modAnalytics:AnalyticsModule = new AnalyticsModule("UA-26610153-1",this,false);
				TrackingControl.addTrackingModule(modAnalytics.ID,modAnalytics);
			}
			
			//onPreloaderSetup(new PreloaderEvent(PreloaderEvent.SETUP,numPorcentagemGeral,arrPreloadedItems[intCurrentItem]));
			dispatchEvent(new PreloaderEvent(PreloaderEvent.SETUP,numPorcentagemGeral,arrPreloadedItems[intCurrentItem]));
		}
	}
}