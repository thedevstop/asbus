package com.thedevstop.asbus 
{
	import flash.events.Event;
	
	public interface IEventBus 
	{
		/**
		 * Adds a listener for a type of event.
		 */
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
		
		/**
		 * Dispatch an event to the listeners.
		 */
		function dispatchEvent(event:Event):Boolean;
		
		/**
		 * Remove a listener for a type of event.
		 */
		function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void;
	}
}