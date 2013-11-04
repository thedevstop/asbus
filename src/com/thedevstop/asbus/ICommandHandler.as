package com.thedevstop.asbus 
{
	public interface ICommandHandler 
	{
		/**
		 * Handles the command.
		 */
		function handle(command:Command):void;
	}
}