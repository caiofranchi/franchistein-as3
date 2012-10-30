package br.franchistein.tracking
{

	public dynamic class TrackingControl
	{
		private static var arrHistory		:Array = new Array();
		private static var objHolder		:Object = new Object();
		
		public function TrackingControl()
		{
			throw new Error("This class is a singleton and cannot be instantiated");
		}
		
		public static function addTrackingModule(pID:String,pObj:*):void {
			objHolder[pID] = pObj;
		}
		//
		public static function execute(pStrModuleID:String,pStrMethodName:String,...rest):void {
			try {
				var fncFunction:Function = objHolder[pStrModuleID][pStrMethodName];
				fncFunction.apply(null,rest);
				//
				arrHistory.push(pStrModuleID+"-"+pStrMethodName+"-"+rest.toString());
			}catch(e:Error){
				throw new Error("O módulo <"+pStrModuleID+"> não pode ser executado."+e.message,e.errorID)
			}
		}
	}
}