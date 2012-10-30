package br.franchistein.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapUtils
	{
		public function BitmapUtils()
		{
		}
		
		public static function getClone(pBmpOrigin:Bitmap):Bitmap {
			var duplicate:Bitmap = new Bitmap();
			duplicate.bitmapData = pBmpOrigin.bitmapData;
			
			return duplicate;
		}
		
		public static function  getPrint(pMovieGeral:DisplayObject,pWidth:Number=-1,pHeight:Number=-1):Bitmap {
			var numWidth:Number = (pWidth==-1) ? pMovieGeral.width : pWidth;
			var numHeight:Number = (pHeight==-1) ? pMovieGeral.height : pHeight;
			var bmpFrom : BitmapData = new BitmapData (numWidth, numHeight, true, 0xFFFFFF);
			bmpFrom.draw(pMovieGeral);
			
			var bmpReturn:Bitmap = new Bitmap (bmpFrom);
			
			return bmpReturn;
		}
		public static function getBitmapDataByCoordinates(pMovieGeral:DisplayObject, pXInicial:Number, pYInicial:Number, pWidth:Number, pHeight:Number):Bitmap {
			var numPosX:Number = pXInicial;
			var numPosY:Number = pYInicial;
			var _bmpRetorno:BitmapData;
			
			var _bmdCopia:BitmapData = new BitmapData (pMovieGeral.width, pMovieGeral.height, true, 0xFFFFFF);
			_bmdCopia.draw(pMovieGeral);
			
			_bmpRetorno = new BitmapData(pWidth, pHeight);
			
			_bmpRetorno.copyPixels(_bmdCopia, new Rectangle(numPosX, numPosY, pWidth, pHeight), new Point(0, 0));
			_bmdCopia.dispose();
			
			return new Bitmap(_bmpRetorno);
		}
	}
}