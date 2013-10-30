package com.thedevstop.asbus 
{
	import avmplus.getQualifiedClassName;
	import flash.errors.IllegalOperationError;
	
	public class CommandHandler implements ICommandHandler
	{
		private var _commandType:Class;
		
		public function CommandHandler(commandType:Class) 
		{
			this._commandType = commandType;
		}
		
		public function handle(command:Command):void
		{
			validateCommand(command);
			handleCommand(command);
		}
		
		protected function handleCommand(command:*):Promise
		{
			var handlerClassName:String = getQualifiedClassName((this as Object).constructor);
			return Promise.when(new Error("handleCommand not overridden in handler class " + handlerClassName));
		}
		
		protected function validateCommand(command:Command):void
		{
			if (Object(command).constructor == _commandType)
				return;
				
			var handlerClassName:String = getQualifiedClassName(Object(this).constructor);
			var commandClassName:String = getQualifiedClassName(command);
			throw new IllegalOperationError(handlerClassName + " improperly registered for command type " + commandClassName);
		}
}