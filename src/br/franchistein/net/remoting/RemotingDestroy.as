package br.franchistein.net.remoting
{
	
	//NATIVAS
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	
	//PRÓPRIAS
	//import destroy.remoting.RemotingDestroyEvents;
	
	
	/**
	* RemotingDestroy - Destroy Family
	* @author CAIO FRANCHI - http://www.caiofranchi.com.br
	* @version 1.1
	*/
	public class RemotingDestroy extends NetConnection
	{
		//VARS
		private var strClasse					:String;
		private var strGateway					:String;
		
		private var objResponder		        :Responder = new Responder(onResult, onError);
		
		private var uintEncoding				:uint;
		
		private var arrRequests					:Array = new Array();
		
		private var isDoingRequest				:Boolean = false;
		
		private var intRequestAtual				:int = 0;
		
		//CONSTANSTES
		private static const STR_VERSION		:String = "1.1b";
				
		public function RemotingDestroy(pGateway:String,pClasse:String,pEncoding:uint=0) 
		{
			strGateway = pGateway;
			strClasse = pClasse;
			uintEncoding = pEncoding;
			uintEncoding = ObjectEncoding.AMF3;
			
			//Calling the superclass
			super();
			connect(strGateway);
			
			defaultObjectEncoding = uintEncoding;
			
		}
		//isDoingRequest
		//currentRequest
		//retry
		//returnStatus
		//
		public function doRequest(pMethod:String,pObject:Object = null,...params):void {
			var _strMethod:String = pMethod;
			var _objExtra:Object = new Object();
			if(pObject!=null) _objExtra = pObject; //Contains, onStart,onResult and other additional information for the developer's use.
			_objExtra.order =  intRequestAtual;
			
			var strCaminhoClasse:String;
			if(strClasse!=null && strClasse !=""){
				strCaminhoClasse =	strClasse + "." + _strMethod;
			}else {
				strCaminhoClasse =	_strMethod;
			}
			
			var fncCall:Function = call;
			var _arrTemp:Array = new Array(strCaminhoClasse,objResponder);
			var _arrTempNovo:Array = _arrTemp.concat(params);
			
			
			fncCall.apply(null,_arrTempNovo);
					
			if (_objExtra.onInit != null)
			{
				_objExtra.onInit();
			}
			
			//Working with the information
			_objExtra.method = _strMethod;
			_objExtra.status = "initialized";
			arrRequests.push(_objExtra);
			//
			isDoingRequest = true;
		}
		public function reset():void {
			arrRequests = new Array();
			isDoingRequest = false;
			
			close();
			connect(strGateway);
			
			defaultObjectEncoding = uintEncoding;
		}
		private function throwError(pError:Error):void {
			
		}
		//HANDLERS
		private function onResult(pObj:*):void {
			var _objExtra:Object = arrRequests[intRequestAtual];
			arrRequests[intRequestAtual].status = "complete";
			
			if (_objExtra.onResult != null)
			{
				_objExtra.onResult(pObj);
			}
			
			isDoingRequest = false;
			intRequestAtual++;
		}		
		private function onError(...params:*):void {
			var _objExtra:Object = arrRequests[intRequestAtual];
			arrRequests[intRequestAtual].status = "error";
			
			if (_objExtra.onError != null)
			{
				_objExtra.onError(params);
			}		
			
			isDoingRequest = false;		
			intRequestAtual++;
		}
		//GETS AND SETTERS
		public function get currentRequest():Object {
			return arrRequests[intRequestAtual];
		}
		public function get requestList():Array {
			return arrRequests;
		}
		public function get currentVersion():String {
			return STR_VERSION;
		}
		public function get isOperating():Boolean {
			return isDoingRequest;
		}
		public function get totalRequests():int {
			return arrRequests.length;
		}
		public function get currentClass():String {
			return strClasse;
		}
		public function set currentClass(pClasse:String):void {
			if(pClasse!=null && pClasse.length>0){
				strClasse = pClasse;
			}
		}
	}
	
}