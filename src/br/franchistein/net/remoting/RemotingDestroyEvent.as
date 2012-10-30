package br.franchistein.net.remoting
{
	//NATIVAS
	import flash.events.Event;
	

	/**
	* RemotingDestroyEvents - Destroy Family
	* @author CAIO FRANCHI - http://www.caiofranchi.com.br
	* @version 1.0b
	*/
	public class RemotingDestroyEvent extends Event;
	{
		//CONSTANSTES	
		public static var ON_CONNECT			:String = "connect";
		public static var ON_REQUEST_COMPLETE	:String = "requestComplete";
		public static var ON_REQUEST_ERROR		:String = "requestError";
		
		public function RemotingDestroyEvent(type:String,combo:Combo,bubbles:Boolean=false,cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
	}
	
}