package br.franchistein.navigation.general
{
	import flash.display.Stage;

	public class GeneralConfig
	{
		public static var GENERAL						:General;
		
		public static var FLASH_VARS					:Object = new Object();
		public static var PRELOADER_VARS				:Object = new Object();
		public static var GLOBAL						:Object = new Object();
						
		public static var ROOT							:String = "../";
		public static var DEFAULT_AREA					:String = "";
		public static var LANGUAGE						:String = "";
		public static var URL							:String = "";
		
		public static var TRACKING						:Boolean = true;
		public static var VERBOSE						:Boolean = true;
		public static var DEBUG							:Boolean = false;
		
		public static var STAGE							:Stage;
		
		public function GeneralConfig(){
		
		}
	}
}