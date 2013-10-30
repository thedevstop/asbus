package com.thedevstop.asfac 
{
	/**
	 * Starts the fluent registration process.
	 */
	public interface IRegister 
	{
		/**
		 * Register a dependency.
		 * @param	instance How the dependency should be resolved.
		 * @return The ability to specify the type of dependency.
		 */
		function register(instance:*):IRegisterAsType
	}
}