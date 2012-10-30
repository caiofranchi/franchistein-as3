package br.franchistein.video.types
{
	import br.franchistein.utils.BasicLoader;
	import br.franchistein.utils.ClassUtils;
	import br.franchistein.video.AbstractVideoType;
	import br.franchistein.video.IVideo;
	import br.franchistein.video.VideoPlayerEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.system.LoaderContext;

	public class TimelineType extends AbstractVideoType implements IVideo
	{
		//holds the current movieclip
		public var movCurrentMovie		:MovieClip;
		
		protected var isReset			:Boolean =true;
		
		private var ldMovie				:Loader;
		
		private var dspReference		:DisplayObject
		
		private var numCurrentFrame		:Number
		private var isStoped			:Boolean = true
		private var isExternal			:Boolean = false;
		
		public function TimelineType(pDspReference:DisplayObject,pIsReset:Boolean=false)
		{
			dspReference = pDspReference,isReset = pIsReset;
			//
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAYER_READY,absThis));
		}
		
		override public function load(pObj:*, pIsAutoPlay:Boolean=false):void {
			isAutoPlay = pIsAutoPlay;
			//
			if(typeof(pObj)=="string"){
				//loads the .swf
				isExternal = true;
				ldMovie = BasicLoader.loadSWF(pObj,new LoaderContext(true),onCompleteLoadingSWF);
				ldMovie.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgressLoadingSWF)
				//
			}else if(ClassUtils.verifyInheritance(pObj,"MovieClip")) {
				//movieclip
				isExternal = false;
				onCompleteLoadingSWF(pObj);
			}else {
				throw new Error("The received movie cannot be recognized.")
			}
			
		}
		
		
		/*
			EVENTS
		*/
		
		protected function onEnterFrameVideo(event:Event):void
		{
			if(event==null) return;
			if(movCurrentMovie.currentFrame!=numCurrentFrame && !isStoped){
				
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.UPDATE,absThis));
				numCurrentFrame = movCurrentMovie.currentFrame;
			}
			//
			if(movCurrentMovie.currentFrame == movCurrentMovie.totalFrames) {
				pause();
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.FINISH,absThis));
			}
		}
		
		
		private function onProgressLoadingSWF(e:ProgressEvent=null):void {
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.LOAD_PROGRESS,absThis));
		}
		
		private function onCompleteLoadingSWF(pMovieClipLoaded:MovieClip):void
		{
			movCurrentMovie = objRender =pMovieClipLoaded;
			if(isReset) movCurrentMovie.gotoAndStop(1);
			//
			if(isAutoPlay) play()
			//
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.LOAD_COMPLETE,absThis));			
		}
		
		override public function play():void {			
			movCurrentMovie.gotoAndPlay(movCurrentMovie.currentFrame+2);	
			isStoped=false;
			//
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY,absThis));
			movCurrentMovie.addEventListener(Event.FRAME_CONSTRUCTED,onEnterFrameVideo);
						
		}
		
		override public function pause():void {
			movCurrentMovie.stop();	
			//
			movCurrentMovie.removeEventListener(Event.FRAME_CONSTRUCTED,onEnterFrameVideo);
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PAUSE,absThis));			
		}
		
		override public function stop():void {
			movCurrentMovie.gotoAndStop(1);
			isStoped = true;
			//
			movCurrentMovie.removeEventListener(Event.FRAME_CONSTRUCTED,onEnterFrameVideo);
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.STOP,absThis));			
		}
		/*
		
		GETTERS AND SETTERS
		
		*/
		override public function get currentTime():Number {			
			return Math.ceil(movCurrentMovie.currentFrame/dspReference.stage.frameRate);
		}
		override public function get totalTime():Number	{
			return Math.ceil(movCurrentMovie.totalFrames/dspReference.stage.frameRate);
		}
		/*
		override public function get state() : String {
			return plyYoutube.getVolume();			
		}		
		*/
		override public function set volume(pNumVolume:Number) : void {
			SoundMixer.soundTransform = new SoundTransform(pNumVolume, 0)
			
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.CHANGE_VOLUME,absThis));			
		}
		
		override public function get volume() : Number {
			return SoundMixer.soundTransform.volume			
		}
		
		override public function mute() : void {
			volume = 0;			
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.MUTE,absThis));
		}
		
		override public function unMute() : void {
			volume = 1;
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.UNMUTE,absThis));
		}
		
		override public function seek(pNumSeconds:Number):void {
			movCurrentMovie.gotoAndPlay(Math.ceil(pNumSeconds*dspReference.stage.frameRate));
			movCurrentMovie.addEventListener(Event.FRAME_CONSTRUCTED,onEnterFrameVideo);
		}
		
		override public function setSize(pNumWidth:Number,pNumHeight:Number) : void  {
			movCurrentMovie.width = pNumWidth, movCurrentMovie.height = pNumHeight;		
		}
		
		override public function get progress() : Number {
			return ((100* bytesLoaded) / bytesTotal);
		}
		
		override public function get bytesLoaded() : Number {
			return (isExternal) ? (ldMovie.loaderInfo.bytesLoaded) : 1000
		}
		
		override public function get bytesTotal() : Number {
			return (isExternal) ? (ldMovie.loaderInfo.bytesTotal) : 1000;
		}
		
		override public function dispose():void {
			stop();
			absThis = null
		}
	}
}