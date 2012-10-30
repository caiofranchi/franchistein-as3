package br.franchistein.utils
{
	public class MathUtils
	{
		public static function randRange(start:Number, end:Number) : Number
		{
			return Math.floor(start +(Math.random() * (end - start)));
		}
		
		public static function roundDecimals (num : Number, decimal : Number = 1) : Number {
			return Math.round(num * Math.pow(10, decimal))/Math.pow(10, decimal);
		}
	}
}