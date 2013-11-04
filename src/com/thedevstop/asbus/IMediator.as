package com.thedevstop.asbus 
{
	import com.codecatalyst.promise.Promise;
	
	public interface IMediator 
	{
		/**
		 * Requests a result for the query.
		 * @return	The promise of a result.
		 */
		function request(query:Query):Promise
		
		/**
		 * Sends the command to be acted upon.
		 */
		function send(command:Command):void
	}
}