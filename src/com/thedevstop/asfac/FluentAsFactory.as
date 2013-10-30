package com.thedevstop.asfac 
{
	import avmplus.getQualifiedClassName;
	/**
	 * AsFactory wrapped in a fluent interface.
	 */
	public class FluentAsFactory implements IRegisterInScope, IResolveFromScope
	{	
		private var _factory:AsFactory;
		private var _defaultRegistrar:FluentRegistrar;
		private var _defaultResolver:FluentResolver;
		
		/**
		 * Constructs a new FluentAsFactory.
		 * @param	factory The AsFactory that is used by the fluent interface.
		 */
		public function FluentAsFactory(factory:AsFactory = null)
		{
			_factory = factory || new AsFactory();
			_defaultRegistrar = new FluentRegistrar(_factory);
			_defaultResolver = new FluentResolver(_factory);
			register(this).asType(FluentAsFactory);
		}
		
		/**
		 * Register a dependency in the default scope.
		 * @param	instance How the dependency should be resolved.
		 * @return The ability to specify the type of dependency.
		 */
		public function register(instance:*):IRegisterAsType
		{
			return _defaultRegistrar.register(instance);
		}
		
		/**
		 * Register a dependency in a specific scope.
		 * @param	scope The name or Class of the scope.
		 * @return The ability to register in the scope.
		 */
		public function inScope(scope:*):IRegister
		{
			if (scope is Class)
				scope = getQualifiedClassName(scope);
				
			return new FluentRegistrar(_factory).inScope(scope);
		}
		
		/**
		 * Resolve a dependency from a specifc scope.
		 * @param	scope The name or Class of the scope.
		 * @return The ability to resolve from this scope.
		 */
		public function fromScope(scope:*):IResolve
		{
			if (scope is Class)
				scope = getQualifiedClassName(scope);
			
			return new FluentResolver(_factory).fromScope(scope);
		}
		
		/**
		 * Resolve a dependency from the default scope.
		 * @param	type The type of dependency to resolve.
		 * @return An instance of the type.
		 */
		public function resolve(type:Class):*
		{
			return _defaultResolver.resolve(type);
		}
	}
}