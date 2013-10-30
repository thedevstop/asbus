package com.thedevstop.asbus 
{
	import avmplus.getQualifiedClassName;
	import com.codecatalyst.promise.Promise;
	import flash.errors.IllegalOperationError;
	
	public class QueryHandler implements IQueryHandler
	{
		private var _queryType:Class;
		
		public function QueryHandler(queryType:Class) 
		{
			this._queryType = queryType;
		}
		
		public function handle(query:Query):Query
		{
			var promise:Promise;
			try
			{
				validateQuery(query);
				promise = handleQuery(query);
			}
			catch (error:Error)
			{
				promise = Promise.when(error);
			}
			return promise;	
		}
		
		protected function handleQuery(query:*):Promise
		{
			var handlerClassName:String = getQualifiedClassName(Object(this).constructor);
			return Promise.when(new Error("handleQuery not overridden in handler class " + handlerClassName));
		}
		
		protected function validateQuery(query:Query):void
		{
			if (Object(query).constructor == _queryType)
				return;
				
			var handlerClassName:String = getQualifiedClassName(Object(this).constructor);
			var queryClassName:String = getQualifiedClassName(query);
			throw new IllegalOperationError(handlerClassName + " improperly registered for query type " + queryClassName);
		}
	}
}