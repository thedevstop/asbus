package com.thedevstop.asbus 
{
	import com.codecatalyst.promise.Promise;
	
	public interface IQueryBus 
	{
		/**
		 * Requests a result for the query.
		 * @return	The promise of a result.
		 */
		function request(query:Query):Promise
	}
}