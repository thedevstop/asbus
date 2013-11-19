package com.thedevstop.asbus 
{
	import com.codecatalyst.promise.adapters.ErrorAdapter;
	import com.codecatalyst.promise.Promise;
	import com.thedevstop.asfac.AsFactory;
	import com.thedevstop.asfac.FluentAsFactory;
	import flash.events.EventDispatcher;
	
	public class Mediator extends EventDispatcher implements IMediator, ICommandBus, IQueryBus, IEventBus
	{
		private var _factory:FluentAsFactory;
		
		public function Mediator(factory:FluentAsFactory) 
		{
			if (!factory)
				throw new ArgumentError("factory cannot be null.");
			
			Promise.registerAdapter(ErrorAdapter.adapt);
			
			_factory = factory;
			_factory.register(this).asType(IMediator);
			_factory.register(this).asType(ICommandBus);
			_factory.register(this).asType(IQueryBus);
			_factory.register(this).asType(IEventBus);
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