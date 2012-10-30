package br.franchistein.video.types
{
	import br.franchistein.video.AbstractVideoType;
	import br.franchistein.video.IVideo;
	import br.franchistein.video.VideoPlayerEvent;
	
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;

	public class LocalFileType extends AbstractVideoType implements IVideo
	{
		public var flvPlayback					:FLVPlayback = new FLVPlayback();
		
		private var strSource					:String;
		
		private var refStage					:DisplayObject
		
		private var numWidth					:Number
		private var numHeight					:Number
		
		public function LocalFileType(pStageReference:DisplayObject,pNumWidth:Number=500,pNumHeight:Number=500,pIsAutoPlay:Boolean=true,pIsAutoRewind:Boolean=false,pIsFullScreenTakeOver:Boolean=false)
		{
			refStage = pStageReference;
			flvPlayback = new FLVPlayback();
			flvPlayback.width = numWidth = pNumWidth
			flvPlayback.height = numHeight = pNumHeight
			flvPlayback.autoPlay = pIsAutoPlay;
			flvPlayback.autoRewind = pIsAutoRewind;
			flvPlayback.fullScreenTakeOver = pIsFullScreenTakeOver;
			//
			objRender = flvPlayback
		}
		
		override public function load(pObj:*,pIsAutoPlay:Boolean=false):void {
			isAutoPlay = pIsAutoPlay;
			//
			flvPlayback.source = pObj;	
			flvPlayback.width = numWidth
			flvPlayback.height = numHeight
			if(isAutoPlay) play();
			//
			flvPlayback.addEventListener(VideoEvent.COMPLETE,onCompleteVideo);
		}
		
		private function onVideoUpdate(event:Event):void
		{
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.UPDATE,absThis));			
		}
		
		protected function onCompleteVideo(event:Event):void
		{
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.FINISH,absThis));		
		}
		
		override public function play():void {
			flvPlayback.play();
			isPaused = false;
			//		
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY,absThis));		
			//
			refStage.stage.addEventListener(Event.ENTER_FRAME,onVideoUpdate);
		}
		
		override public function pause():void {
			flvPlayback.pause()
			isPaused = true;
			//
			refStage.stage.removeEventListener(Event.ENTER_FRAME,onVideoUpdate);
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PAUSE,absThis));			
		}
		
		override public function stop():void {
			flvPlayback.stop();
			//
			refStage.stage.removeEventListener(Event.ENTER_FRAME,onVideoUpdate);
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.STOP,absThis));			
		}
		/*
		
		GETTERS AND SETTERS
		
		*/
		override public function get currentTime():Number {			
			return flvPlayback.playheadTime;
		}
		override public function get totalTime():Number	{	
			return flvPlayback.totalTime
		}
		
		override public function get state() : String {
			return flvPlayback.state			
		}		
		
		override public function set volume(pNumVolume:Number) : void {
			flvPlayback.volume = pNumVolume
			
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.CHANGE_VOLUME,absThis));			
		}
		
		override public function get volume() : Number {
			return flvPlayback.volume	
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
			flvPlayback.seekSeconds(pNumSeconds);
		}
		
		override public function setSize(pNumWidth:Number,pNumHeight:Number) : void  {
			flvPlayback.width = pNumWidth		
			flvPlayback.height = pNumHeight;		
		}
		
		override public function get progress() : Number {
			return (100* bytesLoaded) / bytesTotal;
		}
		
		override public function get bytesLoaded() : Number {
			return flvPlayback.bytesLoaded
		}
		
		override public function get bytesTotal() : Number {
			return flvPlayback.bytesTotal
		}
		
		override public function get render():*
		{
			return objRender;
		}
		
		override public function dispose():void {
			flvPlayback.removeEventListener(VideoEvent.COMPLETE,onCompleteVideo);
			stop();
			absThis = null
		}
	}
}