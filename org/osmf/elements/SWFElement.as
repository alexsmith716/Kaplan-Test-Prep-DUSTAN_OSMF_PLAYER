/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.elements
{
	import org.osmf.elements.loaderClasses.LoaderLoadTrait;
	import org.osmf.elements.loaderClasses.LoaderUtils;
	import org.osmf.media.LoadableElementBase;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * SWFElement is a media element specifically created for
	 * presenting SWFs.
	 * <p>The SWFElement uses a SWFLoader class to load and unload its media.
	 * Developers requiring custom loading logic for SWFs
	 * can pass their own loaders to the SWFElement constructor. 
	 * These loaders should subclass SWFLoader.</p>
	 * <p>The basic steps for creating and using a SWFElement are:
	 * <ol>
	 * <li>Create a new URLResource pointing to the URL of the SWF to be loaded.</li>
	 * <li>Create a new SWFLoader.</li>
	 * <li>Create the new SWFElement, passing the SWFLoader and URLResource
	 * as parameters.</li>
	 * <li>Get the SWFElement's LoadTrait using the 
	 * <code>MediaElement.getTrait(MediaTraitType.LOAD)</code> method.</li>
	 * <li>Load the SWF using the LoadTrait's <code>load()</code> method.</li>
	 * <li>Get the SWFElement's DisplayObjectTrait using the 
	 * <code>MediaElement.getTrait(MediaTraitType.DISPLAY_OBJECT)</code> method.</li>
	 * <li>Add the DisplayObject that represents the SWFElement's DisplayObjectTrait
	 * to the display list. This DisplayObject is in the <code>displayObject</code>
	 * property of the DisplayObjectTrait.</li>
	 * <li>When done with the SWFElement, unload the SWF using the
	 * LoadTrait's <code>unload()</code> method.</li>
	 * </ol>
	 * </p>
	 * 
	 * @see SWFLoader
	 * @see org.osmf.media.URLResource
	 * @see org.osmf.media.MediaElement
	 * @see org.osmf.traits
	 * @see flash.display.DisplayObjectContainer#addChild()
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class SWFElement extends LoadableElementBase
	{
		/**
		 * Constructor.
		 * 
		 * @param resource URLResource that points to the SWF source that the SWFElement
		 * will use.
		 * @param loader Loader used to load the SWF.  If null, the Loader will be created.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function SWFElement(resource:URLResource=null, loader:SWFLoader=null)
		{
			if (loader == null)
			{
				loader = new SWFLoader();
			}
			super(resource, loader);
		}
		
		/**
		 * @private 
		 */ 		
		override protected function createLoadTrait(resource:MediaResourceBase, loader:LoaderBase):LoadTrait
		{
			return new LoaderLoadTrait(loader, resource);
		}

		/**
		 * @private 
		 */ 		
		override protected function processReadyState():void
		{
			var loaderLoadTrait:LoaderLoadTrait = getTrait(MediaTraitType.LOAD) as LoaderLoadTrait;
			
			addTrait(MediaTraitType.DISPLAY_OBJECT, LoaderUtils.createDisplayObjectTrait(loaderLoadTrait.loader, this));
		}
		
		/**
		 *  @private 
		 */ 
		override protected function processUnloadingState():void
		{
			removeTrait(MediaTraitType.DISPLAY_OBJECT);	
		}
	}
}