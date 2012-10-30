function add_linkage(doc){ 
	
	var base=prompt('Choose a base class','flash.display.MovieClip');
	var package=prompt('Choose a package or live it blank','');
	
	if(base==null || package==null){
		alert('Command cancelled by user');
	}
	
	if(package!=''){
		package+='.';
		//remove double points and spaces from package name and lower its case
		package=package.split('..').join('.').split(' ').join('').toLowerCase();
	}
	
	var library=doc.library;
	var items=library.items;
	var items_length=items.length;
	for( var h = 0; h < items_length; h++){
		var item=items[h];
		if(item.itemType=='movie clip'){
			
			if(item.linkageExportForAS==false){
				
				//extract class name from the item name
				var class_name=item.name.substr(item.name.lastIndexOf('/')+1);
				//force first letter to be uppercase				
				class_name=class_name.substr(0,1).toUpperCase()+class_name.substr(1); 
				//remove points and spaces
				class_name=class_name.split('.').join('').split(' ').join('');
				
				//sum and set it up
				item.linkageExportForAS=true;
				item.linkageClassName=package+class_name;
				item.linkageBaseClass=base;
				
			}
		}
	}
}

add_linkage(fl.getDocumentDOM());