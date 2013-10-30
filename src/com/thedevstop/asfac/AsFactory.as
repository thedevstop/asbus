package com.thedevstop.asfac
{
	import avmplus.getQualifiedClassName;
	import flash.errors.IllegalOperationError;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * The default AsFactory allows for registering instances, types, or callbacks.
	 */
	public class AsFactory
	{
		static public const DefaultScopeName:String = "";
		
		private var _registrations:Dictionary;
		private var _descriptions:Dictionary;
		
		/**
		 * Constructs a new AsFactory.
		 */
		public function AsFactory()
		{
			_registrations = new Dictionary();
			_descriptions = new Dictionary();
			register(this, AsFactory);
		}
		
		/**
		 * Registers a way of resolving a dependency when requested.
		 * @param	instance How the dependency should be resolved. It can be either a Type, Instance, or Callback function.
		 * @param	type The target type for which the instance should be returned at resolution time.
		 * @param	scope The named string or Class scope for the registration.
		 * @param	asSingleton If true, the resolved dependency will be cached and returned each time the type is resolved.
		 */
		public function register(instance:*, type:Class, scope:* = DefaultScopeName, asSingleton:Boolean=false):void
		{
			var scopeName:String = scope is String 
				? scope
				: getQualifiedClassName(scope);
			
			if (instance is Class)
				registerType(instance, type, scopeName, asSingleton);
			else if (instance is Function)
				registerCallback(instance, type, scopeName, asSingleton);
			else
				registerInstance(instance, type, scopeName);
		}
		
		/**
		 * Registers a concrete instance to be returned whenever the target type is requested.
		 * @param	instance The concrete instance to be returned.
		 * @param	type The target type for which the instance should be returned at resolution time.
		 * @param scopeName The named scope for the registration.
		 */
		private function registerInstance(instance:Object, type:Class, scopeName:String = DefaultScopeName):void
		{
			var returnInstance:Function = function():Object
			{
				return instance;
			};
			
			registerCallback(returnInstance, type, scopeName, false);
		}
		
		/**
		 * Registers a type to be returned whenever the target type is requested.
		 * @param	instanceType The type to construct at resolution time.
		 * @param	type The type being requested.
		 * @param	asSingleton If true, only one instance will be created and returned on each request. If false (default), a new instance
		 * is created and returned at each resolution request.
		 */
		private function registerType(instanceType:Class, type:Class, scopeName:String=DefaultScopeName, asSingleton:Boolean=false):void 
		{
			var resolveType:Function = function():Object
			{
				return resolveByClass(instanceType, scopeName);
			};
			
			registerCallback(resolveType, type, scopeName, asSingleton);
		}
		
		/**
		 * Registers a callback to be executed, the result of which is returned whenever the target type is requested
		 * @param	callback The callback to execute.
		 * @param	type The type being requested.
		 * @param	asSingleton If true, callback is only invoked once and the result is returned on each request. If false (default), 
		 * callback is invoked on each resolution request.
		 */
		private function registerCallback(callback:Function, type:Class, scopeName:String = DefaultScopeName, asSingleton:Boolean=false):void 
		{
			if (!type)
				throw new IllegalOperationError("Type cannot be null when registering a callback");
				
			validateCallback(callback);
			
			var registrationsByScope:Dictionary = _registrations[type];
			if (!registrationsByScope)
			{
				registrationsByScope = _registrations[type] = new Dictionary();
			}
			
			if (asSingleton)
				registrationsByScope[scopeName] = (function(callback:Function, scopeName:String):Function
				{
					var instance:Object = null;
					
					return function():Object
					{
						if (!instance)
							instance = callback(this, scopeName);
						
						return instance;
					};
				})(callback, scopeName);
			else
				registrationsByScope[scopeName] = callback;
		}
		
		/**
		 * Returns an instance for the target type, using prior registrations to fulfill constructor parameters.
		 * @param	type The type being requested.
		 * @param	scope The name or Class of the scope being resolved from.
		 * @param 	useDefaultAsFallback Whether to use the DefaultScope as a fallback when registration not found in specified scope.
		 * @return The resolved instance.
		 */
		public function resolve(type:Class, scope:*=DefaultScopeName, useDefaultAsFallback:Boolean=false):*
		{
			var registrationsByScope:Dictionary = _registrations[type];
			
			var scopeName:String = scope is String 
				? scope
				: getQualifiedClassName(scope);

			if (registrationsByScope)
			{
				if (registrationsByScope[scopeName])
					return registrationsByScope[scopeName](this, scopeName);
				else if (scopeName != DefaultScopeName)
				{
					if (useDefaultAsFallback)
						return resolve(type);
					else
						throw new ArgumentError("Type being resolved has not been registered for scope named " + scopeName);
				}
			}
			
			return resolveByClass(type, scopeName);
		}
		
		/**
		 * Resolves the desired type using prior registrations.
		 * @param	type The type being requested.
		 * @param	scopeName The name of the scope being resolved from.
		 * @return The resolved instance.
		 */
		private function resolveByClass(type:Class, scopeName:String):*
		{
			if (!type)
				throw new IllegalOperationError("Type cannot be null when resolving.");
			
			var typeDescription:Object = getTypeDescription(type);
			
			if (!typeDescription)
				throw new IllegalOperationError("Interface must be registered before it can be resolved.");
			
			var parameters:Array = resolveConstructorParameters(typeDescription, scopeName);
			var instance:Object = createObject(type, parameters);
			injectProperties(instance, typeDescription, scopeName);
			
			return instance;
		}
		
		/**
		 * Creates a new instance of the type, using the specified parameters as the constructor parameters.
		 * @param	type The type being created.
		 * @param	parameters The parameters to supply to the constructor.
		 * @return The new instance of type.
		 */
		private function createObject(type:Class, parameters:Array):*
		{
			switch (parameters.length)
			{
				case 0 : return new type();
				case 1 : return new type(parameters[0]);
				case 2 : return new type(parameters[0], parameters[1]);
				case 3 : return new type(parameters[0], parameters[1], parameters[2]);
				case 4 : return new type(parameters[0], parameters[1], parameters[2], parameters[3]);
				case 5 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4]);
				case 6 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5]);
				case 7 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6]);
				case 8 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]);
				case 9 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8]);
				case 10 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9]);
				case 11 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10]);
				case 12 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11]);
				case 13 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12]);
				case 14 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12], parameters[13]);
				case 15 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12], parameters[13], parameters[14]);
				default : throw new Error("Too many constructor parameters for createObject");
			}
		}
		
		/**
		 * Confirms that a callback is valid for registration. Currently the callback must accept no arguments, or a single AsFactory argument.
		 * @param	callback The callback being tested.
		 */
		private function validateCallback(callback:Function):void
		{
			// TODO: How to check type?
			if (callback.length != 0 && callback.length != 2)
				throw new IllegalOperationError("Callback function must accept 0 or 2 arguments. The first is AsFactory and the second is scope name.");
		}
		
		/**
		 * Gets the class description for the type.
		 * @param	type The class to be described.
		 * @return An object of constructor types and injectable properties.
		 */
		private function getTypeDescription(type:Class):Object
		{
			if (_descriptions[type] !== undefined)
				return _descriptions[type];
			
			return _descriptions[type] = buildTypeDescription(type);
		}
		
		/**
		 * Builds an optimized description of the type.
		 * @param	type The type to be described.
		 * @return An optimized description of the constructor and injectable properties.
		 */
		private function buildTypeDescription(type:Class):Object
		{
			var typeDescription:Object = { constructorTypes:[], injectableProperties:[] };
			var description:XML = describeType(type);
			
			// Object does not extend class
			if (description.factory.extendsClass.length() === 0 && type !== Object)
				return null;
				
			for each (var parameter:XML in description.factory.constructor.parameter)
			{
				if (parameter.@optional.toString() != "false")
					break;
				
				var parameterType:Class = Class(getDefinitionByName(parameter.@type.toString()));
				typeDescription.constructorTypes.push(parameterType);
			}
			
			for each (var accessor:XML in description.factory.accessor)
			{
				if (shouldInjectAccessor(accessor))
				{
					var propertyType:Class = Class(getDefinitionByName(accessor.@type.toString()));
					typeDescription.injectableProperties.push( { name:accessor.@name.toString(), type:propertyType } ); 
				}
			}
			
			return typeDescription;
		}
		
		/**
		 * Determines whether the accessor should be injected.
		 * @param	accessor An accessor node from a class description xml.
		 * @return True if the Inject metadata is present, otherwise false.
		 */
		private function shouldInjectAccessor(accessor:XML):Boolean
		{				
			if (accessor.@access == "readwrite" ||
				accessor.@access == "write")
			{
				for each (var metadata:XML in accessor.metadata)
				{
					if (metadata.@name.toString() == "Inject")
						return true;
				}
			}
			
			return false;
		}
		
		/**
		 * Resolves the non-optional parameters for a constructor.
		 * @param	typeDescription The optimized description of the type.
		 * @param	scopeName The scope being resolved from.
		 * @return An array of objects to use as constructor arguments.
		 */
		private function resolveConstructorParameters(typeDescription:Object, scopeName:String):Array
		{
			var parameters:Array = [];
			
			for each (var parameterType:Class in typeDescription.constructorTypes)
				parameters.push(resolve(parameterType, scopeName, true));
			
			return parameters;
		}
		
		/**
		 * Resolves the properties on the instance object that are marked 'Inject'.
		 * @param	instance The object to be inspected.
		 * @param	typeDescription The optimized description of the type.
		 * @param	scopeName The scope being resolved from.
		 */
		private function injectProperties(instance:Object, typeDescription:Object, scopeName:String):void
		{
			for each (var injectableProperty:Object in typeDescription.injectableProperties)
				instance[injectableProperty.name] = resolve(injectableProperty.type, scopeName, true);
		}
	}
}