package br.franchistein.utils
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;

	public class StringUtils
	{
		public function StringUtils()
		{
		}
		
		//ENCODING
		public static function htmlUnescape(str:String):String
		{
			return new XMLDocument(str).firstChild.nodeValue;
		}
		
		public static function htmlEscape(str:String):String
		{
			return XML( new XMLNode( XMLNodeType.TEXT_NODE, str ) ).toXMLString();
		}
		
		public static function convertToFacebookURL(pStrURLCompartilhamento:String,pIsCacheBuster:Boolean=false):String {
			var _strURLFinal:String = "";
			var _strURLBase:String = "http://www.facebook.com/sharer.php?u="
				
			_strURLFinal = _strURLBase + encodeURIComponent(pStrURLCompartilhamento);
			
			if(pIsCacheBuster) _strURLFinal += "&ch="+String(new Date())
			//http://www.facebook.com/sharer.php?u=
			return _strURLFinal
		}
		
		public static function convertToOrkutURL(pStrTitle:String,pStrImagem:String,pStrTexto:String,pStrLink:String):String {
			var _strURLFinal:String = "";
			var _strURLBase:String = "http://promote.orkut.com/preview?nt=orkut.com&tt="
			//"http://promote.orkut.com/preview?nt=orkut.com&tt=Nextel e Fabio Assunção: “Ser feliz é ser quem você é”&tn=http://www.bemvindoaoclube.com.br/img/fabio_assuncao/fabio_compartilhe.jpg&cn=";
			//Olha%20a%20atua%C3%A7%C3%A3o%20que%20esse%20maluco%20fez%20com%20o%20Dr.%20Saulo.%20Ser%C3%A1%20que%20ele%20leva%20jeito%20para%20estrela%20de%20cinema%3F%20Confira%20";
			_strURLFinal = _strURLBase+pStrTitle+"&tn="+pStrImagem+"&cn="+encodeURIComponent(pStrTexto)+"&du="+pStrLink;
				
			return _strURLFinal;
		}
		
		public static function convertToTwitterURL(pStrTexto:String):String {
			var _strTextoConverter:String = pStrTexto;
			var _strTextoConvertido:String;
			var _strBaseURL:String = "http://twitter.com/?status="
			//
			_strTextoConvertido = _strBaseURL + encodeURIComponent(pStrTexto);
			//
			return _strTextoConvertido
		}
		
		public static function convertToGooglePlus(pStrMessage:String):String {
			var _strBase:String = "https://m.google.com/app/plus/x/?v=compose&content="+encodeURIComponent(pStrMessage);
			//var _strBase:String = "window.open('https://m.google.com/app/plus/x/?v=compose&content="+encodeURIComponent(pStrMessage)+"','gplusshare','width=450,height=300,left='+(screen.availWidth/2-225)+',top='+(screen.availHeight/2-150)+'');return false;";
			return _strBase;
		}
		
		public static function convertHTMLEntities(str:String):String {
			var htmlEntities:Array = ["&nbsp;", "&iexcl;", "&cent;", "&pound;", "&curren;", "&yen;", "&brvbar;", "&sect;", "&uml;", "&copy;", "&ordf;", "&laquo;", "&not;", "&shy;", "&reg;", "&macr;", "&deg;", "&plusmn;", "&sup2;", "&sup3;", "&acute;", "&micro;", "&para;", "&middot;", "&cedil;", "&sup1;", "&ordm;", "&raquo;", "&frac14;", "&frac12;", "&frac34;", "&iquest;", "&Agrave;", "&Aacute;", "&Acirc;", "&Atilde;", "&Auml;", "&Aring;", "&AElig;", "&Ccedil;", "&Egrave;", "&Eacute;", "&Ecirc;", "&Euml;", "&Igrave;", "&Iacute;", "&Icirc;", "&Iuml;", "&ETH;", "&Ntilde;", "&Ograve;", "&Oacute;", "&Ocirc;", "&Otilde;", "&Ouml;", "&times;", "&Oslash;", "&Ugrave;", "&Uacute;", "&Ucirc;", "&Uuml;", "&Yacute;", "&THORN;", "&szlig;", "&agrave;", "&aacute;", "&acirc;", "&atilde;", "&auml;", "&aring;", "&aelig;", "&ccedil;", "&egrave;", "&eacute;", "&ecirc;", "&euml;", "&igrave;", "&iacute;", "&icirc;", "&iuml;", "&eth;", "&ntilde;", "&ograve;", "&oacute;", "&ocirc;", "&otilde;", "&ouml;", "&divide;", "&oslash;", "&ugrave;", "&uacute;", "&ucirc;", "&uuml;", "&yacute;", "&thorn;", "&yuml;", "&fnof;", "&Alpha;", "&Beta;", "&Gamma;", "&Delta;", "&Epsilon;", "&Zeta;", "&Eta;", "&Theta;", "&Iota;", "&Kappa;", "&Lambda;", "&Mu;", "&Nu;", "&Xi;", "&Omicron;", "&Pi;", "&Rho;", "&Sigma;", "&Tau;", "&Upsilon;", "&Phi;", "&Chi;", "&Psi;", "&Omega;", "&alpha;", "&beta;", "&gamma;", "&delta;", "&epsilon;", "&zeta;", "&eta;", "&theta;", "&iota;", "&kappa;", "&lambda;", "&mu;", "&nu;", "&xi;", "&omicron;", "&pi;", "&rho;", "&sigmaf;", "&sigma;", "&tau;", "&upsilon;", "&phi;", "&chi;", "&psi;", "&omega;", "&thetasym;", "&upsih;", "&piv;", "&bull;", "&hellip;", "&prime;", "&Prime;", "&oline;", "&frasl;", "&weierp;", "&image;", "&real;", "&trade;", "&alefsym;", "&larr;", "&uarr;", "&rarr;", "&darr;", "&harr;", "&crarr;", "&lArr;", "&uArr;", "&rArr;", "&dArr;", "&hArr;", "&forall;", "&part;", "&exist;", "&empty;", "&nabla;", "&isin;", "&notin;", "&ni;", "&prod;", "&sum;", "&minus;", "&lowast;", "&radic;", "&prop;", "&infin;", "&ang;", "&and;", "&or;", "&cap;", "&cup;", "&int;", "&there4;", "&sim;", "&cong;", "&asymp;", "&ne;", "&equiv;", "&le;", "&ge;", "&sub;", "&sup;", "&nsub;", "&sube;", "&supe;", "&oplus;", "&otimes;", "&perp;", "&sdot;", "&lceil;", "&rceil;", "&lfloor;", "&rfloor;", "&lang;", "&rang;", "&loz;", "&spades;", "&clubs;", "&hearts;", "&diams;", "\"", "&", "<", ">", "&OElig;", "&oelig;", "&Scaron;", "&scaron;", "&Yuml;", "&circ;", "&tilde;", "&ensp;", "&emsp;", "&thinsp;", "&zwnj;", "&zwj;", "&lrm;", "&rlm;", "&ndash;", "&mdash;", "&lsquo;", "&rsquo;", "&sbquo;", "&ldquo;", "&rdquo;", "&bdquo;", "&dagger;", "&Dagger;", "&permil;", "&lsaquo;", "&rsaquo;", "&euro;"];
			var numberEntities:Array = [" ", "¡", "¢", "£", "¤", "¥", "¦", "§", "¨", "©", "ª", "«", "¬", "­", "®", "¯", "°", "±", "²", "³", "´", "µ", "¶", "·", "¸", "¹", "º", "»", "¼", "½", "¾", "¿", "À", "Á", "Â", "Ã", "Ä", "Å", "Æ", "Ç", "È", "É", "Ê", "Ë", "Ì", "Í", "Î", "Ï", "Ð", "Ñ", "Ò", "Ó", "Ô", "Õ", "Ö", "×", "Ø", "Ù", "Ú", "Û", "Ü", "Ý", "Þ", "ß", "à", "á", "â", "ã", "ä", "å", "æ", "ç", "è", "é", "ê", "ë", "ì", "í", "î", "ï", "ð", "ñ", "ò", "ó", "ô", "õ", "ö", "÷", "ø", "ù", "ú", "û", "ü", "ý", "þ", "ÿ", "ƒ", "Α", "Β", "Γ", "Δ", "Ε", "Ζ", "Η", "Θ", "Ι", "Κ", "Λ", "Μ", "Ν", "Ξ", "Ο", "Π", "Ρ", "Σ", "Τ", "Υ", "Φ", "Χ", "Ψ", "Ω", "α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ", "λ", "μ", "ν", "ξ", "ο", "π", "ρ", "ς", "σ", "τ", "υ", "φ", "χ", "ψ", "ω", "ϑ", "ϒ", "ϖ", "•", "…", "′", "″", "‾", "⁄", "℘", "ℑ", "ℜ", "™", "ℵ", "←", "↑", "→", "↓", "↔", "↵", "⇐", "⇑", "⇒", "⇓", "⇔", "∀", "∂", "∃", "∅", "∇", "∈", "∉", "∋", "∏", "∑", "−", "∗", "√", "∝", "∞", "∠", "∧", "∨", "∩", "∪", "∫", "∴", "∼", "≅", "≈", "≠", "≡", "≤", "≥", "⊂", "⊃", "⊄", "⊆", "⊇", "⊕", "⊗", "⊥", "⋅", "⌈", "⌉", "⌊", "⌋", "〈", "〉", "◊", "♠", "♣", "♥", "♦", "\"", "&", "<", ">", "Œ", "œ", "Š", "š", "Ÿ", "ˆ", "˜", " ", " ", " ", "‌", "‍", "‎", "‏", "–", "—", "‘", "’", "‚", "“", "”", "„", "†", "‡", "‰", "‹", "›", "€"];
			//
			var i:uint = htmlEntities.length;
			while (i--) {
				str = str.split(htmlEntities[i]).join(numberEntities[i]);
			}
			return str;
		}
		
		public static function removeAccents(str:String,pIsRemoveSpace:Boolean=true):String{
			var arrPatterns:Array = [];
			arrPatterns.push( { pattern:/[äáàâãª]/g,  char:'a' } );
			arrPatterns.push( { pattern:/[ÄÁÀÂÃ]/g,  char:'A' } );
			arrPatterns.push( { pattern:/[ëéèê]/g,   char:'e' } );
			arrPatterns.push( { pattern:/[ËÉÈÊ]/g,   char:'E' } );
			arrPatterns.push( { pattern:/[íîïì]/g,   char:'i' } );
			arrPatterns.push( { pattern:/[ÍÎÏÌ]/g,   char:'I' } );
			arrPatterns.push( { pattern:/[öóòôõº]/g,  char:'o' } );
			arrPatterns.push( { pattern:/[ÖÓÒÔÕ]/g,  char:'O' } );
			arrPatterns.push( { pattern:/[üúùû]/g,   char:'u' } );
			arrPatterns.push( { pattern:/[ÜÚÙÛ]/g,   char:'U' } );
			arrPatterns.push( { pattern:/[ç]/g,   char:'c' } );
			arrPatterns.push( { pattern:/[Ç]/g,   char:'C' } );
			arrPatterns.push( { pattern:/[ñ]/g,   char:'n' } );
			arrPatterns.push( { pattern:/[Ñ]/g,   char:'N' } );
			
			for( var i:uint = 0; i < arrPatterns.length; i++ ){
				
				str = str.replace( arrPatterns[i].pattern, arrPatterns[i].char );
				
			}
			if(pIsRemoveSpace) str = basicReplace(str," ","");
			
			return str;
			
		}
		
		public static function IsNumeric( inputStr : String ) : Boolean {
			var obj:RegExp = /^(0|[1-9][0-9]*)$/;
			return obj.test(inputStr);
		}
		
		public static function extractFileExtension(file:String):String {
			var extensionIndex:Number = file.lastIndexOf(".");
			if (extensionIndex == -1) {
				//No extension
				return "";
			} else {
				return file.substr(extensionIndex + 1,file.length);
			}
		}
		
		//FORMATING
		public static function formatSecondsToMinutes(pSegundos:Number):String {
			var _numSeconds:Number =  Math.floor(pSegundos);			
			var numSeconds:Number = Math.floor(_numSeconds)%60;
			var numMinutes:Number = Math.floor(_numSeconds/60);
			//
			var strSeconds:String
			var strMinutes:String
			//
			strSeconds = putZeroIfNeeded(numSeconds);
			strMinutes = putZeroIfNeeded(numMinutes);
			//
			return strMinutes+":"+strSeconds;
		}
		
		public static function putZeroIfNeeded(pNum:Number):String {
			return (pNum<10) ? "0"+pNum.toString() : pNum.toString(); 			
		};
		
		//
		public static function basicReplace(pText:String,pStrFrom:String,pStrTo:String):String {
			return pText.split(pStrFrom).join(pStrTo);
		}
		
		public static function multipleReplace(pText:String,pArrFrom:Array,pArrTo:Array):String {
			var _strTemp:String = pText;
			
			for(var i:int=0;i<pArrFrom.length;i++){
				_strTemp = basicReplace(_strTemp,pArrFrom[i],pArrTo[i]);
			}
			
			return _strTemp;
		}
		
		public static function truncateText(pText:String,pLimit:int,useWordBoundary:Boolean):String{
			
			var toLong:Boolean = pText.length>pLimit;
				
			var s_:String = toLong ? pText.substr(0,pLimit-1) : pText;
			
			s_ = useWordBoundary && toLong ? s_.substr(0,s_.lastIndexOf(' ')) : s_;
			
			return  toLong ? s_ +'...' : s_;
			
		};

		
		public static  function resizeTextToFit(txt:TextField,pMaxWidth:int,pMaxHeight:int):void 
		{
			//You set this according to your TextField's dimensions
			var maxTextWidth:int = pMaxWidth; 
			var maxTextHeight:int = pMaxHeight; 
			
			var f:TextFormat = txt.getTextFormat();
			
			//decrease font size until the text fits  
			while (txt.textWidth > maxTextWidth || txt.textHeight > maxTextHeight) {
				f.size = int(f.size) - 1;
				txt.setTextFormat(f);
			}
			
		}
		//VALIDATING
		public static function isCPFValido(cpfVal:String):Boolean {
			
			//criamos arrays dos pesos
			var Peso1:Array = ["10", "9", "8", "7", "6", "5", "4", "3", "2"];
			var Peso2:Array = ["11", "10", "9", "8", "7", "6", "5", "4", "3", "2"];
			
			// criamos as variáveis que nos auxiliarão no cálculo dos dígitos verificadores
			var soma1:Number = new Number ();
			var resto1:Number = new Number ();
			var soma2:Number = new Number ();
			var resto2:Number = new Number ();
			var digito1:Number = new Number ();
			var digito2:Number = new Number ();
			// utilizamos o for com o incremento i ( i++ )
			for (var i:uint = 0; i < Peso1.length; i++) {
				soma1 += Number(cpfVal.charAt (i)) * Number(Peso1[i]);
			}
			// o cálculo do resto é feito utilizando o operador % ( porcentagem )
			// que retorna o resto da divisão da soma por 11
			resto1 = soma1 % 11;
			// criamos a condicão para o caso do resultado ser menor ou igual a 1
			if (resto1 <= 1) {
				// se for o digito verificador é igual a 0 ( zero )
				digito1 = 0;
			} else {
				// senão é igual a 11 menos o resto
				digito1 = 11 - resto1;
			}
			// agora o cálculo do segundo dígito que segue o mesmo padrão anterior
			for (var j:uint = 0; j < Peso2.length; j++) {
				soma2 += Number(cpfVal.charAt (j)) * Number(Peso2[j]);
			}
			resto2 = soma2 % 11;
			if (resto2 <= 1) {
				digito2 = 0;
			} else {
				digito2 = 11 - resto2;
			}
			// chegamos então a nossa condição final
			// se o décimo digito - cpfVal.charAt(9) - for igual ( o símbolo == )
			// ao dígito verificador calculado ou ...
			// se o décimo digito - cpfVal.charAt(10) - for igual ao dígito verificador calculado ou ...
			// o tamanho da número digitado for igual de onze algarismos
			// lembrando que o charAt(9) indica a décima "casa" ( posição )
			// porque a primeira "casa" é sempre 0 ( zero )
			if (Number(cpfVal.charAt (9)) == digito1 && Number(cpfVal.charAt (10)) == digito2 && cpfVal.length == 11) {
				// se todas as condições estiverem ok
				// você pode acrescentar aqui outras ações do tipo ir para algum frame
				// enviar as informações para o servidor
				// etc
				return true;
			} else {
				// senão ...
				return false;
			}
			
		}
		
		public static function isEmailValido():Boolean {
			return true;
		}
		
		public static function checkPasswordStrength(pStrPassword:String):Number {
			// 0 to 4
			var _strength : Number = 0;
			
			var _regSmall : RegExp = new RegExp( /([a-z]+)/ );
			var _regBig : RegExp = new RegExp( /([A-Z]+)/ );
			var _regNum	: RegExp = new RegExp( /([0-9]+)/ );
			var _regSpecial : RegExp = new RegExp( /(\W+)/ );
			
			
			if( pStrPassword.search( _regSmall ) != -1 ) _strength ++;
			if( pStrPassword.search( _regBig ) != -1 ) _strength ++;
			if( pStrPassword.search( _regNum ) != -1 ) _strength ++;
			if( pStrPassword.search( _regSpecial ) != -1 ) _strength ++;
			
			return _strength;
		}
		
		
		//ENCODING TEMPPP
		/** TEMPPP
		 * Does proper UTF-8 encoding
		 */
		public static function utf8Encode(string:String):String {
			string = string.replace(/\r\n/g, '\n');
			string = string.replace(/\r/g, '\n');
			
			var utfString:String = '';
			
			for (var i:int = 0 ; i < string.length ; i++)
			{
				var chr:Number = string.charCodeAt(i);
				if (chr < 128)
				{
					utfString += String.fromCharCode(chr);
				}
				else if ((chr > 127) && (chr < 2048))
				{
					utfString += String.fromCharCode((chr >> 6) | 192);
					utfString += String.fromCharCode((chr & 63) | 128);
				}
				else
				{
					utfString += String.fromCharCode((chr >> 12) | 224);
					utfString += String.fromCharCode(((chr >> 6) & 63) | 128);
					utfString += String.fromCharCode((chr & 63) | 128);
				}
			}
			
			return utfString;
		}
		
		/**
		 * Does the URL encoding
		 */
		public static function urlEncode(string:String):String {
			var urlString:String = '';
			
			for (var i:int = 0 ; i < string.length ; i++)
			{
				var chr:Number = string.charCodeAt(i);
				
				if ((chr >= 48 && chr <= 57) || // 09
					(chr >= 65 && chr <= 90) || // AZ
					(chr >= 97 && chr <= 122) || // az
					chr == 45 || // -
					chr == 95 || // _
					chr == 46 || // .
					chr == 126) // ~
				{
					urlString += String.fromCharCode(chr);
				}
				else
				{
					urlString += '%' + chr.toString(16).toUpperCase();
				}
			}
			
			return urlString;
		}
		
		/**
		 * Properly URL encodes a string, taking into account UTF-8
		 */
		public static function encode(string:String):String {
			return urlEncode(utf8Encode(string));
		}
		
		/**
		 * Decodes a string from a URL compliant format.
		 * 
		 * @param encodedString String to be decoded
		 */
		public static function decode(encodedString:String):* {
			var output:String = encodedString;
			var myregexp:RegExp = /(%[^%]{2})/;
			
			var binVal:Number;
			var thisString:String;
			
			var match:Object;
			
			// change "+" to spaces
			var plusPattern:RegExp = /\+/gm;
			output = output.replace(plusPattern," ");
			
			// convert all other characters
			while ((match = myregexp.exec(output)) != null && match.length > 1 && match[1] != '') {
				binVal = parseInt(match[1].substr(1),16);
				thisString = String.fromCharCode(binVal);
				output = output.replace(match[1], thisString);
			}
			
			return output;
		}
	}
}