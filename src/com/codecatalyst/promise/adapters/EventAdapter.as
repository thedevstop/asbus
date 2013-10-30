package com.codecatalyst.promise.adapters 
{
	import com.codecatalyst.promise.Deferred;
	import com.codecatalyst.promise.Promise;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class EventAdapter 
	{
		/**
		 * Creates a promise which will resolve the next time the dispatcher dispatches an event of the
		 * matching type.
		 * 
		 * @param	eventDispatcher The object whose events to listen.
		 * @param	successType The type of event which indicates success.
		 * @param	failureType The type of event which indicates failure.
		 * @return A promise that will resolve with the event
		 */
		public static function listenFor(eventDispatcher:IEventDispatcher, successType:String, failureType:String=null):Promise
		{
			return function () {
				const deferred:Deferred = new Deferred();
				
				eventDispatcher.addEventListener(successType, function (event:Event):void {
					eventDispatcher.removeEventListener(successType, arguments.callee);
					if (failureType)
						eventDispatcher.removeEventListener(failureType, arguments.callee);
					deferred.resolve(event);
				});
				
				if (!failureType)
					return deferred.promise;
				
				eventDispatcher.addEventListener(failureType, function (event:Event):void {
					eventDispatcher.removeEventListener(successType, arguments.callee);
					eventDispatcher.removeEventListener(failureType, arguments.callee);
					deferred.reject(event);
				});
					
				return deferred.promise;
			}();
		}	
	}
}