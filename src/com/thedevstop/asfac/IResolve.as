package com.thedevstop.asfac 
{
	/**
	 * Ends the fluent resolution process.
	 */
	public interface IResolve 
	{
		/**
		 * Resolve a dependency.
		 * @param	type The type of dependency to resolve.
		 * @return An instance of the type.
		 */
		function resolve(type:Class):*
		
		/**
		 * Resolve a dependency using default registrations if necessary.
		 * @param	type The type of dependency to resolve.
		 * @return An instance of the type.
		 */
		function resolveWithFallback(type:Class):*
	}
}