package com.thedevstop.asfac 
{
	/**
	 * Allows the type being registered to be a singleton instance.
	 */
	public interface IRegisterAsSingleton
	{
		/**
		 * Finishes this registration by specifying that the instance should be treated as a singleton.
		 */
		function asSingleton():void
	}
}