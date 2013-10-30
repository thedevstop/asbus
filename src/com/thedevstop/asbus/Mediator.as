package com.thedevstop.asbus 
{
	import com.codecatalyst.promise.adapters.ErrorAdapter;
	import com.codecatalyst.promise.Promise;
	import com.thedevstop.asfac.AsFactory;
	
	public class Mediator implements IMediator
	{
		private var _factory:AsFactory;
		
		public function Mediator(factory:AsFactory) 
		{
			Promise.registerAdapter(ErrorAdapter.adapt);
			
			_factory = factory;
		}
		
		public function request(query:Query):Promise 
		{
			var response:Promise;
			var handler:IQueryHandler = _factory.resolve(IQueryHandler, query);
			try
			{
				response = handler.handle(query);
			}
			catch (error:Error)
			{
				response = Promise.when(error);
			}
			return response;
		}
		
		public function send(command:Command):void 
		{
			var handler:ICommandHandler = _factory.resolve(ICommandHandler, command);
			handler.handle(command);
		}
	}
}