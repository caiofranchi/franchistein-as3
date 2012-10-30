package br.franchistein.utils
{
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	/**
	 * 	ClassUtils contain utilitary static methods for working with classes
	 *  
	 * 	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 	@author Caio Franchi
	 *  @version 0.1b
	 *	@tiptext
	 */	
	public class ClassUtils 
	{
		/**
		 *	Clones an object and returns it
		 * 
		 * 	@param pObjectType The type of the objects that will be disposed
		 *
		 *	@return Object Return de duplicated object
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public static function clone(pObject:Object):Object {
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(pObject);
			byteArray.position = 0;
			//
			return byteArray.readObject();
		}
		
		/**
		 *	Find a specific linkage inside a loaded display object
		 * 
		 * 	@param pMovieBase The display object loaded from another .swf
		 * 
		 *  @param pLinkage The name of the linkage
		 *
		 *	@return Class return the founded class
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public static function getClassByMovieLoaded(pMovieBase:DisplayObject,pLinkage:String):Class {
			try {
				return pMovieBase.loaderInfo.applicationDomain.getDefinition(pLinkage) as Class
			}catch(e:Error){
				throw new Error("Classe '"+pLinkage+"' não encontrada no "+pMovieBase);
			}
			return null;
		}	
		
		public static function getClassName(o:Object):String
		{
			var fullClassName:String = getQualifiedClassName(o);
			return fullClassName.slice(fullClassName.lastIndexOf("::")+2);
		}
		
		public static function getFullClassName(o:Object):String
		{
			var fullClassName:String = getQualifiedClassName(o);
			return StringUtils.basicReplace(fullClassName,"::","."); 
		}
		
		public static function getSuperClassName(o: Object): String {
			var n: String = getQualifiedSuperclassName(o);
			if(n == null) return(null);
			return  n.slice(n.lastIndexOf("::")+2);
		}
		
		public static function getClassByObject(pObj:Object,pMovDomainReference:DisplayObject):Class {
			return getClassByMovieLoaded(pMovDomainReference,getFullClassName(pObj));
		}
		
		public static function packageCleaner(fullClassName:String):String {
			return fullClassName.slice(fullClassName.lastIndexOf("::")+2);
		}
		
		public static function verifyInheritance(pObjObject:Object,pClassName:String):Boolean {
			var xmlExtends:XMLList = describeType(pObjObject)..extendsClass;
			var _isFounded:Boolean = false;
			//
			for(var i:int=0;i<xmlExtends.length();i++){
				var _strFiltrado:String = ClassUtils.packageCleaner(String(xmlExtends[i].@type).toLowerCase());
				if(_strFiltrado==pClassName.toLowerCase()) return true
			}
			//
			return _isFounded
		}
		
		public static function listInheritances(pObjObject:Object):Array {
			var xmlExtends:XMLList = describeType(pObjObject)..extendsClass;
			var _arrInheritances:Array = [];
			//
			for(var i:int=0;i<xmlExtends.length();i++){
				_arrInheritances.push(ClassUtils.packageCleaner(String(xmlExtends[i].@type).toLowerCase()));
			}
			//
			return _arrInheritances
		}
		
		/**
		 *	This method helps the creation of classes with dynamic constructors
		 * 
		 * 	@param type The class that will be called
		 * 
		 *  @param arguments The list of parameters that will be generated
		 *
		 *	@return Object created
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public static function generateDynamicConstructor(type:Class, ...arguments):* {
			if (arguments.length > 10)
				throw new Error('Um método aceita no máximo 10 parâmetros');
			
			switch (arguments.length) {
				case 0 :
					return new type();
				case 1 :
					return new type(arguments[0]);
				case 2 :
					return new type(arguments[0], arguments[1]);
				case 3 :
					return new type(arguments[0], arguments[1], arguments[2]);
				case 4 :
					return new type(arguments[0], arguments[1], arguments[2], arguments[3]);
				case 5 :
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4]);
				case 6 :
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]);
				case 7 :
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6]);
				case 8 :
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7]);
				case 9 :
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8]);
				case 10 :
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8], arguments[9]);
			}
		}
	}
}