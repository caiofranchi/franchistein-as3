package br.franchistein.navigation.menu
{
	import br.franchistein.display.MovieClipDestroy;
	import br.franchistein.utils.ArrayUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public dynamic class Menu extends MovieClipDestroy
	{
		private var arrMenuItems		:Array = [];
		
		private var isMultiSelectable	:Boolean = false
		//
		public function Menu()
		{
			super();
			items = [];
		}
		//PUBLICS
		public function addMenuItem(pMenuItem:AbstractMenuButton):void {
			arrMenuItems.push(pMenuItem);
			unselectMenuItem(pMenuItem.id);
		}
		
		public function selectMenuItem(pMenuItemID:String):void {			
			var _intIndexSelecionar:int = ArrayUtils.returnIndexByParam(pMenuItemID,"id",arrMenuItems);
			//
			for (var i:int=0;i<arrMenuItems.length;i++){
				var btnMenu:AbstractMenuButton = arrMenuItems[i] as AbstractMenuButton
				if(_intIndexSelecionar==i){
					btnMenu.buttonMode = false;
					//
					if(btnMenu.lockeable) removeListeners(btnMenu);	
					
					if(!btnMenu.active) btnMenu.activate();									
				}else {
					if(!isMultiSelectable) {
						unselectMenuItem(btnMenu.id);
						btnMenu.active = false;	
					}
				}
			}
			//
		}
		
		public function unselectMenuItem(pMenuItemID:String):void {
			var btnMenu:AbstractMenuButton = ArrayUtils.returnItemByParam(pMenuItemID,"id",arrMenuItems) as AbstractMenuButton;
			//
			if(btnMenu.active) btnMenu.deactivate();
			btnMenu.active = false;
			btnMenu.buttonMode = true;
			//
			if(btnMenu.lockeable) criaListeners(btnMenu);
		}
		
		public function unselectAll():void {
			for (var i:int=0;i<arrMenuItems.length;i++){
				unselectMenuItem((arrMenuItems[i] as AbstractMenuButton).id);
			}
		}
		override public function dispose():void {
			super.dispose();
			unselectAll();
			items = [];
		}
		//PRIVATES
		private function onClickButton(e:MouseEvent):void {
			var btnMenuAtual:AbstractMenuButton = e.currentTarget as AbstractMenuButton;
			//
			btnMenuAtual.click();
		}
		
		private function removeListeners(pMenuButton:AbstractMenuButton):void {
			var _menuButton:AbstractMenuButton = pMenuButton;
			//
			_menuButton.removeEventListener(MouseEvent.ROLL_OVER,_menuButton.rollOver);
			_menuButton.removeEventListener(MouseEvent.ROLL_OUT,_menuButton.rollOut);
			_menuButton.removeEventListener(MouseEvent.CLICK,onClickButton);
		}
		
		private function criaListeners(pMenuButton:AbstractMenuButton):void {
			var _menuButton:AbstractMenuButton = pMenuButton;
			//
			_menuButton.addEventListener(MouseEvent.ROLL_OVER,_menuButton.rollOver,false,0,true);
			_menuButton.addEventListener(MouseEvent.ROLL_OUT,_menuButton.rollOut,false,0,true);
			_menuButton.addEventListener(MouseEvent.CLICK,onClickButton,false,0,true);
		}
		//GETTERS AND SETTERS
		public function get items():Array {
			return arrMenuItems
		}
		
		public function set items (pArrItems:Array):void{
			arrMenuItems = pArrItems;
		}
		
		public function get multiSelectable():Boolean {
			return isMultiSelectable
		}
		
		public function set multiSelectable(pIsMultiSelectable:Boolean):void{
			isMultiSelectable = pIsMultiSelectable;
		}
	}
}