package br.franchistein.navigation.controller {
	
	import br.franchistein.navigation.area.Ambient;
	import br.franchistein.navigation.area.Area;
	import br.franchistein.navigation.area.AreaEvent;
	import br.franchistein.navigation.area.AreaType;
	import br.franchistein.navigation.debug.NavigationMode;
	import br.franchistein.navigation.menu.AbstractMenuButton;
	import br.franchistein.navigation.menu.Menu;
	import br.franchistein.tracking.TrackingControl;
	import br.franchistein.utils.ArrayUtils;
	import br.franchistein.utils.ClassUtils;
	import br.franchistein.utils.DisplayUtils;
	import br.franchistein.utils.StringUtils;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public dynamic class Controller extends Area implements IEventDispatcher
	{
		public var ctrThis						:Controller;
		
		public var arrAmbientes					:Array = [];
		public var arrNavigationHistory			:Array = [];
		
		public var numAreaAnterior				:Number = -1;
		public var numAreaAtivada				:Number = -1;
		public var numAreaAtivar				:Number = -1;
		
		public var strInternaAtiva				:String = "";
		private var strAreaDefault				:String;
		
		private var ldAreaLoader				:Loader = new Loader();
						
		public var areaConteudoAtual			:Area;
		public var ambAtual						:Ambient;
		
		public var isFirstEntrance				:Boolean = true;
		
		protected var dispatcher				:EventDispatcher = new EventDispatcher();
		
		public var mnuPrincipal					:Menu;
		
		/**
		 * Default Ambient Controller Engine
		 * @author Caio Franchi
		 * @version 0.1b 
		 */
		
		public function Controller()
		{
			ctrThis = this;
			
			//
			//ctrThis.addEventListener(Event.ADDED_TO_STAGE , init)
		}
		
		//SETTINGS
		public function init(e:Event=null):void {
			/*ctrThis.removeEventListener(Event.ADDED_TO_STAGE , init)
			//
			dispatchEvent(new ControllerEvent(ControllerEvent.READY));*/
		}	
		
		//navig
		public override function open(pStrOpenAmbient:String=null):void {
					
		}
		
		public override function close():void {
			
			dispose();			
		}
				
		//ambient controller
		public function addAmbient(pAreaAdd:Ambient,pIsInicial:Boolean=false):void {
			arrAmbientes.push(pAreaAdd);	
			
			//setando o menu referente ao ambiente
			if(pAreaAdd.button!=null && pAreaAdd.menu!=null){
				var mnuConfigurar:Menu = pAreaAdd.menu;
				var btnMenuConfigurar:AbstractMenuButton = pAreaAdd.button;
				btnMenuConfigurar.id = pAreaAdd.id
				btnMenuConfigurar.setClickAction(onClickMenu,btnMenuConfigurar.id);
				//
				mnuConfigurar.addMenuItem(btnMenuConfigurar);				
			}
			
			
			//
			if(pIsInicial){				
				strAreaDefault = pAreaAdd.id;
			}
		}		
		
		public function removeAmbient():void {
			//TODO: Desenvolver função de remoção
		} 
		
		public function openArea(pStringName:String):void {
			var _arrSplit:Array = pStringName.split("/");
			var _numIndiceAtivar:Number = ArrayUtils.returnIndexByParam(_arrSplit[0],"id",arrAmbientes);
			var areaAtivar:Ambient = arrAmbientes[_numIndiceAtivar] as Ambient;
			
			//TODO: Verify if the area that is being opened is already opened
			//TODO: deixar que o swf address seja opcional
			arrNavigationHistory.push(areaAtivar);
			//
			dispatchEvent(new ControllerEvent(ControllerEvent.OPEN_AMBIENT,areaAtivar));
			//
			switch(areaAtivar.type){
				case AreaType.URL:
					//CASO SEJA UMA URL
					if(areaAtivar.tag!=null) TrackingControl.execute("GA","pageView",areaAtivar.tag);					
					navigateToURL(new URLRequest(areaAtivar.path),"_blank"); //link
					//
					break;
				case AreaType.JAVASCRIPT:
					//CASO SEJA UM JAVASCRIPT
					if(areaAtivar.tag!=null) TrackingControl.execute("GA","pageView",areaAtivar.tag);
					navigateToURL(new URLRequest(areaAtivar.path),"_self"); //javascript
					break;
				case AreaType.FUNCTION:
					//CASO CHAMA UMA FUNÇÃO
					if(areaAtivar.tag!=null) TrackingControl.execute("GA","pageView",areaAtivar.tag);
					ctrThis[areaAtivar.path]();
					break;
				case AreaType.NONE:
					return;
					break;
				default:
					//internal or external content
					_arrSplit.shift();
					ativaAmbiente(_numIndiceAtivar,StringUtils.basicReplace(_arrSplit.toString(),",","/"));					
					//
					break;
			}
		}
		
		public function closeArea():void {
			areaConteudoAtual.close();		
			numAreaAtivada = -1;
		}
		
		public function openLastArea():void {
			if(arrAmbientes[numAreaAnterior]!=null) openArea(arrAmbientes[numAreaAnterior].id);
		}
				
		//AREA LOADING
		//TODO:Add library dependencies
		private function startLoadingArea(pAmbAtivar:Ambient):void {
			//
			var _ambAtivar:Ambient = pAmbAtivar;
			//
			ldAreaLoader.load(new URLRequest(NavigationMode.processPath(_ambAtivar.path)))
			//
			dispatchEvent(new ControllerEvent(ControllerEvent.LOADING_AREA_START,arrAmbientes[numAreaAtivar]));
			//
			ldAreaLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgressAreaLoading);
			ldAreaLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleteLoadingArea);
		}

		private function onCompleteLoadingArea(e:Event):void
		{
			ldAreaLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgressAreaLoading);
			ldAreaLoader.contentLoaderInfo.removeEventListener(Event.INIT,onCompleteLoadingArea);
			//
			var movArea:MovieClip = (ldAreaLoader.contentLoaderInfo.content as MovieClip).getChildAt(0) as MovieClip;		
			var clsArea:Class = ClassUtils.getClassByObject(movArea,movArea);
			arrAmbientes[numAreaAtivar].area =  clsArea;
			
			
			arrAmbientes[numAreaAtivar].loaded = true;
			//
			ativaAmbiente(numAreaAtivar,strInternaAtiva);
			
			//caso a area carregada nao deva ficar salva no sistema
			if(arrAmbientes[numAreaAtivar].type==AreaType.EXTERNAL_LOADABLE_CONTENT) arrAmbientes[numAreaAtivar].loaded = false;
			//
			dispatchEvent(new ControllerEvent(ControllerEvent.LOADING_AREA_COMPLETE,arrAmbientes[numAreaAtivar]));
		}
		
		private function onProgressAreaLoading(e:ProgressEvent):void {
			//
			arrAmbientes[numAreaAtivar].progress = (e.bytesLoaded / e.bytesTotal)*100;
			dispatchEvent(new ControllerEvent(ControllerEvent.LOADING_AREA_PROGRESS,arrAmbientes[numAreaAtivar]));
		}
		//
		protected function ativaAmbiente(pIndex:int,pInternaCarregar:String = ""):void {
			var _ambAtivar:Ambient = arrAmbientes[pIndex] as Ambient;
			//
			numAreaAtivar = pIndex;
			strInternaAtiva = pInternaCarregar;
			
			//deixando o menu selecionado
			try {
				if(_ambAtivar.menu!=null) _ambAtivar.menu.selectMenuItem(_ambAtivar.id);
			}catch(e:Error){
				throw new Error("Erro ao tentar ativar o menu;"+_ambAtivar.id)
			}
			//
			if(!_ambAtivar.loaded && (_ambAtivar.type==AreaType.EXTERNAL_SAVED_CONTENT || _ambAtivar.type==AreaType.EXTERNAL_LOADABLE_CONTENT)) {
				//if the area that is going to be activated is not yet loaded
				startLoadingArea(_ambAtivar);
				return;
			}
			
			//abrindo uma area interna
			if(numAreaAtivar==numAreaAtivada && pInternaCarregar!="") {
				//ESTÁ CARREGANDO UMA INTERNA DA ATUAL
				
				areaConteudoAtual["openArea"](pInternaCarregar); //ArrayUtils.returnIndexByParam(pInternaCarregar,"name",movConteudoAtual.arrAmbientes)
				
				return;
			}else if (numAreaAtivar==numAreaAtivada){
				//JÁ ESTA NA AREA PRINCIPAL ATIVA
				//return;
			}else {
				//TROCANDO DE ÁREA
				
			}
			
			if(arrAmbientes[numAreaAtivar].tag!=null && arrAmbientes[numAreaAtivar].tag!="")  {
				TrackingControl.execute("GA","pageView",arrAmbientes[numAreaAtivar].tag);
			}
			DisplayUtils.lockDisplayObject(ctrThis);
						
			//FECHANDO O CONTEUDO ATUAL
			if (numAreaAtivada>-1) {
				try {
					if(!areaConteudoAtual.hasEventListener(AreaEvent.CLOSE_TRANSITION_COMPLETE)) {
						areaConteudoAtual.addEventListener(AreaEvent.CLOSE_TRANSITION_COMPLETE,onCompleteClosingArea,false,0,true);
						areaConteudoAtual.addEventListener(AreaEvent.CLOSE_TRANSITION_START,onStartClosingArea,false,0,true);
					} 
					closeArea();					
				}catch(e:Error){
					iniciaAmbiente(numAreaAtivar,pInternaCarregar);
				}
			} else {
				iniciaAmbiente(numAreaAtivar,pInternaCarregar);
			}
			
			
		}
				
		private function iniciaAmbiente(pIndex:int,pInternaCarregar:String = ""):void {
			var _numIndiceAtivar:int = pIndex;
			var _numIndiceInterno:int = 0;
			//
			var ambAtivar:Ambient = arrAmbientes[_numIndiceAtivar] as Ambient;
			var clsAreaClass:Class = ambAtivar.area			
			areaConteudoAtual = new clsAreaClass();
			areaConteudoAtual.id = ambAtivar.id;
			ambAtual = ambAtivar;
			
			//ABRINDO A AREA
			if(!areaConteudoAtual.hasEventListener(AreaEvent.OPEN_TRANSITION_COMPLETE)) {
				areaConteudoAtual.addEventListener(AreaEvent.OPEN_TRANSITION_START,onStartOpeningArea,false,0,true);
				areaConteudoAtual.addEventListener(AreaEvent.OPEN_TRANSITION_COMPLETE,onCompleteOpeningArea,false,0,true);
			} 
			//
			areaConteudoAtual.realign();
			areaConteudoAtual.open(pInternaCarregar); //isFirstEntrance
			
			//
			numAreaAnterior = numAreaAtivada;
			numAreaAtivada = _numIndiceAtivar;
			isFirstEntrance = false;
		}
		
		//EVENTS
		private function onStartClosingArea(e:AreaEvent):void {
			areaConteudoAtual.removeEventListener(AreaEvent.CLOSE_TRANSITION_START,onStartClosingArea);
			//
			dispatchEvent(new AreaEvent(AreaEvent.CLOSE_TRANSITION_START,areaConteudoAtual));
			//
			
		}
		private function onCompleteClosingArea(e:AreaEvent):void {
			//TERMINOU DE FECHAR A AREA ATUAL
			areaConteudoAtual.removeEventListener(AreaEvent.CLOSE_TRANSITION_COMPLETE,onCompleteClosingArea);
			//
			dispatchEvent(new AreaEvent(AreaEvent.CLOSE_TRANSITION_COMPLETE,areaConteudoAtual));
			//
			if(ambAtual.type==AreaType.EXTERNAL_LOADABLE_CONTENT){
				if(NavigationMode.getMajorVersion()>=10) ldAreaLoader.unloadAndStop();
			}
			//
			iniciaAmbiente(numAreaAtivar,strInternaAtiva);			
			//
		}
		private function onCompleteOpeningArea(e:AreaEvent):void {
			//TERMINOU DE ABRIR A NOVA ÁREA
			areaConteudoAtual.removeEventListener(AreaEvent.OPEN_TRANSITION_COMPLETE,onCompleteOpeningArea);
			DisplayUtils.unlockDisplayObject(ctrThis);
			//
			dispatchEvent(new AreaEvent(AreaEvent.OPEN_TRANSITION_COMPLETE,areaConteudoAtual));	
			//
		}
		
		private function onStartOpeningArea(e:AreaEvent):void {
			//TERMINOU DE ABRIR A NOVA ÁREA
			//
			areaConteudoAtual.removeEventListener(AreaEvent.OPEN_TRANSITION_START,onStartOpeningArea);
			DisplayUtils.lockDisplayObject(ctrThis);
			//
			dispatchEvent(new AreaEvent(AreaEvent.OPEN_TRANSITION_START,areaConteudoAtual));
			//
		}
		//
		//MENU EVENTS
		private function onClickMenu(pStrAmbientID:String):void {
			openArea(pStrAmbientID);
		}
	}
}
