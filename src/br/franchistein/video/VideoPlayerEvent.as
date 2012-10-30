package br.franchistein.video
{
	import flash.events.Event;

	public class VideoPlayerEvent extends Event
	{
		//GENERAL EVENTS
		public static var LOAD						:String = "onLoad";
		public static var LOAD_PROGRESS				:String = "onLoadProgress";
		public static var LOAD_COMPLETE				:String = "onLoadComplete";
		
		public static var PLAY						:String = "onPlay";
		public static var PAUSE						:String = "onPause";
		public static var STOP						:String = "onStop";
		
		public static var SEEK						:String = "onSeek";
		
		public static var MUTE						:String = "onMute";
		public static var UNMUTE					:String = "onUnMute";
		public static var CHANGE_VOLUME				:String = "onChangeVolume";
		
		public static var PLAYER_READY				:String = "onPlayerReady";
		public static var PLAYER_ERROR				:String = "onPlayerError";
		public static var PLAYER_CHANGE_STATE		:String = "onPlayerChangeState";
		
		public static var START						:String = "onStartVideo";
		public static var UPDATE					:String = "onVideoUpdate";
		public static var FINISH					:String = "onFinishVideo";
		
		//
		public var player							:AbstractVideoType
		//
		public function VideoPlayerEvent(type:String,pPlayer:AbstractVideoType = null,bubbles:Boolean=false,cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.player = (pPlayer == null) ? null : pPlayer;
		}
	}
}