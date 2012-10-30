package br.franchistein.scroll
{
	import br.franchistein.scroll.elements.ScrollDrag;
	
	import flash.display.DisplayObject;
	import flash.ui.Keyboard;

	public class ScrollInterface
	{
		//BUTTONS
		public var upButton				:DisplayObject;
		public var downButton			:DisplayObject;
		public var scrollBackground		:DisplayObject;
		public var scrollDrag			:ScrollDrag;
		
		//KEYS
		public var keyCodeUp			:uint
		public var keyCodeDown			:uint
		
		//CONTENT
		public var mask					:DisplayObject;
		public var content				:DisplayObject;
		
		public function ScrollInterface()
		{
			dispose();
		}
		//
		public function configButtons(pScrollDrag:ScrollDrag=null,pScrollBackground:DisplayObject=null,pUpButton:DisplayObject=null,pDownButton:DisplayObject=null):void {
			scrollDrag = pScrollDrag;
			scrollBackground = pScrollBackground;
			upButton = pUpButton;
			downButton = pDownButton;
		}
		//
		public function configKeys(pUpKeyCode:uint,pDownKeyCode:uint):void {
			keyCodeUp = pUpKeyCode;
			keyCodeDown = pDownKeyCode;
		}
		//
		public function configContent(pContent:DisplayObject=null,pMask:DisplayObject=null):void {
			content = pContent;
			mask = pMask;
		}
		public function dispose():void {
			keyCodeUp = keyCodeDown = 0;
			//
			upButton = downButton = scrollBackground = scrollDrag = null
			//
			mask = content = null;
		}
	}
}