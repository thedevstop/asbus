package com.thedevstop.asfac 
{
	import avmplus.getQualifiedClassName;
	/**
	 * Handles the resolution of types for the FluentAsFactory. 
	 */
	public class FluentResolver implements IResolve, IResolveFromScope
	{
		private var _factory:AsFactory;
		private var _scope:* = AsFactory.DefaultScopeName;
		
		public function FluentResolver(factory:AsFactory) 
		{
			_factory = factory;
		}
		
		/**
		 * Resolve a dependency.
		 * @param	type The type of dependency to resolve.
		 * @return An instance of the type.
		 */
		public function resolve(type:Class):*
		{
			return _factory.resolve(type, _scope);
		}
		
		/**
		 * Resolve a dependency using default registrations if necessary.
		 * @param	type The type of dependency to resolve.
		 * @return An instance of the type.
		 */
		public function resolveWithFallback(type:Class):*
		{
			return _factory.resolve(type, _scope, true);
		}
		
		/**
		 * Resolve a dependency from a specifc scope.
		 * @param	scope The name or Class of the scope.
		 * @return The ability to resolve from this scope.
		 */
		public function fromScope(scope:*):IResolve
		{
			_scope = scope;
			
			return this;
		}
	}
}