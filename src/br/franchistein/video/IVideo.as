package br.franchistein.video
{
	public interface IVideo
	{
		function load(pObj:*,pIsAutoPlay:Boolean=false) : void
		
		function play() : void
		
		function pause() : void
		
		function stop() : void
		
		function seek(pNumSeconds:Number) : void
		
		function dispose() : void 
		
		function setSize(pNumWidth:Number,pNumHeight:Number) : void 
		
		function mute() : void 
		
		function unMute() : void
		
		function get progress() : Number 
		
		function get bytesLoaded() : Number 
		
		function get bytesTotal() : Number 
		
		function get autoRewind() : Boolean
		
		function set autoRewind(pIsAutoRewind:Boolean) : void 
		
		function get buffering() : Boolean 
		
		function get autoPlay() : Boolean 
		
		function set autoPlay(pIsAutoPlay:Boolean) : void
		
		function get loop() : Boolean
		
		function set loop(pIsLoop:Boolean) : void 
		
		function get volume() : Number 
		
		function set volume(pNumVolume:Number) : void 
			
		function get totalTime() : Number
			
		function get currentTime() : Number
			
		function get state() : String
			
		function get render():*
	}
}