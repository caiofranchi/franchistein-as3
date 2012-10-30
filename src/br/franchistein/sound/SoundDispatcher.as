package br.franchistein.sound
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class SoundDispatcher
	{
		public function SoundDispatcher()
		{
		}
		//
		public static function basicLocalDispatch(pSoundClass:Class,pNumStarting:Number=0,pIntVolume:Number=1,pNumLoop:int=0):SoundChannel {
			var _sndClass:Sound = new pSoundClass();
			var _schCanal:SoundChannel = new SoundChannel();
			var _stfTransform:SoundTransform = new SoundTransform(pIntVolume);
			//
			_schCanal.soundTransform = _stfTransform 
			_schCanal = _sndClass.play(pNumStarting,pNumLoop,_stfTransform);			
			//
			return _schCanal;
		}
	}
}