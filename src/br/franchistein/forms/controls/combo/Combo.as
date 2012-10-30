package br.franchistein.forms.controls.combo
{
	import br.franchistein.scroll.scrollbase;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextFieldAutoSize;

	/**
	 * 
	 * @author Caio Franchi
	 * @version 0.2a
	 */
	public dynamic class Combo extends MovieClip implements IEventDispatcher
	{
		private var arrConteudo					:Array = []
		
		private var strSampleText				:String = "";
		private var strSentidoAbertura			:String = "";
		
		private var numMaxAlturaItems			:Number = 90;
		private var numSelectedItem				:Number = -1;
		private var numIntervaloFechamento		:Number;
		private var numAceleracao				:Number = 1;
		private var numVelocidadeScroll			:Number = 0;
		
		private var scrRolagem					:br.franchistein.scroll.scrollbase;
		
		private var isComboOpened				:Boolean = false;
		private var isComboEnabled				:Boolean = true;
		
		private var clsBotaoLinkage				:Class;
		
		private var movThis						:Combo;
		
		private const NUM_AREA_SCROLL			:Number = 100;
		//
		public function Combo()
		{	
			movThis = this;
			//
			movThis.movHitArea.buttonMode = true;
			movThis.movHitArea.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void {
				if(isComboOpened){
					closeCombo();
				}else {
					openCombo();
				}
			});
			//
			enabled = false;
		}
		public function config(pClassBotaoLinkage:Class,pBaseText:String="",pStrSentidoAbertura:String="BAIXO"):void {
			//
			setBaseText(pBaseText);
			//
			linkageButton = pClassBotaoLinkage;
			//
			sentidoAbertura = pStrSentidoAbertura;
			//
			if(strSentidoAbertura=="CIMA") {
				movThis.movBoxCombo.y = movThis.movBaseCombo.y+movThis.movBaseCombo.height;
				movThis.movMask.y = -movThis.movMask.height;
			} else if(strSentidoAbertura=="BAIXO"){
				movThis.movMask.y = movThis.movBaseCombo.y+movThis.movBaseCombo.height;
				movThis.movBoxCombo.y = -movThis.movBoxCombo.height
			}
			//
		}
		public function setBaseText(pStrSampleText:String= ""):void {
			strSampleText = pStrSampleText;
			movThis.txtSelect.text = strSampleText;
		}
		public function reset():void {
			closeCombo();
			deselect();
			//
			numSelectedItem = -1;
			for(var i:int =0;i<arrConteudo.length;i++){
				var movBotaoCombo:MovieClip = movThis.movBoxCombo.movContainerItems.getChildByName("movBotaoCombo"+i) as MovieClip;
				movThis.movBoxCombo.movContainerItems.removeChild(movBotaoCombo);
			}
		}
		private function build():void {
			//populando o combo
			var numY:Number = 4;
			for(var i:int =0;i<arrConteudo.length;i++){
				var movBotaoCombo:MovieClip = new clsBotaoLinkage();
				movBotaoCombo.name = "movBotaoCombo"+i;
				movBotaoCombo.txtLabel.autoSize = TextFieldAutoSize.LEFT;
				movBotaoCombo.txtLabel.text = arrConteudo[i].label;
				movBotaoCombo.movFundo.height = movBotaoCombo.txtLabel.textHeight+5;
				movBotaoCombo.mouseChildren = false;
				movBotaoCombo.buttonMode = true;
				movBotaoCombo.numIndice = i;
				movBotaoCombo.alpha = .7;
				//
				movBotaoCombo.y = numY
				//
				numY += movBotaoCombo.movFundo.height + 3;
				
				movThis.movBoxCombo.movContainerItems.addChild(movBotaoCombo);
				
				//TODO: Criar os eventos da classe
				movBotaoCombo.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void {
					selectItemByIndex((e.currentTarget as MovieClip).numIndice);
					dispatchEvent(new ComboEvent(ComboEvent.ON_SELECT,movThis));
				});
				movBotaoCombo.addEventListener(MouseEvent.ROLL_OVER,function(e:MouseEvent):void {
					var movAtual:MovieClip = e.currentTarget as MovieClip;
					TweenLite.to(movAtual.movFundo,.3,{alpha:1});
				});
				movBotaoCombo.addEventListener(MouseEvent.ROLL_OUT,function(e:MouseEvent):void {
					var movAtual:MovieClip = e.currentTarget as MovieClip;
					TweenLite.to(movAtual.movFundo,.3,{alpha:0});
				});
			}
			//
			//movThis.movContainerItems.movFundo.alpha = 0;
			movThis.movBoxCombo.movContainerItems.movFundo.height = numY+ movBotaoCombo.height+5;
			//movThis.movContainerItems.movFundo.height = 1
			
			//movThis.movBoxCombo.y = movThis.movBoxCombo.movFundo.height;
			if(numY<movThis.movMask.height) {
				//trace('sim',numY,"--",movThis.movBoxCombo.movFundo.height);
				movThis.movBoxCombo.movFundo.height = movBotaoCombo.y+ movBotaoCombo.height+10; //Math.round(numY)+1;
			}else {
				movThis.movBoxCombo.movFundo.height = movThis.movMask.height //-10; //-movThis.movBaseCombo.height
			}
		}
		private function onEnterFrameScroll(e:Event):void {
			//if(movThis.movMask.hitTestPoint(movThis.mouseX,movThis.mouseY,true)) trace('sim');
			if(movThis.mouseY < -movThis.movMask.height + NUM_AREA_SCROLL){
				numVelocidadeScroll = 5;
			}else if(movThis.mouseY > movThis.movMask.y - NUM_AREA_SCROLL){
				numVelocidadeScroll = -5;
			}else {
				numVelocidadeScroll = 0;
			}
			movThis.movContainerItems.y += numVelocidadeScroll;
			//TweenLite.to(movThis.movContainerItems,.5,{y:movThis.movContainerItems.y+numVelocidadeScroll,ease:Strong.easeOut});
			if(movThis.movContainerItems.y<0) {
				movThis.movContainerItems.y = 0;
			}else if(movThis.movContainerItems.y>movThis.movContainerItems.height-movThis.movMask.height){
				movThis.movContainerItems.y = movThis.movContainerItems.height-movThis.movMask.height;
			}
		}
		public function populate(pArrObjetos:Array):void {
			arrConteudo = pArrObjetos;
			//
			enabled = true;
			build();
		}
		public function selectItemByIndex(pNumIndex:Number):void {
			closeCombo();
			if(_numIndexSelecionar==numSelectedItem) return;
			var _numIndexSelecionar:Number = pNumIndex;
			//
			//
			movThis.txtSelect.text = arrConteudo[_numIndexSelecionar].label;
			
			//
			numSelectedItem  = _numIndexSelecionar;
			
			//
			dispatchEvent(new ComboEvent(ComboEvent.ON_CHANGE,movThis));
		}
		public function selectItemByValue(pValue:*):void {
			
			var _strLinha:String = ""
			var _numFound:Number = -1;
			for(var i:int =0;i<arrConteudo.length;i++){
				_strLinha += "-   -"+arrConteudo[i].value+";"+arrConteudo[i].label;
				if(arrConteudo[i].value==pValue) _numFound = i; //selectItemByIndex(i);
				//return;
			}
			if(_numFound>-1) selectItemByIndex(_numFound);
			//ExternalInterface.call("alert",_strLinha);
		}
		public function deselect():void {
			//
			movThis.txtSelect.text = strSampleText;
			numSelectedItem = -1;
			//
			if(isComboOpened) closeCombo();
		}
		public function openCombo():void {
			isComboOpened = true;
			//
			//TweenLite.to(movThis.movAtivaCombo,1,{rotation:180,ease:Strong.easeInOut});
			
			var _numY:Number;
			if(strSentidoAbertura=="CIMA") {
				_numY = -movThis.movBoxCombo.movFundo.height
			} else if(strSentidoAbertura=="BAIXO"){
				_numY = movThis.movBaseCombo.y + movThis.movBaseCombo.height
			}
			TweenLite.to(movThis.movBoxCombo,1,{y:_numY,ease:Strong.easeInOut,onComplete:function():void {
				dispatchEvent(new ComboEvent(ComboEvent.ON_COMBO_OPEN,movThis))
			}});
			
			/* clearTimeout(numIntervaloFechamento);
			numIntervaloFechamento = setTimeout(closeCombo,4000); */
			
			//ativando a rolagem especial
			if(movThis.movBoxCombo.movContainerItems.height>movThis.movMask.height){
				//movThis.movMask.addEventListener(MouseEvent.ROLL_OVER,function(e:MouseEvent):void {
				
				movThis.movBoxCombo.movScroll.visible = true;
				//scrRolagem.verifyHeight();
				//refreshFalseValue = movThis.movBoxCombo.movContainerItems.height+50 
				//});
				try {
					scrRolagem = new scrollbase(movThis.stage,movThis.movBoxCombo.movContainerItems,movThis.movBoxCombo.movMask,movThis.movBoxCombo.movScroll.movDrag,movThis.movBoxCombo.movScroll.movScrollBackground,movThis.movBoxCombo.movScroll.movSetaUp,movThis.movBoxCombo.movScroll.movSetaDown,3);
				}catch(e:Error){
					scrRolagem = new scrollbase(movThis.stage,movThis.movBoxCombo.movContainerItems,movThis.movBoxCombo.movMask,movThis.movBoxCombo.movScroll.movDrag,movThis.movBoxCombo.movScroll.movScrollBackground,null,null,3);
				}
				scrRolagem.moveToPercent(0);
				scrRolagem.verifyHeight();
			}else {
				movThis.movBoxCombo.movScroll.visible = false;
				try {
				scrRolagem.stop();
				}catch(e:Error){}
				movThis.movBoxCombo.movContainerItems.y = 0;
			}
			
		}
		public function closeCombo():void {
			isComboOpened = false;
			//
			//TweenLite.to(movThis.movAtivaCombo,1,{rotation:0,ease:Strong.easeInOut});
			
			//deletando a rolagem especial
			try {
				scrRolagem.stop();
			}catch(e:Error){}
			//movThis.movBoxCombo.movScroll.visible = false;
			
			var _numY:Number;
			if(strSentidoAbertura=="CIMA") {
				_numY = movThis.movBoxCombo.movFundo.height
			} else if(strSentidoAbertura=="BAIXO"){
				_numY = -movThis.movBoxCombo.movFundo.height
			}
			TweenLite.to(movThis.movBoxCombo,1,{y:_numY,ease:Strong.easeInOut,onComplete:function():void {
				dispatchEvent(new ComboEvent(ComboEvent.ON_COMBO_CLOSE,movThis))
			}});
			
			//clearTimeout(numIntervaloFechamento);
			try{
				movThis.movMask.removeEventListener(Event.ENTER_FRAME,onEnterFrameScroll);
			}catch(e:Error){}
			
			
		}
		//GETTERS AND SETTERS
		public function set linkageButton(pClsLinkage:Class):void {
			clsBotaoLinkage = pClsLinkage;		
		}
		public function get linkageButton():Class {
			return clsBotaoLinkage;
		}
		public function set sentidoAbertura(pStrSentidoAbertura:String):void {
			strSentidoAbertura = pStrSentidoAbertura;		
		}
		public function get sentidoAbertura():String {
			return strSentidoAbertura;
		}
		override public function get enabled():Boolean {
			return isComboEnabled;
		}
		override public function set enabled(pBoolean:Boolean):void {
			if(pBoolean){
				movThis.alpha = 1;
			}else {
				movThis.alpha = .5;
			}
			movThis.mouseEnabled = movThis.mouseChildren = pBoolean;
			isComboEnabled = pBoolean;
		}
		public function get selectedItem():Object {
			return arrConteudo[numSelectedItem];
		}
		public function get selectedIndex():int {
			return numSelectedItem;
		}
	}
}