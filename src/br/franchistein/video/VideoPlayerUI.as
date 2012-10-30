package br.franchistein.video
{
	import br.franchistein.navigation.menu.AbstractMenuButton;
	import br.franchistein.utils.DisplayUtils;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class VideoPlayerUI extends Sprite
	{
		protected var 		uiThis					:VideoPlayerUI
		
		private var 		vidControl				:VideoPlayer = new VideoPlayer();
		
		//buttons
		private var 		btnPlay					:AbstractMenuButton = new AbstractMenuButton(); //TODO: aqui o "new" não poderá ser automático para não utilizar memória desnecessária
		private var 		btnPause				:AbstractMenuButton = new AbstractMenuButton();
		private var 		btnMute					:AbstractMenuButton = new AbstractMenuButton();
		
		
		private var			numIntervalSecurity		:int;
		private var			isDragging				:Boolean;

		//seek
		private var 		movSeekHolder			:MovieClip
		private var 		movSeekBar				:MovieClip
		private var 		movSeekArea				:MovieClip
		private var 		movBarraProgresso		:MovieClip;
		private var 		movSeekTimer			:MovieClip;
		private var 		movSeekPoint			:MovieClip;
		private var 		isAlreadyPaused			:Boolean = false;
		
		public function VideoPlayerUI()
		{
			uiThis = this;	
		}
		
		public function start():void {
		
		}
		
		public function setPlayerToControl(pVidPlayer:VideoPlayer):void {
			vidControl = pVidPlayer;
			vidControl.addEventListener(VideoPlayerEvent.UPDATE,onVideoUpdate);
		}
		
		public function dispose():void {
			//play things
			btnPlay.dispose();
			vidControl.removeEventListener(VideoPlayerEvent.PLAY,onPlayVideo);
			vidControl.removeEventListener(VideoPlayerEvent.UPDATE,onVideoUpdate);
			
			//pause things
			btnPause.dispose();
			vidControl.removeEventListener(VideoPlayerEvent.PAUSE,onPauseVideo);
			
			//mute 
			btnMute.dispose();
			vidControl.removeEventListener(VideoPlayerEvent.MUTE,onMuteVideo);
			vidControl.removeEventListener(VideoPlayerEvent.UNMUTE,onUnMuteVideo);
			
			//seek
			vidControl.removeEventListener(VideoPlayerEvent.UPDATE,onVideoUpdate);
			movSeekArea.removeEventListener(MouseEvent.MOUSE_DOWN,onSeekMouseDown);
			movSeekHolder.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onSeekMouseMove);
			movSeekHolder.stage.removeEventListener(MouseEvent.MOUSE_UP,onSeekStageMouseUp);
			movSeekHolder.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onSeekMouseMove);
			
		}
		
		/*
		
			INTERFACE ITEMS
		
		*/
		
		public function setSeekBar(pMovHolder:MovieClip,pMovBarraProgresso:MovieClip,pmovSeekTimer:MovieClip,pMovSeekArea:MovieClip,pSeekPoint:MovieClip):void {
			//setting up
			movSeekHolder= pMovHolder
			movBarraProgresso = pMovBarraProgresso
			movSeekTimer = pmovSeekTimer
			movSeekArea = pMovSeekArea;
			movSeekPoint = pSeekPoint;
			DisplayUtils.lockDisplayObject(movSeekPoint);
			//	
			movBarraProgresso.numOriginalWidth = movBarraProgresso.width;
			movSeekArea.scaleX = movSeekTimer.scaleX = movBarraProgresso.scaleX = 0
			
			//seek
			movSeekArea.buttonMode = true;
			movSeekArea.addEventListener(MouseEvent.MOUSE_DOWN,onSeekMouseDown);
			
			
		}
		
		protected function onVideoUpdate(event:VideoPlayerEvent):void
		{
			//loading
			var numScale:Number = (vidControl.bytesLoaded / vidControl.bytesTotal);
			//
			if(numScale<0  || isNaN(numScale)) numScale = 0;
			//
			movSeekArea.scaleX = movBarraProgresso.scaleX = numScale;
			
			//seek
			numScale = vidControl.currentTime / vidControl.totalTime;
			if(numScale<0 || isNaN(numScale)) numScale = 0;
			movSeekTimer.scaleX = numScale;
			//
			movSeekPoint.x = movSeekTimer.x+movSeekTimer.width;
		}
		
		private function onSeekMouseDown(e:MouseEvent=null):void {
			//down
			isAlreadyPaused = vidControl.isPaused;
			vidControl.pause();
			
			isDragging = true;			
			movSeekHolder.stage.addEventListener(MouseEvent.MOUSE_MOVE,onSeekMouseMove);			
			//release
			movSeekHolder.stage.addEventListener(MouseEvent.MOUSE_UP,onSeekStageMouseUp);
			//
			onSeekMouseMove();
			
		}
		private function onSeekMouseMove(e:MouseEvent=null):void {
			//
			var numPosX:Number = Math.floor(movSeekHolder.mouseX-movSeekArea.x); 
			var numPorcentagem:Number = Math.floor((100*numPosX)/movBarraProgresso.numOriginalWidth);
			if(numPorcentagem>100) numPorcentagem = 100;
			if(numPorcentagem<0) numPorcentagem = 0;
			
			if(numPorcentagem<100 && numPorcentagem>0){				
				var numSegundosPorcentagem:Number = ((vidControl.totalTime*numPorcentagem)/100);
				//var numSegundosPorcentagemAtual:Number = Math.floor((flvPlayback.playheadTime*numPorcentagem)/100);
				
				clearTimeout(numIntervalSecurity);
				numIntervalSecurity = setTimeout(function():void {					
					vidControl.seek(numSegundosPorcentagem);
				},120);		
			}
		}
		private function onSeekStageMouseUp(e:MouseEvent=null):void {
			movSeekHolder.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onSeekMouseMove);
			
			//release
			movSeekHolder.stage.removeEventListener(MouseEvent.MOUSE_UP,onSeekStageMouseUp);
			
			if(!isAlreadyPaused) {
					vidControl.play();
			}
			isDragging = false;
		}
		
		public function setAutoHideFunctions():void {
		
		}
		public function setPlayButton(pDspObject:AbstractMenuButton):void {
			btnPlay = pDspObject;
			btnPlay.setClickAction(onPlayClickAction);
			btnPlay.makeIndepedency();
			//
			vidControl.addEventListener(VideoPlayerEvent.PLAY,onPlayVideo);
		}
		
		public function setPauseButton(pDspObject:AbstractMenuButton):void {
			btnPause = pDspObject;
			btnPause.setClickAction(onPauseClickAction);
			btnPause.makeIndepedency();
			//
			vidControl.addEventListener(VideoPlayerEvent.PAUSE,onPauseVideo);
		}
		public function setMuteButton(pDspObject:AbstractMenuButton):void {
			btnMute = pDspObject;
			btnMute.setClickAction(onMuteClickAction);
			btnMute.makeIndepedency();
			//
			vidControl.addEventListener(VideoPlayerEvent.MUTE,onMuteVideo);
			vidControl.addEventListener(VideoPlayerEvent.UNMUTE,onUnMuteVideo);
		}
		public function setVolumeBar(pDspVolumeBar:DisplayObjectContainer,pBtnDragBar:AbstractMenuButton,pSprBackground:DisplayObject):void {
		
		}
		public function setFullScreenButton():void {
		
		}
		public function setVideoControls():void {
		
		}
		public function displayCurrentTime(pTxtCurrentTime:TextField):void {
		
		}
		
		/*
		
			INTERNAL EVENTS
			Aqui são tratados os eventos relativos ao player e repassados as UIs
		*/
		
		private function onPlayClickAction():void {
			vidControl.play();
		}
		
		private function onPauseClickAction():void {
			vidControl.pause();		
		}
		
		private function onMuteClickAction():void {
			if(vidControl.volume==0) 
				vidControl.unMute()
			else 
				vidControl.mute();
		}
		
		private function onPlayVideo(e:VideoPlayerEvent):void {
			//
			btnPlay.activate();
			
			btnPause.deactivate();
		}
		
		private function onPauseVideo(e:VideoPlayerEvent):void {
			//
			btnPlay.deactivate();
			btnPause.activate();
		}
		
		private function onMuteVideo(e:VideoPlayerEvent):void {
			btnMute.activate();
		}
		
		private function onUnMuteVideo(e:VideoPlayerEvent):void {
			btnMute.deactivate();
		}
		
		public function get videoPlayer():VideoPlayer {
			return vidControl;
		}
	}
}