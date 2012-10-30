package br.franchistein.utils
{
	/**
	 * 	Classe criada para facilitar a manipulação de Array. 
	 * 
	 * 	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 	@author Caio Franchi
	 *	@tiptext
	 */	
	public class ArrayUtils
	{		
		public static function randomArray(pArrRandomize:Array):Array {
			var newArray:Array = new Array();
			
			while(pArrRandomize.length > 0){
				newArray.push(pArrRandomize.splice(Math.floor(Math.random()*pArrRandomize.length), 1)[0]);
			}
			
			return newArray;
		}
		public static function removeItemByIndex(pIntIndex:int,pArray:Array):void {
			pArray.splice(pIntIndex,1);
		}
		//Navigating between arrays of objects
		public static function returnIndexByParam(pName:String,pParam:String,pArray:Array):Number {
			var found:Number = -1;
			
			for(var i:int=0;i<pArray.length;i++){
				if(pName==pArray[i][pParam]) found = i;
			}
			
			return found;
		}		
		public static function returnItemByParam(pStrToFind:*,pParamName:String,pArray:Array):Object {
			var found:Object = new Object();
			
			for(var i:int=0;i<pArray.length;i++){				
				if(pStrToFind==pArray[i][pParamName]) found = pArray[i];
			}
			
			return found;
		}
		public static function returnListByParam(pStrToFind:*,pParamName:String,pArray:Array):Array {
			var arrList:Array = new Array();
			
			for(var i:int=0;i<pArray.length;i++){
				if(pStrToFind==pArray[i][pParamName]) arrList.push(pArray[i]);
			}
			return arrList;
		}
		
		/**
		 *	Determines whether the specified array contains the specified VALUE.	
		 * 
		 * 	@param arr The array that will be checked for the specified value.
		 *
		 *	@param value The object which will be searched for within the array
		 * 
		 * 	@return Boolean if the array contains the value, False if it does not.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */			
		public static function containValue(arr:Array, value:Object):Boolean
		{
			return (arr.indexOf(value) != -1);
		}	
		
		/**
		 *	Determines whether the specified array contains the specified OBJECT.	
		 * 
		 * 	@param arr The array that will be checked for the specified object.
		 *
		 *	@param value The object which will be searched for within the array
		 * 
		 * 	@return Boolean if the array contains the object, False if it does not.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */			
		public static function findObject(arr:Array, value:Object):int
		{
			var _numRetorno:int = -1;
			for(var i:int=0;i<arr.length;i++){
				if(value==arr[i]) return i;
			}
			return _numRetorno
		}
		
		/**
		 *	Creates a copy of the specified array.
		 * 
		 * 	@param pArrToDuplicate The array that will be duplicated
		 *
		 *	@return Returns a new array
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */			
		public static function duplicateArray(pArrToDuplicate:Array):Array
		{	
			return pArrToDuplicate.slice();
		}
		
		/**
		 *	Verify if two determined array are equals to each other
		 * 
		 * 	@param arr1 First array to be compared
		 *
		 * 	@param arr2 Second array to be compared
		 *
		 *	@return Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */		
		public static function isEqual(arr1:Array, arr2:Array):Boolean
		{
			if(arr1.length != arr2.length)
			{
				return false;
			}
			
			var len:Number = arr1.length;
			
			for(var i:Number = 0; i < len; i++)
			{
				if(arr1[i] !== arr2[i])
				{
					return false;
				}
			}
			
			return true;
		}
		
		public static function toArray(iterable:*):Array {
			var ret:Array = [];
			for each (var elem:* in iterable) ret.push(elem);
			return ret;
		}
		
		public static function countValues(pArr:Array):Array {
			var z:int, x:int = pArr.length, c:Boolean = false, a:Array = [], d:Array = [];
			while (x--)
			{
				z = 0;
				while (z < x)
				{
					if (pArr[x] == pArr[z])
					{
						c = true;
						d.push (pArr[x]);
						break;
					}
					z++;
				}
				if (!c) a.push ([pArr[x], 1]);
				else c = false;
			}
			var y:int = a.length;
			var q:int;
			while (y--)
			{
				q = 0;
				while (q < d.length)
				{
					if (a[y][0] == d[q]) a[y][1]++;
					q++;
				}
			}
			return a;
		}
	}
}