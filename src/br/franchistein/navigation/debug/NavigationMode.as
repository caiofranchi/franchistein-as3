package br.franchistein.navigation.debug
{
	import br.franchistein.navigation.general.GeneralConfig;
	import br.franchistein.utils.StringUtils;
	
	import flash.display.DisplayObject;
	import flash.system.Capabilities;

	public class NavigationMode
	{
		public static const COMPILER					:String = "openAmbient";
		
		public static const BROWSER						:String = "browser";
		
		public static const LOCAL						:String = "local";
		
		public static const DEBUG						:String = "debug";
		
		public static const AIR							:String = "air";
		
		public static function discover():String
		{		
			
			switch(Capabilities.playerType){
				case 'Desktop':
					return AIR
					break;
				
				case 'PlugIn':
					return BROWSER
					break;
				
				case 'ActiveX':
					return BROWSER
					break;
				case 'StandAlone':
					return LOCAL;
					break;
				default:
					return LOCAL;
					break;
			}
			
		}
		
		//Return if the project is on server or no
		public static function isProduction(pDspReference:DisplayObject):Boolean {
			return (( getFullURL(pDspReference).indexOf("http://") !=-1 || getFullURL(pDspReference).indexOf("https://") !=-1 ) && discover()==BROWSER)
		}
		
		public static function getMajorVersion():Number {
			//TODO: Separar essa funcao
			// Get the player's version by using the getVersion() global function.
			var versionNumber:String = Capabilities.version;
			
			// The version number is a list of items divided by ","
			var versionArray:Array = versionNumber.split(",");
			var length:Number = versionArray.length;
			
			// The main version contains the OS type too so we split it in two
			// and we'll have the OS type and the major version number separately.
			var platformAndVersion:Array = versionArray[0].split(" ");
			
			var numMajorVersion:Number = parseInt(platformAndVersion[1]);
			var numMinorVersion:Number = parseInt(versionArray[1]);
			var numBuildNumber:Number = parseInt(versionArray[2]);
			
			return numMajorVersion;
		}
		
		public static function root():String
		{
			//TODO: Fazer a funcao
			/*switch(NavigationMode.discover()){
				case 
			}*/
			
			return "";
		}
		
		//funcao para sobrescrever varias nos paths relativos usados no sistema
		public static function processPath(pStrPath:String):String {
			pStrPath = StringUtils.basicReplace(pStrPath,"{root}", GeneralConfig.ROOT);
			pStrPath = StringUtils.basicReplace(pStrPath,"{url}", GeneralConfig.URL);
			pStrPath = StringUtils.basicReplace(pStrPath,"{language}", GeneralConfig.LANGUAGE);
			return pStrPath;
		}
		
		public static function getBaseURL(pDspReference:DisplayObject):String {	
			//TODO: Create function
			return getFullURL(pDspReference).split("/")[2];
		}
		
		public static function getFullURL(pDspReference:DisplayObject):String {
			return  pDspReference.root.loaderInfo.url;
		}
	}
}