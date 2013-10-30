package com.thedevstop.asbus 
{
	import mx.collections.ArrayCollection;
	
	public class EventRecorder
	{
		private var _events:ArrayCollection;
		
		public function EventRecorder()
		{
			_events = new ArrayCollection();
		}

		public function record(event:DomainEvent):void
		{
			_events.addItem(event);
		}
		
		public function get recordedEvents():EventStream
		{
			return new EventStream(_events.toArray());
		}
	}
}