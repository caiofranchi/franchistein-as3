	window.onload = function(){
		detectMobile();
	}
	
	function detectMobile()
	{
		if( (navigator.userAgent.match(/iPhone/i)) || 
			(navigator.userAgent.match(/iPod/i)) || 
			(navigator.userAgent.match(/iPad/i)) || 
			(navigator.userAgent.match(/android/i)) || 
			(navigator.userAgent.match(/nokia/i)) || 
			(navigator.userAgent.match(/sonyericsson/i)) || 
			(navigator.userAgent.match(/blackberry/i)) || 
			(navigator.userAgent.match(/samsung/i)) || 
			(navigator.userAgent.match(/sec-/i)) || 
			(navigator.userAgent.match(/windows ce/i)) || 
			(navigator.userAgent.match(/motorola/i)) || 
			(navigator.userAgent.match(/mot-/i)) || 
			(navigator.userAgent.match(/up.b/i)))
		{
			window.location.href = "Mobile/";
		}
	}
