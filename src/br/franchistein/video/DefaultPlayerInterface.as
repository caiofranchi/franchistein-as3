package br.franchistein.video
{
	import br.franchistein.navigation.menu.AbstractMenuButton;
	
	import flash.display.Sprite;

	public dynamic class DefaultPlayerInterface extends VideoPlayerUI
	{
		public function DefaultPlayerInterface()
		{
			super();
			//
			
			/*
			playerInterface.autoHide = false;
			playerInterface.setAutoHideFunctions():
			playerInterface.setSeekBar();
			playerInterface.setPlayPauseButton();
			playerInterface.setMuteButton();
			playerInterface.setVolumeBar();
			playerInterface.setFullScreenButton();
			playerInterface.setVideoControls();
			playerInterface.displayCurrentTime();
			*/
		}
		override public function start():void {
			//play
			setPlayButton(this.btnPlay);
			
			//pause
			setPauseButton(this.btnPause);
			
			//mute
			(this.btnMute as AbstractMenuButton).lockeable = false;
			setMuteButton(this.btnMute);
		}
	}
}