package com.thedevstop.asbus 
{
	import com.codecatalyst.promise.Promise;
	
	public interface IQueryHandler 
	{
		/**
		 * Handles the query.
		 * @return	The promise of a result.
		 */
		function handle(query:Query):Promise
	}
}