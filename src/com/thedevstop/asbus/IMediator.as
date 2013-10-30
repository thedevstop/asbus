package com.thedevstop.asbus 
{
	import com.codecatalyst.promise.Promise;
	
	public interface IMediator 
	{
		function request(query:Query):Promise
		function send(command:Command):void
	}
}