package br.franchistein.navigation.area
{
	
	
	import br.franchistein.navigation.menu.AbstractMenuButton;
	import br.franchistein.navigation.menu.Menu;

	public class Ambient
	{
		public var area						:Class;
		
		public var id						:String;
		public var tag						:String;
		public var type						:String;
		public var path						:String;
		public var url						:String;
		public var className				:String;
		
		public var info						:Object = new Object();
				
		public var active					:Boolean = true;
		public var loaded					:Boolean = false;
		
		public var button					:AbstractMenuButton;
		public var menu						:Menu;
		
		public var progress					:Number;
		
		public var isPermalinkEnabled		:Boolean = true;
		//
		public function Ambient()
		{
			
		}
	}
}