package com.thedevstop.asfac 
{
	/**
	 * Provides access to a common instance of a FluentAsFactory. Uses the AsFactory instance provided by the AsFactoryLocator.
	 */
	public class FluentAsFactoryLocator 
	{
		private static var _instance:FluentAsFactory = null;
		
		/**
		 * Common instance of a FluentAsFactory.
		 */
		static public function get factory():FluentAsFactory
		{
			_instance = _instance || new FluentAsFactory(AsFactoryLocator.factory);
			return _instance;
		}
	}
}