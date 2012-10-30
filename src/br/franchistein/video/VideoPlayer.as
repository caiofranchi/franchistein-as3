package br.franchistein.video
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public dynamic class VideoPlayer extends Sprite implements IVideo,IEventDispatcher
	{
		protected var vidThis						:VideoPlayer
		
		private var isAutoDetectVideoType			:Boolean = true;
		
		private var isMultipleVideoTypes			:Boolean = false;
		
		private var currentModule					:AbstractVideoType;
		
		private var uiVideoPlayer					:VideoPlayerUI;
		//
		public function VideoPlayer()
		{
			super();
			vidThis = this;
		}
		//
		public function configurePlayer(pVidAbstract:AbstractVideoType,pUIVideo:VideoPlayerUI=null):void {
			
			//setando o tipo do player
			currentModule = pVidAbstract;
			
			//setando a itnerface do video
			if(pUIVideo!=null){
				uiVideoPlayer = pUIVideo;
				uiVideoPlayer.setPlayerToControl(vidThis);
				uiVideoPlayer.start();
			}
		}	
		
		/*
		
			IMPLEMENTED METHODS
		
		*/
		
		public function config(...rest):void
		{
		}
		
		public function load(pObj:*,pIsAutoPlay:Boolean=false):void
		{
			currentModule.load(pObj,pIsAutoPlay);
		}
		
		public function play ():void
		{
			currentModule.play();
		}
		
		public function pause():void
		{
			currentModule.pause();
		}
		
		public function stop():void
		{
			currentModule.stop();
		}
		
		public function seek(pNumSeconds:Number):void
		{
			currentModule.seek(pNumSeconds);
		}
		
		public function dispose():void
		{
			currentModule.dispose();
			uiVideoPlayer.dispose();
		}
		
//		override public function get width():Number {
//			return currentModule.width
//		}
//		
//		override public function get height():Number {
//			return currentModule.height
//		}
		
		public function setSize(pNumWidth:Number, pNumHeight:Number):void
		{
			currentModule.setSize(pNumWidth,pNumHeight);
		}
		
		public function mute():void
		{
			currentModule.mute();
		}
		
		public function unMute():void
		{
			currentModule.unMute();
		}
		
		public function get progress():Number
		{
			return currentModule.progress;
		}
		
		public function get bytesLoaded():Number
		{
			return currentModule.bytesLoaded;
		}
		
		public function get bytesTotal():Number
		{
			return currentModule.bytesTotal;
		}
		
		public function get autoRewind():Boolean
		{
			return currentModule.autoRewind;
		}
		
		public function set autoRewind(pIsAutoRewind:Boolean):void
		{
			currentModule.autoRewind = pIsAutoRewind ;
		}
		
		public function get buffering():Boolean
		{
			return currentModule.buffering;
		}
		
		public function get autoPlay():Boolean
		{
			return currentModule.autoPlay;
		}
		
		public function set autoPlay(pIsAutoPlay:Boolean):void
		{
			currentModule.autoPlay = pIsAutoPlay;
		}
		
		public function get loop():Boolean
		{
			return currentModule.loop;
		}
		
		public function set loop(pIsLoop:Boolean):void
		{
			currentModule.loop = pIsLoop;
		}
		
		public function get volume():Number
		{
			return currentModule.volume;
		}
		
		public function set volume(pNumVolume:Number):void
		{
			currentModule.volume = pNumVolume;
		}
		
		public function get totalTime():Number
		{
			return currentModule.totalTime;
		}
		
		public function get currentTime():Number
		{
			return currentModule.currentTime;
		}
		
		public function get state():String
		{
			return currentModule.state;
		}
		
		public function get render():*
		{
			return currentModule.render;
		}
		
		public function get module():AbstractVideoType {
			return currentModule;
		}
		
		public function get isPaused():Boolean {
			return currentModule.isPaused;
		}
		
		public function set isPaused(pIsPaused:Boolean):void {
			currentModule.isPaused = pIsPaused ;
		}
		
		// --== Implemented interface methods ==--
		override public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			currentModule.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function dispatchEvent(evt : Event) : Boolean {
			return currentModule.dispatchEvent(evt);
		}
		
		override public function hasEventListener(type : String) : Boolean {
			return currentModule.hasEventListener(type);
		}
		
		override public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			currentModule.removeEventListener(type, listener, useCapture);
		}
		
		override public function willTrigger(type : String) : Boolean {
			return currentModule.willTrigger(type);
		}
	}
}