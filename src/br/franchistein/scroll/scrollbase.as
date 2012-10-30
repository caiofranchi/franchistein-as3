package br.franchistein.scroll
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class scrollbase extends Sprite
	{
		private var _content			:Sprite 			= new Sprite;
		private var _contMask			:Sprite			= new Sprite;
		private var _dragger			:Sprite 			= new Sprite;
		private var _scrollbar			:Sprite 			= new Sprite;
		
		private var _movSetaUp			:Sprite 			= new Sprite;
		private var _movSetaDown		:Sprite 			= new Sprite;
		
		private var scrollPercent		:Number				= new Number(0);
		private var numFalseValue		:Number 			= 0;
		
		private var isResizeable		:Boolean;
		
		private var stgReference		:Stage;
		
		private var _speed				:uint;
		private var _padding			:uint;
		private var _verticalDirection	:Boolean = true;
		public function scrollbase(pStageReference:Stage,content:Sprite, contMask:Sprite, dragger:Sprite, scrollbar:Sprite,pUp:Sprite=null,pDown:Sprite=null, speed:uint = 5, padding:uint = 0,pIsResizeable:Boolean = true ,pVerticalDirection:Boolean = true):void
		{
			stgReference = pStageReference;
			_content 			= content;
			_contMask			= contMask;
			_dragger 			= dragger;
			_scrollbar 			= scrollbar;
			_padding			= padding;
			_speed				= speed;			
			//_content.mask 		= _contMask;	
			if(_verticalDirection){
				_content.x 			= _contMask.x;
			}else{
				_content.y 			= _contMask.y;
			}
			
			_dragger.y 			= _scrollbar.y;
			
			_movSetaUp         	= pUp
			_movSetaDown       	= pDown
			
			_dragger.buttonMode = true;	
			
			isResizeable = pIsResizeable;	
			
			_verticalDirection = pVerticalDirection
			/* Events					_____________________________________________*/	
				
			_dragger.addEventListener(MouseEvent.MOUSE_DOWN, moveDrag);
			
			_scrollbar.addEventListener(MouseEvent.CLICK, moveDragPercent);
			stgReference.addEventListener(MouseEvent.MOUSE_WHEEL, moveContentWheel);
			
			if(_movSetaUp!=null) {
				_movSetaUp.buttonMode = true;
				_movSetaUp.addEventListener(MouseEvent.MOUSE_DOWN,onClickUp);
			}
			if(_movSetaDown!=null) {
				_movSetaDown.buttonMode = true;
				_movSetaDown.addEventListener(MouseEvent.MOUSE_DOWN,onClickDown);
			}
			
			/* if need use Scrollbar	_____________________________________________*/
			
			verifyHeight();
		}
		public function onClickUp(e:MouseEvent=null):void {
			stgReference.addEventListener(MouseEvent.MOUSE_UP, releaseDrag);
			_movSetaUp.addEventListener(Event.ENTER_FRAME,onMovingUp,false,0,true);		
			_movSetaUp.addEventListener(MouseEvent.MOUSE_UP,function(e:Event):void {
				_movSetaUp.removeEventListener(MouseEvent.MOUSE_UP,arguments.callee);
				_movSetaUp.removeEventListener(Event.ENTER_FRAME,onMovingUp);
			});	
		}
		public function onClickDown(e:MouseEvent=null):void {
			stgReference.addEventListener(MouseEvent.MOUSE_UP, releaseDrag);
			_movSetaDown.addEventListener(Event.ENTER_FRAME,onMovingDown,false,0,true);	
			_movSetaDown.addEventListener(MouseEvent.MOUSE_UP,function(e:Event):void {
				_movSetaDown.removeEventListener(MouseEvent.MOUSE_UP,arguments.callee);
				_movSetaDown.removeEventListener(Event.ENTER_FRAME,onMovingDown);
			});
			
		}
		private function onMovingUp(e:Event):void {
			if(_verticalDirection){
				if(_dragger.y>_scrollbar.y+1){
					_dragger.y -= .3;
					moveContent(null);
				}else if(_dragger.y-_scrollbar.y<1) {
					_dragger.y = _scrollbar.y;
					moveContent(null);		
				}
			}else{
				if(_dragger.x>_scrollbar.x+1){
					_dragger.x -= .3;
					moveContent(null);
				}else if(_dragger.x-_scrollbar.x<1) {
					_dragger.x = _scrollbar.x;
					moveContent(null);		
				}
			}
			
		}
		private function onMovingDown(e:Event):void {
			if(_verticalDirection){
				if(_dragger.y+_dragger.height<_scrollbar.y+_scrollbar.height){
					_dragger.y += .3;
					moveContent(null);
				}
			}else{
				if(_dragger.x+_dragger.width<_scrollbar.x+_scrollbar.width){
					_dragger.x += .3;
					moveContent(null);
				}
			}
		}
		
		public function stop():void {
			stgReference.removeEventListener(Event.ENTER_FRAME, moveContent);
			_dragger.removeEventListener(MouseEvent.MOUSE_DOWN, moveDrag);
			stgReference.removeEventListener(MouseEvent.MOUSE_UP, releaseDrag);
			_scrollbar.removeEventListener(MouseEvent.CLICK, moveDragPercent);
			stgReference.removeEventListener(MouseEvent.MOUSE_WHEEL, moveContentWheel);
		}
		
		/* 
		When the mouse_down into the dragger clip function
		Execute function to drag scroll slider 
		*/
		
		private function moveDrag(m:MouseEvent):void
		{
			var newRect:Rectangle;
			if(_verticalDirection){
				newRect = new Rectangle(_scrollbar.x,_scrollbar.y,0,_scrollbar.height - _dragger.height);
			}else{
				newRect = new Rectangle(_scrollbar.x,_scrollbar.y,_scrollbar.width - _dragger.width,0);
			}
			
			_dragger.startDrag(false,newRect);
			
			/* Moving the content together when move the dragger */		
			_dragger.addEventListener(MouseEvent.MOUSE_MOVE, function():void 
			{
				stgReference.addEventListener(Event.ENTER_FRAME, moveContent);
			});
			stgReference.addEventListener(MouseEvent.MOUSE_UP, releaseDrag);
		}
		
		/*
		Execute release Drag to stop all enter frame function
		and stop the content scroll
		*/
		
		private function releaseDrag(m:MouseEvent):void
		{
			_dragger.stopDrag();
			//Utils.movPrincipal.stage.removeEventListener(Event.ENTER_FRAME, moveContent);
			//moveContent(null);
			if(_movSetaUp!=null) _movSetaUp.removeEventListener(Event.ENTER_FRAME,onMovingUp);
			if(_movSetaDown!=null) _movSetaDown.removeEventListener(Event.ENTER_FRAME,onMovingDown);
			stgReference.removeEventListener(MouseEvent.MOUSE_UP, releaseDrag);
		}
		
		/*
		CLICK IN THE SCROLL AND GOTO
		When click on the scroll will
		jump to position with out slide
		the dragger Sprite
		*/
		
		private function moveDragPercent(m:MouseEvent):void
		{
			if(_verticalDirection){
				_dragger.y = _scrollbar.y+_scrollbar.mouseY;			
			}else{
				_dragger.x = _scrollbar.x+_scrollbar.mouseX;			
			}
			
			stgReference.addEventListener(Event.ENTER_FRAME, moveContent);
		}
		
		public function moveToPercent(pPorcentagem:Number):void {
			if(_verticalDirection){
				_dragger.y = (pPorcentagem*((_scrollbar.height-_dragger.height)+_scrollbar.y))/100
			}else{
				_dragger.x = (pPorcentagem*((_scrollbar.width-_dragger.width)+_scrollbar.x))/100
			}
			
			stgReference.addEventListener(Event.ENTER_FRAME, moveContent);
		}
		public function refreshFalseValue(pFalseValue:Number):void {
			numFalseValue = pFalseValue;
			//verifyHeight();
			moveContent();
		}
		/*
		Execute this function using EnterFrame when moveDrag is working
		*/
		
		private function moveContent(e:Event=null):void
		{
			/* Verify if dragger is inside the background */
			if(_verticalDirection){
				if ( _dragger.y > ( (_scrollbar.y + _scrollbar.height) - _dragger.height )) _dragger.y = (_scrollbar.y + _scrollbar.height) - _dragger.height;
				if ( _dragger.y < _scrollbar.y ) _dragger.y = _scrollbar.y;
				scrollPercent = ( 100 / ( _scrollbar.height - _dragger.height ) ) * ( _dragger.y - _scrollbar.y );
			}else{
				if ( _dragger.x > ( (_scrollbar.x + _scrollbar.width) - _dragger.width )) _dragger.x = (_scrollbar.x + _scrollbar.width) - _dragger.width;
				if ( _dragger.x < _scrollbar.x ) _dragger.x = _scrollbar.x;
				scrollPercent = ( 100 / ( _scrollbar.width - _dragger.width ) ) * ( _dragger.x - _scrollbar.x );
			}
			
			
			/* Scroll Move */
			
			
			
			var acty:Number;
			if(_verticalDirection){
				acty = Number(_content.y);
			}else{
				acty = Number(_content.x);
			}
			
			var endy:Number;
			if(_verticalDirection){
				if(numFalseValue>0){
					endy = Number(_contMask.y + ( ( _contMask.height - numFalseValue - _padding ) / 100 ) * scrollPercent);
				}else {
					endy = Number(_contMask.y + ( ( _contMask.height - (_content.height+40) - _padding ) / 100 ) * scrollPercent);
				}
				_content.y += (endy - acty) / _speed;
			}else{
				if(numFalseValue>0){
					endy = Number(_contMask.x + ( ( _contMask.width - numFalseValue - _padding ) / 100 ) * scrollPercent);
				}else {
					endy = Number(_contMask.x + ( ( _contMask.width - (_content.width+40) - _padding ) / 100 ) * scrollPercent);
				}
				_content.x += (endy - acty) / _speed;
			}
			 
			
			
			
			//verifyHeight();
		}
		
		/*
		Using Mouse Wheel
		*/
		
		private function moveContentWheel(m:MouseEvent):void
		{
			
			if (_content.hitTestPoint(mouseX,mouseY)  ) //mouseX > _contMask.x && mouseX < _contMask.x + _contMask.width && mouseY > _contMask.y && mouseY < _contMask.y + _contMask.height
			{
				if(_verticalDirection){
					_dragger.y -= ( m.delta * 5 );
				}else{
					_dragger.x -= ( m.delta * 5 );
				}
				
				moveContent(null);
			}
			
		}
		
		/*
		Verify if need or not the content
		If content is smaller than mask 
		will not show the scrollbase
		*/
		
		public function verifyHeight():void
		{
			var numHeight:Number = (numFalseValue>0) ? numFalseValue : (_verticalDirection)?_content.height:_content.width;
			var numHeightBarra:Number ;
			if(_verticalDirection){
				if ( _contMask.height >numHeight )
				{
					_dragger.visible = false;
					_scrollbar.visible = false;
					try{
						_movSetaUp.visible = false;
						_movSetaDown.visible = false;
					}catch(e:Error){}
				}
				else
				{
					_dragger.visible = true;
					_scrollbar.visible = true;
					
					try{
						_movSetaUp.visible = true;
						_movSetaDown.visible = true;
					}catch(e:Error){}
					/* Change the dragger size */				
					numHeightBarra = ((_contMask.height / numHeight) * _scrollbar.height);
					if(numHeightBarra<10) numHeightBarra = 10
					if(isResizeable) _dragger.height = numHeightBarra;
					
				}
			}else{
				if ( _contMask.width > numHeight )
				{
					//_dragger.visible = false;
					//_scrollbar.visible = false;
					try{
						_movSetaUp.visible = false;
						_movSetaDown.visible = false;
					}catch(e:Error){}
				}
				else
				{
					
					//_dragger.visible = true;
					//_scrollbar.visible = true;
					try{
						_movSetaUp.visible = true;
						_movSetaDown.visible = true;
					}catch(e:Error){}
					
					
					/* Change the dragger size */				
					numHeightBarra = ((_contMask.width /numHeight) * _scrollbar.width);
					
					if(numHeightBarra<10) numHeightBarra = 10
					if(isResizeable) _dragger.width = numHeightBarra;
					
				}
				
			}
			
		}

	}
}