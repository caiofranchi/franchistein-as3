/*
careful this script is recursive
upon finding flash files it will open and publish them.
*/


var FLA_URI
var outputURI;

/*
 * start off by asking the user what folder they want to recurse
 */
function init()
{
    var folderURI = fl.browseForFolderURL("Please select the folder you want to recurse");
    if (folderURI == null) return;
   
    outputURI = fl.browseForFolderURL("Please select the folder you want to publish to if non selected it will publish locally");
 
    checkFolderForFiles( folderURI );
}


/*
 * pass in a folder it checks for the recursion
 */
function checkFolderForFiles( passedDirName )
{

    fl.trace(passedDirName);
           
    // ---- CHECK
    checkFolderForFlashFilesAndExportThem( passedDirName );
   
    // ---- THE RECURSION
    var folderContents = FLfile.listFolder( passedDirName );
    for( var j=0; j<folderContents.length; j++ )
    {
        if( folderContents[j].indexOf( "." , 0 ) < 0 )
        {  
           var folder = passedDirName + "/" + folderContents[j];
         
        //  fl.trace("folder"+folder);
           
           checkFolderForFiles( folder );
        }
    }
   
}


/*
 * this bits see's if there's any fla's
 */
function checkFolderForFlashFilesAndExportThem( passedDirName )
{        
        // CHECK IF THE FOLDER HAS FLASH
        var folderContents = FLfile.listFolder( passedDirName );        
        var hasFlash = false;
        for( var i=0; i<folderContents.length; i++ )
        {
            if( folderContents[i].substr(folderContents[i].length-4) == ".fla" ) hasFlash = true;
        }
        if(!hasFlash) return;

        // PUBLISH ANY FLA's
        for( var i=0; i < folderContents.length; i++ )
        {      
            FLA_URI = passedDirName + "/" + folderContents[i];
            if (FLA_URI.substr(FLA_URI.length-4) != ".fla") continue; // MOVE PAST THIS ONE IF ITS NOT A FLASH FILE
         
          //  fl.trace(FLA_URI);
         
            fl.openDocument(FLA_URI);
            var myDoc_doc = fl.getDocumentDOM();
           
           
            if(outputURI == null)
            {
                var swfURI = FLA_URI.substr( 0, FLA_URI.lastIndexOf(".") ) + ".swf"; // we want ours to strip the last xx digits off
            }else
            {
                var swfURI = FLA_URI.substr( 0, FLA_URI.lastIndexOf(".") ) + ".swf"; // we want ours to strip the last xx digits off
                var changeIt = outputURI + FLA_URI.substr( FLA_URI.lastIndexOf("/") );
                swfURI = changeIt;
            }
                       
            myDoc_doc.exportSWF(swfURI,true);
            myDoc_doc.close(false);
        }

}


init(); // run the thing