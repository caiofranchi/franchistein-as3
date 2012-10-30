package br.franchistein.scroll.elements
{
	import br.franchistein.scroll.ScrollDirections;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	public class ScrollDrag extends DisplayObject
	{
		public var dspThis				:DisplayObject;
		//
		public var numOriginalHeight	:Number;
		public var numOriginalWidth		:Number;
		//
		public var rectDrag				:Rectangle;
		//
		public function ScrollDrag()
		{
			setDragBarInstance(this);			
		}
		public function setDragBarInstance(pDspInstance:DisplayObject):void {
			dspThis = pDspInstance;
			//saving the initial size of the dragbar
			numOriginalHeight = dspThis.height;
			numOriginalWidth = dspThis.width;
		}
		
		//getting the drag rectangle
		public function getDragRect(pStrDirection:String,pNumSize:Number):Rectangle {
			if(pStrDirection==ScrollDirections.VERTICAL){
				rectDrag = new Rectangle(dspThis.x,dspThis.y,0,pNumSize);
			}else if(pStrDirection == ScrollDirections.HORIZONTAL) {
				rectDrag = new Rectangle(dspThis.x,dspThis.y,pNumSize,0);
			}
			return rectDrag;
		}
		//
		public function resetSize():void {
			//turning back the original size of the dragbar
			dspThis.height = numOriginalHeight;
			dspThis.width = numOriginalWidth;
			//
		}
	}
}