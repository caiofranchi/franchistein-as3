package br.franchistein.player
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class Player implements IEventDispatcher
	{
		private var arrItems					:Array = new Array();
		
		private var numIntervalo				:Number;
			
		private var intLoadingType				:int;			
		private var intCurrentItemActivated		:int;
		private var intCurrentLoadingItem		:int = 0;	
		
		private var dispatcher					:EventDispatcher;
		
		private var isSlideShow					:Boolean = true;
		
		/*
		 * @author Caio Franchi
		 * @version 0.1 Beta 
		 */
		public function Player(pLoadingType:int,pArrItens:Array=null)
		{	
			if(pArrItens!=null) this.itens = pArrItens;
			dispatcher = new EventDispatcher(this);
			intLoadingType = pLoadingType;
		}
		//LOADING
		public function startLoading(pIntItemToActive:int=0):void {
			loadItem();
			/* switch(intLoadingType){
				case PlayerLoadingType.LOAD_ALL_BEFORE:
				break;
				case PlayerLoadingType.LOAD_LIST:
					loadItem(0);
					//
				break;
				case PlayerLoadingType.LOAD_ALL:
					
					//
				break;
				case PlayerLoadingType.LOAD_ON_DEMMAND:
				break;
			} */
		}
		public function startNavigation():void {
			selectItem(0)
			if(isSlideShow) startSlideshowTimer()
		}		
		//NAVIGATION
		public function startSlideshowTimer():void {
			if(arrItems.length<2) return;
			clearTimeout(numIntervalo);
			numIntervalo = setTimeout(nextItem,arrItems[intCurrentItemActivated].time*1000);
		}
		public function stopSlideshowTimer():void {
			clearTimeout(numIntervalo);
		}
		public function selectItem(pIntIndex:int=0,pIsTheNext:Boolean=true):Boolean {
			intCurrentItemActivated = pIntIndex;
			stopSlideshowTimer();
			
			if(arrItems[intCurrentItemActivated].isLoaded) startSlideshowTimer();
			
			dispatcher.dispatchEvent(new PlayerEvent(PlayerEvent.CHANGE_BANNER, arrItems[intCurrentItemActivated],  0, intCurrentItemActivated,pIsTheNext));
			
			return true
		}
		public function nextItem():Boolean {
			var _intFuturo:int = intCurrentItemActivated+1;
			if(_intFuturo>arrItems.length-1) _intFuturo = 0;
			selectItem(_intFuturo,true);
			return true;
		}
		public function previousItem():Boolean {
			var _intFuturo:int = intCurrentItemActivated-1;
			if(_intFuturo<0) _intFuturo = arrItems.length-1;
			selectItem(_intFuturo,false);
			return true;
		}
		//
		public function removeItem(pIntIndex:int):void {
		
		}
		public function addItem(pObjItem:Object,pIntIndex:int=-1):void {
			if(pIntIndex==-1){
				arrItems.push(pObjItem);
				loadItem(arrItems.length-1);
			}else {
				//
			}
			
		}
		public function dispose():void {
			stopSlideshowTimer();
		}
		//GETTERS & SETTERS
		public function get numSelectedItem():int {
			return intCurrentItemActivated;
		}
		public function get itens():Array {
			return arrItems;
		}
		public function set itens(pArrItens:Array):void {
			arrItems = pArrItens;
		}
		public function get slideshow():Boolean {
			return isSlideShow;
		}
		public function set slideshow(pIsSlideshow:Boolean):void {
			isSlideShow = pIsSlideshow;
			if(isSlideShow) startSlideshowTimer();
			else stopSlideshowTimer();
		}
		//INTERNAS
		private function loadItem(pIntItemToLoad:int=0):void {
			intCurrentLoadingItem = pIntItemToLoad;
			//
			var ldItemLoad:Loader = new Loader();
			ldItemLoad.name = intCurrentLoadingItem.toString(); 
			var loaderContext:LoaderContext = new LoaderContext(true);
			ldItemLoad.load(new URLRequest(arrItems[intCurrentLoadingItem].archive),loaderContext);
			
			ldItemLoad.contentLoaderInfo.addEventListener(Event.INIT,onItemLoadingComplete);
			ldItemLoad.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onItemLoadingError);
			ldItemLoad.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onItemLoadingProgress);
			//
			arrItems[intCurrentLoadingItem].loader = ldItemLoad;
			//if the list is being loaded all in the same time
			//if(intLoadingType==PlayerLoadingType.LOAD_LIST && intCurrentLoadingItem+1<arrItems.length-1) loadItem(intCurrentLoadingItem+1);
		}
		private function onItemLoadingError(e:IOErrorEvent):void {
			dispatcher.dispatchEvent(new PlayerEvent(PlayerEvent.BANNER_ERROR, arrItems[intCurrentLoadingItem],  0, intCurrentLoadingItem));
			//não encontrou o item, passa pro próximo
			verifyNext();
		}
		private function onItemLoadingComplete(e:Event):void {
			//
			var _ldAtual:Loader = e.target.loader as Loader;
			var _intCurrentLoadingItem:int = intCurrentLoadingItem//int(_ldAtual.name);
			arrItems[_intCurrentLoadingItem].isLoaded = true;
			arrItems[_intCurrentLoadingItem].content = _ldAtual.content;
			//
			_ldAtual.contentLoaderInfo.removeEventListener(Event.INIT,onItemLoadingComplete);
			_ldAtual.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onItemLoadingProgress);
			_ldAtual.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onItemLoadingError);
			//
			dispatcher.dispatchEvent(new PlayerEvent(PlayerEvent.BANNER_COMPLETE, arrItems[_intCurrentLoadingItem],  0, _intCurrentLoadingItem));
			
			if(_intCurrentLoadingItem==0 && !intLoadingType==PlayerLoadingType.LOAD_ALL_BEFORE) startNavigation();
			
			//carrega o próximo
			verifyNext();
		}
		private function onItemLoadingProgress(e:ProgressEvent):void {
			//var _ldAtual:Loader = e.target.loader as Loader;
			var _intCurrentLoadingItem:int = intCurrentLoadingItem//int(_ldAtual.name);
			var _numPorcentagemAtual:Number =(e.bytesLoaded / e.bytesTotal) * 100
			var _queuepercentage:Number = (e.bytesLoaded * 100 / e.bytesTotal) / arrItems.length + (_intCurrentLoadingItem * 100 / arrItems.length);
			//_queuepercentage /= 100;
			//
			arrItems[_intCurrentLoadingItem].bytesLoaded = e.bytesLoaded
			arrItems[_intCurrentLoadingItem].bytesTotal = e.bytesTotal
			arrItems[_intCurrentLoadingItem].percentage = _numPorcentagemAtual;
			//
			dispatcher.dispatchEvent(new PlayerEvent(PlayerEvent.BANNER_PROGRESS, arrItems[_intCurrentLoadingItem],  _queuepercentage, _intCurrentLoadingItem));			
		}
		private function verifyNext():void {
			if(intCurrentLoadingItem+1<arrItems.length) loadItem(intCurrentLoadingItem+1);
			else dispatcher.dispatchEvent(new PlayerEvent(PlayerEvent.QUEUE_COMPLETE, arrItems[intCurrentLoadingItem],  100, intCurrentLoadingItem));
		}
		// Implemented interface methods
		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function dispatchEvent(evt : Event) : Boolean {
			return dispatcher.dispatchEvent(evt);
		}

		public function hasEventListener(type : String) : Boolean {
			return dispatcher.hasEventListener(type);
		}

		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger(type : String) : Boolean {
			return dispatcher.willTrigger(type);
		}
		
	}
}