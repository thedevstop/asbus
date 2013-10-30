package com.thedevstop.asbus 
{
	public class EventStream 
	{
		private var _events:Array = [];
		private var _index:int = -1;
		
		public function EventStream(events:Array)
		{
			_events = events;
		}
		
		public function read():DomainEvent
		{
			_index++;
			
			if (_index > _events.length)
				throw new Error("EventStream exhausted");
			
			if (_index === _events.length)
				return null;
			
			return _events[_index];
		}
	}
}