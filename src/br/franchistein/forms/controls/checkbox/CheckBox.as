package br.franchistein.forms.controls.checkbox
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * 
	 * @author Caio Franchi
	 * 
	 */
	public dynamic class CheckBox extends MovieClip implements IEventDispatcher
	{
		private var objValue				:*
		
		private var strLabel				:String
		
		private var isChecked				:Boolean = false;
		private var isEnabled 				:Boolean = true;
		
		public var txtLabel					:TextField;
		
		private var dspThis					:CheckBox;
		
		private var dspEventCreator			:EventDispatcher;
		
		
		//TODO: deixar genérico e receber parametros de plugins para a interface
		public function CheckBox(pIsChecked:Boolean=false)
		{
			super();
			dspThis = this
			dspEventCreator = new EventDispatcher(dspThis);
			
			//
			if(pIsChecked) check = true;
			//
			dspThis.addEventListener(MouseEvent.CLICK,onClickCheckBox);
		}
		//METHODS
		public function dispose():void {
			dspThis.removeEventListener(MouseEvent.CLICK,onClickCheckBox);
		}
		private function verifyEnabled():void {
			if(isEnabled)
				dspThis.mouseChildren = dspThis.mouseEnabled = true;
			else dspThis.mouseChildren = dspThis.mouseEnabled = false;
		}
		private function verifyChecked():void {
			if(isChecked)
				dspThis.gotoAndStop(2);
			else dspThis.gotoAndStop(1);
		}
		//EVENTS
		private function onClickCheckBox(e:MouseEvent=null):void {
			if(isChecked){
				check= false;
			} else {
				check= true;
			}
			verifyChecked();
			//
			dispatchEvent(new CheckBoxEvent(CheckBoxEvent.ON_CLICK,dspThis));
		}
		//GETTER AND SETTERS
		public function get check():Boolean {
			return isChecked;
		}
		public function set check(pCheck:Boolean):void {
			isChecked = pCheck
			verifyChecked();
		}
		//
		public function get value():* {
			return objValue;
		}
		public function set value(pNewValue:*):void {
			objValue = pNewValue;
		}
		//
		public function get label():String {
			return strLabel;
		}
		public function set label(pNewValue:String):void {
			//
			txtLabel.autoSize = TextFieldAutoSize.LEFT
			txtLabel.mouseEnabled = false;
			txtLabel.htmlText = strLabel = pNewValue;		
		}
		//
		override public function get enabled():Boolean {
			return isEnabled;
		}
		override public function set enabled(pNewValue:Boolean):void {
			isEnabled = pNewValue;
			verifyEnabled();
		}
		//INTERACE METHODS
		/* override public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			dspEventCreator.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		override public function dispatchEvent(evt : Event) : Boolean {
			return dspEventCreator.dispatchEvent(evt);
		}

		override public function hasEventListener(type : String) : Boolean {
			return dspEventCreator.hasEventListener(type);
		}

		override public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			dspEventCreator.removeEventListener(type, listener, useCapture);
		}

		override public function willTrigger(type : String) : Boolean {
			return dspEventCreator.willTrigger(type);
		} */
	}
}