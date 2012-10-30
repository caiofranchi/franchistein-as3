package br.franchistein.forms.controls.checkbox
{
	import flash.events.Event;
	
	public class CheckBoxEvent extends Event
	{
		public static var ON_CLICK	:String = "checkboxChange";
		
		public var checkBox 		:CheckBox;
		
		public function CheckBoxEvent(type:String,checkBox:CheckBox,bubbles:Boolean=false,cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.checkBox = (checkBox == null) ? null : checkBox;
		}
	}
	
}