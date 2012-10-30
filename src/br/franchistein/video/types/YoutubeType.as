package br.franchistein.video.types
{
	import br.franchistein.video.AbstractVideoType;
	import br.franchistein.video.IVideo;
	import br.franchistein.video.VideoPlayerEvent;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class YoutubeType extends AbstractVideoType implements IVideo
	{
		public var plyYoutube					:Object
		
		private var uldPlayerYoutube			:Loader = new Loader();
		
		public var isReady						:Boolean = false;
		public var isChromelessPlayer			:Boolean = false;
		
		//
		private var numVideoUpdateIntervalTime	:Number = 150;
		private var numVideoUpdateInterval		:uint;
		
		private var strDefaultQuality 			:String;
		
		public function YoutubeType(pIsChromelessPlayer:Boolean=false,pStrDefaultVideoQuality:String="large",pStrVideoID:String="",pStrExtraParameters:String="")
		{
			//TODO: add a way of config the other load parameters of the player, like enablejs, fullscreen, etc
			
			//assigning variables
			strDefaultQuality = pStrDefaultVideoQuality;
			isChromelessPlayer = pIsChromelessPlayer
			
			Security.allowInsecureDomain("*");
			Security.allowDomain("*"); 
			Security.allowDomain("www.youtube.com");			
			
			//adding listeners
			uldPlayerYoutube.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onErrorLoadingYoutubeComponent);			
			uldPlayerYoutube.contentLoaderInfo.addEventListener(Event.INIT, onInitLoadingYoutubeComponent);
			
			//montando a string de parâmetros
			var _strPlayerLoad:String = "http://www.youtube.com/";
			
			if(isChromelessPlayer){
				_strPlayerLoad += "apiplayer"
			}else {
				if(pStrVideoID==""){
					throw new Error("Caso não vá utilizar o chromeless player, favor passar o vídeo que deve ser carregado de início");
				}else {
					_strPlayerLoad += "v/"+pStrVideoID;
				}
			}
			
			//montando a string de carregamento
			_strPlayerLoad +="?version=3";
			_strPlayerLoad +="&"+pStrExtraParameters;
			//
			uldPlayerYoutube.load(new URLRequest(_strPlayerLoad), new LoaderContext());
		}		
		
		override public function load(pObj:*,pIsAutoPlay:Boolean=false):void {
			if(!isReady) throw new Error("No caso do player do youtube, favor verificar se o player já está pronto");
			//
			
			//
			autoPlay = pIsAutoPlay;
			//
			if(autoPlay) {
				plyYoutube.loadVideoById(pObj,0,strDefaultQuality);
				numVideoUpdateInterval = setInterval(onVideoUpdate,numVideoUpdateIntervalTime);
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY,absThis));
			} else{
				plyYoutube.cueVideoById(pObj,0,strDefaultQuality);
			}
			//
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.LOAD,absThis));
		}
		
		override public function play():void {			
			plyYoutube.playVideo();
			
			numVideoUpdateInterval = setInterval(onVideoUpdate,numVideoUpdateIntervalTime);
			//
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY,absThis));			
		}
		
		override public function pause():void {
			plyYoutube.pauseVideo();
			clearInterval(numVideoUpdateInterval);
			//
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PAUSE,absThis));			
		}
		
		override public function stop():void {
			plyYoutube.stopVideo();
			clearInterval(numVideoUpdateInterval);
			//
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.STOP,absThis));			
		}
		
		override public function mute() : void {
			volume = 0;			
		}
		
		override public function unMute() : void {
			volume = 1;
		}
		
		override public function seek(pNumSeconds:Number):void {
			plyYoutube.seekTo(pNumSeconds);
		}
		
		override public function setSize(pNumWidth:Number,pNumHeight:Number) : void  {
			plyYoutube.setSize(pNumWidth,pNumHeight);		
		}
		
		override public function dispose():void {
			clearInterval(numVideoUpdateInterval);
			//loading player events
			uldPlayerYoutube.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onErrorLoadingYoutubeComponent);			
			uldPlayerYoutube.contentLoaderInfo.removeEventListener(Event.INIT, onInitLoadingYoutubeComponent);
			
			//youtube events
			uldPlayerYoutube.content.removeEventListener("onError", onPlayerError);
			uldPlayerYoutube.content.removeEventListener("onStateChange", onPlayerChangeStage);			
			uldPlayerYoutube.content.removeEventListener("onReady",onPlayerReady);
			
			//destroy youtube player
			plyYoutube.stopVideo();
			plyYoutube.destroy();
		}
		
		//ESPECIAIS
		private function onInitLoadingYoutubeComponent(e:Event):void {
			//agora que o componente já foi carregado, verificamos o carregamento interno
			uldPlayerYoutube.content.addEventListener("onError", onPlayerError,false,0,true);
			uldPlayerYoutube.content.addEventListener("onStateChange", onPlayerChangeStage,false,0,true);			
			uldPlayerYoutube.content.addEventListener("onReady",onPlayerReady);
			//
		}
		
		private function onErrorLoadingYoutubeComponent(e:IOErrorEvent):void {
			
			//Erro ao tentar carregar o player do youtube
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAYER_ERROR,absThis));
		
		}
		
		protected function onVideoUpdate():void
		{
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.UPDATE,absThis));
		}
		//
		private function onPlayerReady(e:Event):void {					
			plyYoutube = uldPlayerYoutube.content;
			objRender = uldPlayerYoutube;
			//
			isReady = true;
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAYER_READY,absThis));
			//plyYoutube.setSize(pNumWidth,pNumHeight);
			//movThis.movContainerVideo.addChild(uldPlayerYoutube);
		}
		
		private function onPlayerError(e:Event):void {
			//Erro ao tentar carregar o player do youtube
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAYER_ERROR,absThis));
		}
		
		private function onPlayerChangeStage(e:Event):void {
			strState = Object(e).data;
			
			if(strState=="0"){
				pause();
				//seek(0);
				
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.FINISH,absThis));
			}
			
			//disparando quando a mudança de state
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAYER_CHANGE_STATE,absThis));
		}
		
		/*
		
			GETTERS AND SETTERS
		
		*/
		override public function get currentTime():Number {
			return plyYoutube.getCurrentTime();			
		}
		override public function get totalTime():Number {
			return plyYoutube.getDuration();			
		}
		
		override public function get state() : String {
			return plyYoutube.getVolume();			
		}		
	
		override public function set volume(pNumVolume:Number) : void {			
			
			if(pNumVolume==0){
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.MUTE,absThis));
			}else if (volume==0 && pNumVolume>0){
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.UNMUTE,absThis));
			}
			
			//no caso do youtube o volume vai de 0 a 100
			pNumVolume = pNumVolume * 100
			//
			plyYoutube.setVolume(pNumVolume);
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.CHANGE_VOLUME,absThis));			
		}
		
		override public function get volume() : Number {
			//no caso do youtube o volume vai de 0 a 100
			return plyYoutube.getVolume()/100;			
		}
		
		override public function get progress() : Number {
			return (100* bytesLoaded) / bytesTotal;
		}
		
		override public function get bytesLoaded() : Number {
			return plyYoutube.getVideoBytesLoaded();
		}
		
		override public function get bytesTotal() : Number {
			return plyYoutube.getVideoBytesTotal();
		}
	}
}