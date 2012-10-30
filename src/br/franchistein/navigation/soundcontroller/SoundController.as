package br.franchistein.navigation.soundcontroller
{
	import flash.media.Sound;

	public class SoundController
	{
		//
		private var arrSounds		:Array = [];
		//TODO: Create Class
		public function SoundController()
		{
			
		}
		//PUBLIC
		public function addSound(pSound:Sound,pNumInit:Number,pNumRepeat:int):void {
			arrSounds.push(new SoundObject());
		}
		public function removeSound():void {
		
		}
		public function muteAll():void {
				
		}
		public function unMuteAll():void {
			
		}
		public function changeVolume(pNumVolume:Number):void {
		
		}
		//EVENTS
	}
}