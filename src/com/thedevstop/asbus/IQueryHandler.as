package com.thedevstop.asbus 
{
	import com.codecatalyst.promise.Promise;
	
	public interface IQueryHandler 
	{
		function handler(query:Query):Promise
	}
}