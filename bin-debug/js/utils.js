var popAtual;
var intervaloPopLogin;

function disparaTrack(pStrTag) {
	_gaq.push(['_trackPageview',pStrTag]);
}

function popUp(pURL,nWidth, nHeight){
	popAtual = window.open(pURL,'pop','width='+nWidth+',height='+nHeight+', scrollbars=yes');
	void(0);
}

function getFlashMovie(movieName) {
	var isIE = navigator.appName.indexOf("Microsoft") != -1;   return (isIE) ? window[movieName] : document[movieName];
}

function getAPICode() {
    var strAPI;

    switch (getBaseURL()) {
        case "nextel-seumundoagora-dev.one.com.br":
            strAPI = '270939219594293';
            break;
		case "www.nextelseumundoagora.com.br":
            strAPI = '276503239036979';
            break;
		case "nextel-seumundoagora-hml.one.com.br":
			strAPI = '180462542035017';
			break;
		case "nextel-seumundoagora-qa.one.com.br":
			strAPI = '214318891969339';
			break;
	}
    return strAPI;
}

function getBaseURL() {
	var strActualPath = window.location.hostname;

	return strActualPath;
}

function getQueryString(name) {
    if(location.href.indexOf("?") ==-1 || location.href.indexOf(name+'=')==-1)
	    { return ; }
	
		    var queryString = location.href.substring(location.href.indexOf("?")+1);
		    var parameters = queryString.split("&");
		    var pos, paraName, paraValue;
		
		    for(var i=0; i<parameters.length; i++)
		    {
		    pos = parameters[i].indexOf('=');
		    if(pos == -1) { continue; }
		    paraName = parameters[i].substring(0, pos);
		    paraValue = parameters[i].substring(pos + 1);
	    if(paraName == name)
	    { 
			return unescape(paraValue.replace(/\+/g, " ")); }
	    }
    return ;
}

function checaPopLogin() {
	try {		
		if(popAtual.status=="logado"){
			clearInterval(intervaloPopLogin)
			popAtual.close();	
			getFlashMovie("Site").enviaUsuarioConectado();	
					
		}else if (popAtual.status == "negado") {
			clearInterval(intervaloPopLogin);
			popAtual.close();
			getFlashMovie("Site").enviaUsuarioError();		
		}
	}catch(e){
		//esta sob o dominio do facebook
	}
}


function connectFacebook() {
	intervaloPopLogin = setInterval("checaPopLogin();",200)
	popUp("http://"+getBaseURL()+"/services/login.aspx",850,500);
}

function postToFriendWall(pNumIndiceAmigo,pLink,pMessage,pTo){
    // calling the API ...
    var obj = {
      method: 'feed',
      to: pTo,
      link: pLink,
      picture: 'http://'+getBaseURL()+'/images/compartilhe.jpg',
      name: 'Nextel seu mundo. Agora',
      caption: ' ',
      description: pMessage
    };

    function callback(response) {
      //document.getElementById('msg').innerHTML = "Post ID: " + response['post_id'];
    }

    FB.ui(obj, callback);
	
}

function embedSWF() {
	
	if (swfobject.hasFlashPlayerVersion("10")) {
		
		var objVars = {id:"" };
		
		var objParams = {menu:"false",allowscriptaccess:"always",wmode:"opaque",allowFullScreen:"true",scale:"noScale"};
		//
		swfobject.embedSWF("PreloaderInicial.swf", "Site", "1080", "670", "10","playerProductInstall.swf",objVars,objParams);
		//versão resize
		//swffit.fit("Site", 1000, 590); //990,880
		
	}else{
		
		window.open("Mobile/","_self");
		
	}
}