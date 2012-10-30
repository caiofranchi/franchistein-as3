package br.franchistein.tracking.modules
{
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	
	import flash.display.DisplayObject;

	public class AnalyticsModule
	{
		
		public const ID						:String = "GA";
		
		public var DEBUG					:Boolean = false;
	
		protected var 			tracker		:AnalyticsTracker
		
		public function AnalyticsModule(pStrUA:String,pReference:DisplayObject,pIsDebug:Boolean)
		{
			tracker = new GATracker(pReference, pStrUA , "AS3", pIsDebug ); 
		}
		
		public function pageView(pStrValue:String):void {
			tracker.trackPageview(pStrValue);
		}
		
		public function pageEvent(pStrValue:String,pStrAction:String,pStrLabel:String=null,pNumValue:Number=NaN):void {
			tracker.trackEvent(pStrValue,pStrAction,pStrLabel,pNumValue);
		}
	}
}