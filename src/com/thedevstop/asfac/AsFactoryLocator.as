package com.thedevstop.asfac 
{
	/**
	 * Provides access to a common instance of a AsFactory.
	 */
	public class AsFactoryLocator
	{
		private static var _instance:AsFactory = null;
		
		/**
		 * Common instance of a AsFactory.
		 */
		static public function get factory():AsFactory
		{
			_instance = _instance || new AsFactory();
			return _instance;
		}
	}
}