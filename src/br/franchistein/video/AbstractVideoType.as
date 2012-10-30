package br.franchistein.video
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class AbstractVideoType implements IVideo,IEventDispatcher
	{
		public var videoObjet			:*
			
		public var type					:String
		protected var strState			:String
		
		protected var _progress			:Number = 0;
		protected var _bytesLoaded		:Number = 0;
		protected var _bytesTotal		:Number = 0;
		protected var _volume			:Number = 0;
		
		protected var isLoop			:Boolean = false;
		protected var isRewind			:Boolean = false;
		protected var isAutoPlay		:Boolean = false;
		protected var isBuffering		:Boolean = false;
		
		protected var objRender			:*;
		
		private var dispatcher			:EventDispatcher;
		
		protected var absThis			:AbstractVideoType
		private var _isPaused			:Boolean = false;
		
		public function AbstractVideoType()
		{
			dispatcher = new EventDispatcher(this);
			absThis = this;
		}
				
		public function get isPaused():Boolean
		{
			return _isPaused;
		}

		public function set isPaused(value:Boolean):void
		{
			_isPaused = value;
		}

		public function load(pObj:*,pIsAutoPlay:Boolean=false) : void {
			throw new Error("Abstract load() method must be overriden.");
		}
		
		public function play() : void {
			throw new Error("Abstract play() method must be overriden.");
		}
		
		public function pause() : void {
			throw new Error("Abstract pause() method must be overriden.");
		}
		
		public function stop() : void {
			throw new Error("Abstract stop() method must be overriden.");
		}	
		
		public function seek(pNumSeconds:Number) : void {
			throw new Error("Abstract seek() method must be overriden.");
		}
		
		public function dispose() : void {
			throw new Error("Abstract dispose() method must be overriden.");
		}
		
		public function setSize(pNumWidth:Number,pNumHeight:Number) : void {
			throw new Error("Abstract setSize() method must be overriden.");
		}
		
		public function mute() : void {
			throw new Error("Abstract mute() method must be overriden.");
		}
		
		public function unMute() : void {
			throw new Error("Abstract unMute() method must be overriden.");
		}
		
		//GETTERS AND SETTERS
		public function get progress() : Number {
			return _progress;
		}
		
		public function get bytesLoaded() : Number {
			return _bytesLoaded;
		}
		
		public function get width() : Number {
			return 1;
		}
		
		public function get height() : Number {
			return 1;
		}
		
		public function get bytesTotal() : Number {
			return _bytesTotal;
		}
		
		public function get autoRewind() : Boolean {
			return isRewind;
		}
		
		public function set autoRewind(pIsAutoRewind:Boolean) : void {
			isRewind = pIsAutoRewind;
		}
		
		public function get buffering() : Boolean {
			return isBuffering;
		}
		
		public function get autoPlay() : Boolean {
			return isAutoPlay;
		}
		
		public function set autoPlay(pIsAutoPlay:Boolean) : void {
			isAutoPlay = pIsAutoPlay;
		}
		
		public function get loop() : Boolean {
			return isLoop;
		}
		
		public function set loop(pIsLoop:Boolean) : void {
			isLoop = pIsLoop
		}
		
		public function get volume() : Number {
			return _volume;
		}
		
		public function set volume(pNumVolume:Number) : void {
			_volume = pNumVolume;
		}
		
		
		public function get totalTime():Number
		{
			return 0;
		}
		
		public function get currentTime():Number
		{
			return 0;
		}
		
		public function get state():String
		{
			return strState;
		}
		
		public function get render():*
		{
			return objRender;
		}
		
		// --== Implemented interface methods ==--
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