package br.franchistein.navigation.library
{
	import br.franchistein.utils.ArrayUtils;
	import br.franchistein.utils.ClassUtils;
	
	import flash.display.MovieClip;
	
	public dynamic class Library extends Array
	{		
		public static var arrMainItems				:Array = [];
		//
		public var name								:String;
		private var arrItems						:Array = [];
		
		//INTERNALS
		public function Library(pStrName:String="")
		{
			super();
			name = pStrName;
			arrItems = this;
		}
		//adding
		public function addItemToLibrary(pItem:*,pStrItemName:String):* {
			push({item:pItem,name:pStrItemName,type:"item"});
			//
			return pItem;
		}
		public function addSwfToLibrary(pMov:MovieClip,pStrLibName:String):MovieClip {
			push({item:pMov,name:pStrLibName,type:"swf"});
			//
			return pMov;
		}
		public function addGroupToLibrary(pStrGroupName:String,pArrItems:Library=null):void {
			var libRecursiva:Library = new Library(pStrGroupName);
			push({item:libRecursiva,name:pStrGroupName,type:"lib"});
			//
			try{
				if(pArrItems!=null){
					for (var i:int = 0; i < pArrItems.length; i++)
					{
						libRecursiva.addItemToLibrary(pArrItems[i].item,pArrItems[i].name);
					}
				}
			} catch(e:Error){
				throw new Error("Erro ao tentar processar a lista de items para o grupo: "+pStrGroupName+","+e.message);
			}
			//
		}
		public function addItemToGroup(pStrItemName:String,pItem:*,pStrGroupName:String):* {
			var libInterna:Library = ArrayUtils.returnItemByParam(pStrGroupName,"name",this).item;
			libInterna.addItemToLibrary(pItem,pStrItemName);
			//
			return pItem;
		}
		public function setThisAsMainLibrary():void {
			Library.arrMainItems = this;
		}
		//getting		
		public function getItem(pStrItemName:String):* {
			return ArrayUtils.returnItemByParam(pStrItemName,"name",this).item;
		}
		public function getItems():Array {
			return this;
		}
		public function getItemFromGroup(pStrItemName:String,pStrGroupName:String):* {
			var libInterna:Library = ArrayUtils.returnItemByParam(pStrGroupName,"name",this).item;
			//
			return libInterna.getItem(pStrItemName);
		}
		public function getItemsFromGroup(pStrGroupName:String):Array {
			var libInterna:Library = ArrayUtils.returnItemByParam(pStrGroupName,"name",this).item;
			if(libInterna==null) libInterna = new Library(); 
			//
			return libInterna.getItems();
		}
		public function getItemFromSwf(pStrItemName:String,pStrSwfName:String):Class {
			return ClassUtils.getClassByMovieLoaded(getItem(pStrSwfName) as MovieClip,pStrItemName);
		}
		
		//removing
		public function removeSwfFromLibrary(pStrLibName:String):MovieClip {
			var _intEncontrado:int = ArrayUtils.returnIndexByParam(pStrLibName,"name",this);
			var item:MovieClip = this[_intEncontrado].item;
			//
			ArrayUtils.removeItemByIndex(_intEncontrado,this);
			//
			return item;
		}
		public function removeGroup(pStrGroupName:String):Library {
			var _intEncontrado:int = ArrayUtils.returnIndexByParam(pStrGroupName,"name",this);
			var libInterna:Library = this[_intEncontrado].item;
			//
			ArrayUtils.removeItemByIndex(_intEncontrado,this);
			//
			return libInterna;
		}
		public function removeItemFromGroup(pStrItemName:String,pStrGroupName:String):* {
			var libInterna:Library = ArrayUtils.returnItemByParam(pStrGroupName,"name",this).item;
			//
			//
			return libInterna.removeItemFromLibrary(pStrItemName);
		}
		public function removeItemFromLibrary(pStrItemName:String):* {
			var _intEncontrado:int = ArrayUtils.returnIndexByParam(pStrItemName,"name",this);
			var item:* = this[_intEncontrado].item;
			//
			ArrayUtils.removeItemByIndex(_intEncontrado,this);
			//
			return item;
		}
		
		
		//STATICS
		public static function addItemToMainLibrary(pItem:*,pStrItemName:String):* {
			arrMainItems.push({item:pItem,name:pStrItemName,type:"item"});
			//
			return pItem;
		}
		public static function addItemToGroup(pStrItemName:String,pItem:*,pStrGroupName:String):* {
			var libInterna:Library = ArrayUtils.returnItemByParam(pStrGroupName,"name",arrMainItems).item;
			libInterna.addItemToLibrary(pItem,pStrItemName);
			//
			return pItem;
		}
		public static function addGroupToLibrary(pStrGroupName:String,pArrItems:Library=null):void {
			var libRecursiva:Library = new Library(pStrGroupName);
			arrMainItems.push({item:libRecursiva,name:pStrGroupName,type:"lib"});
			//
			try{
				if(pArrItems!=null){
					for (var i:int = 0; i < pArrItems.length; i++)
					{
						libRecursiva.addItemToLibrary(pArrItems[i].item,pArrItems[i].name);
					}
				}
			} catch(e:Error){
				throw new Error("Erro ao tentar processar a lista de items para o grupo: "+pStrGroupName+","+e.message);
			}
			//
		}
		//
		public static function getItemFromGroup(pStrItemName:String,pStrGroupName:String):* {
			var libInterna:Library = ArrayUtils.returnItemByParam(pStrGroupName,"name",arrMainItems).item;
			//
			return libInterna.getItem(pStrItemName);
		}
		public static function getItemFromMainLibrary(pStrItemName:String):* {
			return ArrayUtils.returnItemByParam(pStrItemName,"name",arrMainItems).item;
		}
		public static function getItemsFromGroup(pStrGroupName:String):Array {
			var libInterna:Library = ArrayUtils.returnItemByParam(pStrGroupName,"name",arrMainItems).item;
			if(libInterna==null) libInterna = new Library(); 
			//
			return libInterna.getItems();
		}
		//AUX
	}
}