package br.franchistein.utils
{
	public class XMLUtils
	{
		public static function sortXMLByAttribute(pXMLOrdenar:XML, pStrAttribute:String, pObjOptions:Object=null, pIsCopy:Boolean=false):XML
		{
			//store in array to sort on
			var xmlArray:Array	= new Array();
			
			var item:XML;
			
			for each(item in pXMLOrdenar.children())
			{
				var object:Object = {data: item, order: StringUtils.removeAccents(item.attribute(pStrAttribute))};
				xmlArray.push(object);
			}
			
			xmlArray.sortOn('order',pObjOptions);
			
			var sortedXmlList:XMLList = new XMLList();
			var xmlObject:Object;
			for each(xmlObject in xmlArray )
			{
				sortedXmlList += xmlObject.data;
			}
			
			if(pIsCopy)
			{
				return	pXMLOrdenar.copy().setChildren(sortedXmlList);
			}
			else
			{
				return pXMLOrdenar.setChildren(sortedXmlList);
			}
		}
		
		public static function sortXMLByNode(pXMLOrdenar:XML, pStrNode:String, pObjOptions:Object=null, pIsCopy:Boolean=false):XML
		{
			//store in array to sort on
			var xmlArray:Array	= new Array();
			
			var item:XML;
			
			for each(item in pXMLOrdenar.children())
			{
				var object:Object = {data: item, order: StringUtils.removeAccents(item[pStrNode])};
				xmlArray.push(object);
			}
			
			xmlArray.sortOn('order',pObjOptions);
			
			var sortedXmlList:XMLList = new XMLList();
			var xmlObject:Object;
			for each(xmlObject in xmlArray )
			{
				sortedXmlList += xmlObject.data;
			}
			
			if(pIsCopy)
			{
				return	pXMLOrdenar.copy().setChildren(sortedXmlList);
			}
			else
			{
				return pXMLOrdenar.setChildren(sortedXmlList);
			}
		}
	}
}