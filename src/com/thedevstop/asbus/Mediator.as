package com.thedevstop.asbus 
{
	import com.codecatalyst.promise.adapters.ErrorAdapter;
	import com.codecatalyst.promise.Promise;
	import com.thedevstop.asfac.AsFactory;
	import com.thedevstop.asfac.FluentAsFactory;
	
	public class Mediator implements IMediator
	{
		private var _factory:FluentAsFactory;
		
		public function Mediator(factory:FluentAsFactory) 
		{
			if (!factory)
				throw new ArgumentError("factory cannot be null.");
			
			Promise.registerAdapter(ErrorAdapter.adapt);
			
			_factory = factory;
			_factory.register(this).asType(IMediator);
		}
		
		public function request(query:Query):Promise 
		{
			var response:Promise;
			var handler:IQueryHandler = _factory.fromScope(query).resolve(IQueryHandler);
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
			var handler:ICommandHandler = _factory.fromScope(command).resolve(ICommandHandler);
			handler.handle(command);
		}
	}
}