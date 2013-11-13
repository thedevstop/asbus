package com.thedevstop.asbus 
{
	import avmplus.getQualifiedClassName;
	import flash.errors.IllegalOperationError;
	
	/**
	 * Base class for command handlers that takes care of validating commands.
	 */
	public class CommandHandler implements ICommandHandler
	{
		private var _commandType:Class;
		
		/**
		 * @param	commandType The class of command that this CommandHandler supports.
		 */
		public function CommandHandler(commandType:Class) 
		{
			this._commandType = commandType;
		}
		
		public function handle(command:Command):void
		{
			validateCommand(command);
			handleCommand(command);
		}
		
		/**
		 * Override in extending classes to handle the command after it is validated.
		 */
		protected function handleCommand(command:*):void
		{
			var handlerClassName:String = getQualifiedClassName((this as Object).constructor);
			throw new Error("handleCommand not overridden in handler class " + handlerClassName);
		}
		
		/**
		 * Validates the command is an instance of the command type given in the constructor.
		 */
		protected function validateCommand(command:Command):void
		{
			if (Object(command).constructor == _commandType)
				return;
				
			var handlerClassName:String = getQualifiedClassName(Object(this).constructor);
			var commandClassName:String = getQualifiedClassName(command);
			throw new IllegalOperationError(handlerClassName + " improperly registered for command type " + commandClassName);
		}
	}
}