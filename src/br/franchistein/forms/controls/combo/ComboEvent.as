package br.franchistein.forms.controls.combo
{
	import flash.events.Event;
	
	public class ComboEvent extends Event
	{
		public static var ON_CHANGE				:String = "comboChange";
		public static var ON_SELECT				:String = "comboSelect";
		public static var ON_COMBO_OPEN			:String = "comboOpen";
		public static var ON_COMBO_CLOSE		:String = "comboClose";
		
		public var combo 						:Combo;
		
		public var value						:*
		public var label						:String
		
		public function ComboEvent(type:String,combo:Combo,bubbles:Boolean=false,cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.combo = (combo == null) ? null : combo;
			/* this.value = (combo == null && combo.selectedItem==null) ? null : combo.selectedItem.value;
			this.label = (combo == null && combo.selectedItem==null) ? null : combo.selectedItem.label; */
		}
	}
	
}