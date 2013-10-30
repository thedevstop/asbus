package com.thedevstop.asfac 
{
	
	/**
	 * Allows the type being registered to be within a specified scope.
	 */
	public interface IRegisterInScope
	{
		/**
		 * Register a dependency in the default scope.
		 * @param	instance How the dependency should be resolved.
		 * @return The ability to specify the type of dependency.
		 */
		function register(instance:*):IRegisterAsType
		
		/**
		 * Register a dependency in a specific scope.
		 * @param	scope The name or Class of the scope.
		 * @return The ability to register in the scope.
		 */
		function inScope(scope:*):IRegister
	}
}