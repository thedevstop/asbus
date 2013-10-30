package com.thedevstop.asbus 
{
	import avmplus.getQualifiedClassName;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	
	public class EventSourcedAggregate extends Proxy
	{
		private var _eventRecorder:EventRecorder;
		private var _eventHandlers:Dictionary;
		
		public function EventSourcedAggregate()
		{
			_eventRecorder = new EventRecorder();
			_eventHandlers = new Dictionary();
		}
		
		public function initialize(events:EventStream):void
		{
			var event:DomainEvent = events.read();
			while (event)
			{
				apply(event);
				event = events.read();
			}
		}
		
		public function get recordedEvents():EventStream
		{
			return _eventRecorder.recordedEvents;
		}
		
		protected function register(eventClass:Class, eventHandler:Function):void
		{
			_eventHandlers[eventClass] = eventHandler;
		}
		
		protected function apply(event:DomainEvent):void
		{
			var eventClass:Class = Object(event).constructor;
			var eventHandler:Function = _eventHandlers[eventClass];
			
			if (!eventHandler)
				throw new Error("No event handler registered for " + getQualifiedClassName(event) + " on class " + getQualifiedClassName(this));
			
			eventHandler(event);
			_eventRecorder.record(event);
		}
	}
}