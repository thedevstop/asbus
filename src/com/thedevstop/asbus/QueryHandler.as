package com.thedevstop.asbus 
{
	import avmplus.getQualifiedClassName;
	import com.codecatalyst.promise.Promise;
	import flash.errors.IllegalOperationError;
	
	/**
	 * Base class for query handlers that takes care of validating queries.
	 */
	public class QueryHandler implements IQueryHandler
	{
		private var _queryType:Class;
		
		/**
		 * @param	queryType The class of query that this QueryHandler supports.
		 */
		public function QueryHandler(queryType:Class) 
		{
			this._queryType = queryType;
		}
		
		public function handle(query:Query):Query
		{
			validateQuery(query);
			
			var promise:Promise;
			try
			{
				promise = handleQuery(query);
			}
			catch (error:Error)
			{
				promise = Promise.when(error);
			}
			return promise;	
		}
		
		/**
		 * Override in extending classes to handle the query after it is validated.
		 */
		protected function handleQuery(query:*):Promise
		{
			var handlerClassName:String = getQualifiedClassName(Object(this).constructor);
			return Promise.when(new Error("handleQuery not overridden in handler class " + handlerClassName));
		}
		
		/**
		 * Validates the query is an instance of the query type given in the constructor.
		 */
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