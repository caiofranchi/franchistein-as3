package br.franchistein.utils
{
	import flash.net.LocalConnection;
	import flash.system.System;

	public class MemoryUtils
	{
		public static function forceGarbageCollection():void {
			//Garbage Collection Clear
			try {
				new LocalConnection().connect('foo');
				new LocalConnection().connect('foo');
			} catch (e:*) {}
		}
		
		public static function get memoryUsed():uint {
			return System.totalMemory;
		}

	}
}