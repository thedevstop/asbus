package com.thedevstop.asbus 
{
	public interface ICommandBus 
	{
		/**
		 * Sends the command to be acted upon.
		 */
		function send(command:Command):void
	}
}