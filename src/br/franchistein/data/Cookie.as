package br.franchistein.data 
{
	import flash.net.SharedObject;
	//
	public class Cookie
	{
		/* Flash cookie */
		public function Cookie() 
		{
			throw new Error("Cookie class has static methods. No need for instatiation.");
		}
		
		/**
		 * Store local cookie
		 * @param	strCookieIdentifier Cookie name
		 * @param	strCookieValue Cookie value as string
		 * @param	numMillisecondsToExpire Number of milliseconds until the cookie expires (use 0 for no expiration period)
		 */
		public static function setCookie(strCookieIdentifier:String, strCookieValue:String, numMillisecondsToExpire:Number = 0):void
		{
			var so:SharedObject;
			try { so = SharedObject.getLocal(strCookieIdentifier);	} catch (error:Error) { trace("[COOKIE]: " + error.message); }
			if (so)
			{
				so.data.cookieValue	= strCookieValue;
				so.data.expiresAfter = String(numMillisecondsToExpire ? (new Date).getTime() + numMillisecondsToExpire : 0);
				so.flush();
			}
		}
		
		/**
		 * Get local cookie value
		 * @param	strCookieIdentifier	Cookie name
		 * @return	Cookie value
		 */
		public static function getCookie(strCookieIdentifier:String):String
		{		
			var so:SharedObject;
			try { so = SharedObject.getLocal(strCookieIdentifier);	} catch (error:Error) { trace("[COOKIE]: " + error.message); }
			if (so)
			{
				var expiresAfter:Number = Number(so.data.expiresAfter);
				if ((expiresAfter == 0 || expiresAfter >= (new Date).getTime()) && so.data.cookieValue != null) return so.data.cookieValue;
				deleteCookie(strCookieIdentifier);
			}			
			return null;
		}
		
		/**
		 * Delete local cookie
		 * @param strCookieIdentifier Cookie Identifier
		 */
		public static function deleteCookie(strCookieIdentifier:String):void
		{
			var so:SharedObject;
			try { so = SharedObject.getLocal(strCookieIdentifier);	} catch (error:Error) { trace("[COOKIE]: " + error.message); }
			if (so) so.clear();
		}
		
	}
	
}