package br.franchistein.navigation.soundcontroller
{
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	public class SoundObject extends Sound
	{
		public var info			:Object = new Object();
		
		private var status		:String = null;
		
		public function SoundObject(stream:URLRequest=null, context:SoundLoaderContext=null)
		{
			super(stream, context);
		}
		//
		public function get status():String{
			return status;
		}
	}
}