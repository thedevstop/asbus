package com.thedevstop.asbus 
{
	public interface ICommandHandler 
	{
		function handle(command:Command):void;
	}
}