package br.franchistein.navigation.menu
{
	import br.franchistein.display.MovieClipDestroy;
	import br.franchistein.utils.DisplayUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public dynamic class AbstractMenuButton extends MovieClipDestroy implements IMenuButton
	{
		public var btnThis				:AbstractMenuButton;
		
		private var isLockeable			:Boolean  = true;
		private var isActive			:Boolean  = false;
		private var isIndependentButton	:Boolean  = false;
		
		private var strID				:String = "";
		
		private var menuReference		:Menu;
		
		//click action
		private var fncClickFunction	:Function;
		private var arrParams			:Array = [];
		
		//pop up menu
		private var mnuPopUp			:Menu
		
		public function AbstractMenuButton()
		{
			btnThis = this;
		}
		
		public function config(pMenuReference:Menu):void {
			menuReference = pMenuReference;
		}
		
		public function makeIndepedency():void {
			btnThis.buttonMode = true;
			btnThis.addEventListener(MouseEvent.ROLL_OVER,rollOver,false,0,true);
			btnThis.addEventListener(MouseEvent.ROLL_OUT,rollOut,false,0,true);
			btnThis.addEventListener(MouseEvent.CLICK,click,false,0,true);
			//
			isIndependentButton = true;
		}
		
		public function activate(e:Event=null):void
		{
			if(isIndependentButton && isLockeable) DisplayUtils.lockDisplayObject(btnThis);
			isActive = true;
		}
		
		public function deactivate(e:Event=null):void
		{
			if(isIndependentButton && isLockeable) DisplayUtils.unlockDisplayObject(btnThis);
			isActive = false;
		}
		
		public function rollOver(e:MouseEvent=null):void
		{
			
		}
		
		public function rollOut(e:MouseEvent=null):void
		{
			
		}
		
		public function click(e:Event=null):void {
			if(fncClickFunction!=null) {
				fncClickFunction.apply(null,arrParams);
			}
		}
		
		public function setClickAction(pFunction:Function,...rest):void {
			fncClickFunction = pFunction;
			arrParams = rest;
		}
		
		public function setPopUpMenu(pMenu:Menu):void {
			mnuPopUp = pMenu;
			//
		}
		
		override public function dispose():void {
			btnThis.removeEventListener(MouseEvent.ROLL_OVER,rollOver);
			btnThis.removeEventListener(MouseEvent.ROLL_OUT,rollOut);
			btnThis.removeEventListener(MouseEvent.CLICK,click);
			super.dispose();
		}
		
		///getters and setters
		public function set id(pStrId:String):void {
			strID = pStrId;
		}
		
		public function get id():String {
			return strID;
		}
		
		public function get lockeable():Boolean {
			return isLockeable;
		}
		public function set lockeable(pIsLockeable:Boolean):void {
			isLockeable = pIsLockeable;
		}
		
		public function get active():Boolean {
			return isActive;
		}
		public function set active(pIsActive:Boolean):void {
			isActive = pIsActive;
		}
	}
}