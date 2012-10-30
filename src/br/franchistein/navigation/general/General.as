package br.franchistein.navigation.general {
	
	import br.franchistein.display.SpriteDestroy;
	import br.franchistein.navigation.area.Ambient;
	import br.franchistein.navigation.area.AreaType;
	import br.franchistein.navigation.controller.Controller;
	import br.franchistein.navigation.controller.ControllerEvent;
	import br.franchistein.navigation.debug.NavigationMode;
	import br.franchistein.navigation.library.Library;
	import br.franchistein.navigation.menu.AbstractMenuButton;
	import br.franchistein.navigation.menu.Menu;
	import br.franchistein.navigation.modal.AbstractModal;
	import br.franchistein.navigation.preloader.Preloader;
	import br.franchistein.navigation.preloader.PreloaderItemType;
	import br.franchistein.sound.SoundDispatcher;
	import br.franchistein.tracking.TrackingControl;
	import br.franchistein.utils.ArrayUtils;
	import br.franchistein.utils.ClassUtils;
	import br.franchistein.utils.DisplayUtils;
	import br.franchistein.utils.StringUtils;
	
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public dynamic class General extends Controller implements IEventDispatcher
	{
		public var genThis						:General;
						
		public var libGeneral					:Library;
		
		public var prdReference					:Preloader
						
		//FULLSCREEN
		public var isFullscreen					:Boolean = false;
		
		public var movFullScreen				:DisplayObject;
		
		private var objFullscreen				:Object = {};
		
		//MODAL
		public var isModalOpened				:Boolean = false;
		
		private var movModal					:AbstractModal;
		
		//AMBIENT SOUND CONTROLLER
		public var isSoundEnabled				:Boolean = true;		
		public var isSoundPlaying				:Boolean = false;
		
		private var stfSomAmbiente				:SoundTransform = new SoundTransform(0);
		private var schCanalAmbiente			:SoundChannel = new SoundChannel();
		private var sndAmbiente					:Sound;
		
		/**
		 * General Controller Engine
		 * @author Caio Franchi
		 * @version 0.3b 
		 */
		
		public function General()
		{			
			super();
			
			genThis = this;
		}
		
		//SETTINGS
		public override function init(e:Event=null):void {
			//
			genThis.removeEventListener(Event.ADDED_TO_STAGE , init)
			//
			setup();
			//
			dispatchEvent(new GeneralEvent(GeneralEvent.READY));
		}
		
		private function setup():void {
			//setting application`s main timeline	
			GeneralConfig.GENERAL = genThis;
			GeneralConfig.STAGE = genThis.stage;
			GeneralConfig.DEFAULT_AREA = prdReference.xmllInfoMain.initialAreaName;			
			GeneralConfig.FLASH_VARS = genThis.loaderInfo.parameters;
			//getting base url from current application
			GeneralConfig.URL = NavigationMode.getBaseURL(genThis);
			if(String(prdReference.xmllInfoMain.url)!=null) GeneralConfig.URL = NavigationMode.processPath(String(prdReference.xmllInfoMain.url));
			
			//assigning preloader vars
			var _intLength:int = prdReference.xmllInfoMain.elements().length();
			for(var i:int=0;i<_intLength;i++){
				GeneralConfig.PRELOADER_VARS[prdReference.xmllInfoMain.elements()[i].name()] = prdReference.xmllInfoMain.elements()[i].toString();
			}
			
			//caso venha com uma UA, prepara o módulo de analytics
			if(GeneralConfig.PRELOADER_VARS.ua!=null) {				
				TrackingControl.execute("GA","pageView","/IniciaSite");
			}
				
										
			//Finding the application path
			if(NavigationMode.discover()==NavigationMode.BROWSER){
				//browser
				GeneralConfig.ROOT = "";
			}else {
				//local
				GeneralConfig.ROOT = "../";	
			}
			
			//populando os ambientes carregados pelo XML
			//TODO: esse bloco de codigo deve estar disponivel na controller e não na General
			for (i = 0; i < prdReference.arrAmbientes.length; i++)
			{
				var ambConfigurar:Ambient = new Ambient();
				//
				ambConfigurar.id = prdReference.arrAmbientes[i].name;
				ambConfigurar.type = prdReference.arrAmbientes[i].type;				
				ambConfigurar.path = prdReference.arrAmbientes[i].path;
				ambConfigurar.className = prdReference.arrAmbientes[i]["class"];
				ambConfigurar.url = prdReference.arrAmbientes[i].url;
				ambConfigurar.tag = prdReference.arrAmbientes[i].tag;
				ambConfigurar.isPermalinkEnabled = (String(prdReference.arrAmbientes[i].permalink)=="true") ? true : false;
				
				/*//TODO: Mapear todas as propriedades que estiverem nos nos de ambientes, para cada ambiente.
				var xmlListTeste:XMLList = arrAmbientes[i];
				xmlListTeste.*/
				
				try{
					if(String(prdReference.arrAmbientes[i].menu)!="") ambConfigurar.menu = DisplayUtils.findInside(String(prdReference.arrAmbientes[i].menu),genThis) as Menu;
					if(String(prdReference.arrAmbientes[i].button)!="") ambConfigurar.button = ambConfigurar.menu.getChildByName(String(prdReference.arrAmbientes[i].button)) as AbstractMenuButton
				}catch(e:Error){
					throw new Error("Erro ao tentar configurar menu na general:"+ambConfigurar.id+". Erro:"+e.message)
				}				
					
				if(prdReference.arrAmbientes[i].loadingType == "loaded" || prdReference.arrAmbientes[i].loadingType== "preloaded"){
					ambConfigurar.area =  ClassUtils.getClassByMovieLoaded(genThis,ambConfigurar.className);
				}else if (prdReference.arrAmbientes[i].loadingType== "preloaded"){
					//itens ja estao carregados, atribuindo as classes
					ambConfigurar.area =  ClassUtils.getClassByMovieLoaded(prdReference.libPreloader.getItemFromGroup(ambConfigurar.id,PreloaderItemType.AREA) as DisplayObject,ambConfigurar.className);
					//
				} else if (prdReference.arrAmbientes[i].loadingType== "demmand"){
					//"external-saved-content";	"external-loadable-content";
					ambConfigurar.loaded = false;
					
					if(prdReference.arrAmbientes[i].type=="external-loadable-content") {
					
					}else if (prdReference.arrAmbientes[i].type=="external-saved-content"){
					
					}
				}
				//
				addAmbient(ambConfigurar,(ambConfigurar.id == prdReference.xmllInfoMain.initialAreaName ? true : false));
			}
			
			//
			genThis.stage.addEventListener(Event.RESIZE,onResizeSite);
			genThis.stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFullScreen);	
			
		}
		
		public override function open(pStrOpenAmbient:String=null):void {
			//
			startNavigation();
		}
		
		public override function close():void {
			
		}
		
		//STARTING		
		public function startAmbienteSound(pClass:Class):void {
			sndAmbiente = new pClass();
			//
			playSound();
		}
		
		public function startNavigation(pStrAreaAbrir:String=""):void {
			if(pStrAreaAbrir!="") GeneralConfig.DEFAULT_AREA = pStrAreaAbrir;
			//
			onResizeSite();
			//
			if(String(prdReference.xmllInfoMain.permalink)=="true"){
				//Caso a GENERAL tenha swfAddress no geral
				configSWFAddress();
			}else {
				//caso não tenha
				if(arrAmbientes.length>0) openArea(GeneralConfig.DEFAULT_AREA);
			}
		}		
		
		//Main function for area opening ( any kind of )
		public override function openArea(pStringName:String):void {
			var _arrSplit:Array = pStringName.split("/");
			var _numIndiceAtivar:Number = ArrayUtils.returnIndexByParam(_arrSplit[0],"id",arrAmbientes);
			var ambAtivar:Ambient = arrAmbientes[_numIndiceAtivar] as Ambient;
			
			//TODO: Verify if the area that is being opened is already opened
			//TODO: deixar que o swf address seja opcional
			arrNavigationHistory.push(ambAtivar);
			//
			dispatchEvent(new ControllerEvent(ControllerEvent.OPEN_AMBIENT,ambAtivar));
			//
			switch(ambAtivar.type){
				case AreaType.URL:
					//CASO SEJA UMA URL
					if(ambAtivar.tag!=null) TrackingControl.execute("GA","pageView",ambAtivar.tag);				
					navigateToURL(new URLRequest(ambAtivar.path),"_blank"); //link
					//
					break;
				case AreaType.JAVASCRIPT:
					//CASO SEJA UM JAVASCRIPT
					if(ambAtivar.tag!=null) TrackingControl.execute("GA","pageView",ambAtivar.tag);		
					navigateToURL(new URLRequest(ambAtivar.path),"_self"); //javascript
					break;
				case AreaType.NONE:
						return;
					break;
				default:
					if(ambAtivar.isPermalinkEnabled){						
						//internal or external content
						SWFAddress.setValue("/"+pStringName);	
					}else {						
						//Pegando o caminho restante e mandando no formato da outra função
						_arrSplit.shift();
						ativaAmbiente(_numIndiceAtivar,StringUtils.basicReplace(_arrSplit.toString(),",","/"));
					}
					
					break;
			}
		}
		
		//MODALS
		public function openModal(pClsModal:Class,...params):void {
			if(isModalOpened) return;
			
			DisplayUtils.lockDisplayObject(genThis);
			//

			isModalOpened = true
				
			//Passando uma quantidade dinâmica de parâmetros para a construtora
			params.unshift(pClsModal);
			//
			movModal = ClassUtils.generateDynamicConstructor.apply(null,params); //new pClsModal.apply(null,params); //params[0]
			movModal.open();
			//
			genThis.pause();
			areaConteudoAtual.pause();
			//
			GeneralConfig.STAGE.addChild(movModal);
			//
			dispatchEvent(new GeneralEvent(GeneralEvent.OPEN_MODAL));
		}
		
		public function closeModal():void {
			isModalOpened = false;

			//
			areaConteudoAtual.resume();
			genThis.resume();
			movModal.close();			
			//movModal = null
			DisplayUtils.unlockDisplayObject(genThis);
			//
			dispatchEvent(new GeneralEvent(GeneralEvent.CLOSE_MODAL));
		}
		
		//FULLSCREEN
		public function openFullScreen(pMovToOpen:DisplayObject=null,pRectSource:Rectangle=null):void {
			if(isFullscreen && pMovToOpen==movFullScreen) return;
			//
			objFullscreen = new Object();
			movFullScreen = pMovToOpen;
			
			//<< O ALINHAMENTO DOS OBJETOS, CASO ESTEJA COMO ALIGN CENTER (PADRAO), NAO FUNCIONA CORRETAMENTE COM FULLSCREEN
			objFullscreen.align = genThis.stage.align;
			
			genThis.stage.displayState = StageDisplayState.FULL_SCREEN
			genThis.stage.align = StageAlign.TOP_LEFT 
			//
			isFullscreen = true;		
			
			if(movFullScreen!=null) {
				//caso esteja vindo um movie pra ser fullscreen
				genThis.visible = false;
				objFullscreen.numOriginalX = movFullScreen.x
				objFullscreen.numOriginalY = movFullScreen.y
				objFullscreen.numOriginalHeight = movFullScreen.height
				objFullscreen.numOriginalWidth = movFullScreen.width;
				objFullscreen.numChildIndex = (movFullScreen.parent).getChildIndex(movFullScreen);
				
				objFullscreen.movOriginalContainer = movFullScreen.parent as DisplayObjectContainer
													
				movFullScreen.width = genThis.stage.stageWidth-50	
				movFullScreen.height = genThis.stage.stageHeight-50
					
//				movFullScreen.x = (genThis.stage.stageWidth-movFullScreen.width)/2 
//				movFullScreen.y = (genThis.stage.stageHeight-movFullScreen.height)/2
				//
				//movThis.stage.scaleMode = StageScaleMode.EXACT_FIT;
				genThis.stage.addChild(movFullScreen);
			}else if (pRectSource!=null){
				//caso seja um source rect
				GeneralConfig.STAGE.fullScreenSourceRect = pRectSource;
			}
			//
			if(movModal!=null) movModal.visible = false;
			//
			dispatchEvent(new GeneralEvent(GeneralEvent.OPEN_FULLSCREEN));
			
		}
		
		public function closeFullScren():void {
			//			
			genThis.stage.displayState = StageDisplayState.NORMAL
			genThis.stage.align = objFullscreen.align;
			//
			if(isFullscreen && movFullScreen) {
				//volta a estrutura antiga
				genThis.visible = true;
				
				movFullScreen.x = objFullscreen.numOriginalX;
				movFullScreen.y = objFullscreen.numOriginalY;
				movFullScreen.width = objFullscreen.numOriginalWidth;
				movFullScreen.height = objFullscreen.numOriginalHeight;
				//
				if(movModal!=null) movModal.visible = true;
				isFullscreen = false
			
				objFullscreen.movOriginalContainer.addChildAt(movFullScreen,objFullscreen.numChildIndex)
				
				//
				dispatchEvent(new GeneralEvent(GeneralEvent.CLOSE_FULLSCREEN));		
			}
			//
			
			
		}
		
		//SOUND CONTROLS
		public function playSound(pNumSecond:Number=0,pNumVolume:Number=1):void {
			if(isSoundPlaying) return;
			schCanalAmbiente.soundTransform = stfSomAmbiente;
			schCanalAmbiente = sndAmbiente.play(pNumSecond,int.MAX_VALUE,stfSomAmbiente);
			
			changeVolume(pNumVolume);
			//
			isSoundPlaying = true;
			//
		}
		public function dropSound(pSoundClass:Class,pNumStarting:Number=0,pIntVolume:Number=1,pNumLoop:int=0):void {
			SoundDispatcher.basicLocalDispatch(pSoundClass,pNumStarting,pIntVolume,pNumLoop); //if(isSoundEnabled) 
		}
		public function stopSound():void {
			isSoundPlaying = false;
			mute();
			sndAmbiente.close();
		}
		public function changeVolume(pNumVolume:Number):void {
			if(!isSoundEnabled) return;
			TweenMax.to(stfSomAmbiente, 1, {volume:pNumVolume, onUpdate:function():void {
				schCanalAmbiente.soundTransform = stfSomAmbiente;						
			}});
		}
		public override function mute():void {
			changeVolume(0);
			isSoundEnabled = false;
			//
			try{
				areaConteudoAtual.mute();
			}catch(e:Error){}
			//
			dispatchEvent(new GeneralEvent(GeneralEvent.MUTE));
		}
		
		public override function unMute():void {
			isSoundEnabled = true;
			
			changeVolume(.4);
			//
			try{
				areaConteudoAtual.unMute();
			}catch(e:Error){}
			//
			dispatchEvent(new GeneralEvent(GeneralEvent.UNMUTE));
		}
		
		//PRIVATE
		private function configSWFAddress():void {
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE,onChangeAddress);
		}
		
		private function onChangeAddress(e:SWFAddressEvent):void {
			var _arrPaths:Array = e.pathNames;			
			var _strArea:String;
			var _strInterna:String = "";
			
			if(_arrPaths.length>0){
				//
				_strArea = _arrPaths[0];
				_arrPaths.shift()
				try {
					_strInterna = StringUtils.basicReplace(_arrPaths.toString(),",","/");
				}catch(e:Error){
					throw new Error("Erro ao tentar converter a chamada do swfaddress para o formato correto");
				}
			}else {
				//primeira abertura abre a área default
				_strArea = GeneralConfig.DEFAULT_AREA;
			}
			var _numIndiceAtivar:Number = ArrayUtils.returnIndexByParam(_strArea,"id",arrAmbientes);
			var _ambActivate:Ambient = arrAmbientes[_numIndiceAtivar] as Ambient;
			
			//
			if(_numIndiceAtivar!=-1) {
				//o ambiente esta cadastrado na array de ambientes
				ativaAmbiente(_numIndiceAtivar,_strInterna);
			}else {
				//ambiente nao encontrado
			}
			//
			dispatchEvent(new GeneralEvent(GeneralEvent.CHANGE_SWFADDRESS,_ambActivate));
		}
		private function onFullScreen(e:FullScreenEvent=null):void {
			if(isFullscreen){
				closeFullScren();
			}else {
				
			}
		}
		private function onResizeSite(e:Event=null):void {
			dispatchEvent(new GeneralEvent(GeneralEvent.ON_RESIZE));
			
			//aciona o alinhamento da área atual
			try {
				areaConteudoAtual.realign(e);
			} catch(e:Error){
				//GeneralConfig.debug("Problemas para alinhar a área atual,e.message);
			}
			
			//aciona o alinhamento do modal
			if(isModalOpened){
				try{
					movModal.realign(e);
				}catch(e:Error){}
			}
		}
		
		//Recebendo a chamada do preloader
		public function config(pPreloaderReference:Preloader=null):void {
			prdReference = pPreloaderReference;
			//
			genThis.addEventListener(Event.ADDED_TO_STAGE , init)
		}
		/*
		//EVENT DISPATCHER
		override public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
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
