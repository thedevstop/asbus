package com.thedevstop.asfac 
{
	/**
	 * Allows the type being resolved to come from a specified scope.
	 */
	public interface IResolveFromScope 
	{
		/**
		 * Resolve a dependency from the default scope.
		 * @param	scope The name or Class of the scope.
		 * @return	An instance of the type.
		 */
		function fromScope(scope:*):IResolve
		
		/**
		 * Resolve a dependency from a specifc scope.
		 * @param	type The type of dependency to resolve. 
		 * @return	The ability to resolve from this scope.
		 */
		function resolve(type:Class):*
	}	
}