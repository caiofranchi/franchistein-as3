package br.franchistein.utils
{
	public class PaginacaoUtils
	{
		private static var numItemExibicao		:Number = 5;
		
		//CONTROLS
		public static function retornaItensPorPagina(pPagina:Number,pArrayNavegacao:Array):Array {
			var _arrPagina:Array = pArrayNavegacao;
			var numFim:Number = (pPagina)*numItemExibicao;
			_arrPagina = _arrPagina.slice((pPagina-1)*numItemExibicao,(_arrPagina.length<numFim) ? _arrPagina.length : numFim)
			//
			return _arrPagina;
		}
		public static function retornaQuantidadePorPagina(pPagina:Number,pArrayNavegacao:Array):Number {			
			//
			var numFim:Number = (pPagina)*numItemExibicao;
			return (pArrayNavegacao.length<numFim) ? pArrayNavegacao.length : numFim;
		}
		public static function retornaTotalPaginas(pArrayNavegacao:Array):Number {
			return Math.ceil(pArrayNavegacao.length/numItemExibicao);
		}
		public static function retornaPaginaDoItem(pIndiceItem:Number):Number {	
			var numRetorno:Number = Math.ceil(pIndiceItem/(numItemExibicao-1));
			if(numRetorno==0) numRetorno = 1;
			return numRetorno;
		}
		//GETTERS & SETTERS
		public static function get itemsExibicao():Number {
			return numItemExibicao;
		}
		public static function set itemsExibicao(pTotal:Number):void {
			numItemExibicao = pTotal;
		}
	}
}