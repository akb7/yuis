/*
*****************************************************
*
*  Copyright 2012 AKABANA.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is AKABANA.
*  Portions created by AKABANA are Copyright (C) 2012 AKABANA
*  All Rights Reserved.
*
*****************************************************/
package yuis.framework
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import __AS3__.vec.Vector;
	
	import yuis.Yuis;
	import yuis.bridge.FrameworkBridge;
	import yuis.core.ns.yuis_internal;
	import yuis.customizer.IElementCustomizer;
	import yuis.event.RuntimeErrorEvent;

    import flash.events.UncaughtErrorEvent;

    use namespace yuis_internal;
    
    [ExcludeClass]
    /**
     * 
     * @author arikawa.eiichi
     * 
     */
    public class YuiFrameworkControllerBase extends YuiFrameworkControllerCore {

        /**
         * 
         * @return 
         * 
         */
        public function get customizers():Vector.<IElementCustomizer>{
            return _customizers;
        }
        
        /**
         * 
         * 
         */
        public function YuiFrameworkControllerBase(){
            super();
        }
        
        /**
         * 
         * @param root
         * 
         */
        public override function addRootDisplayObject(root:DisplayObject):void{
            CONFIG::DEBUG{
                _debug("ExternalRootAdd",root);
            }
            InstanceCache.addRoot(root);
            applicationMonitoringStart(root);
            super.addRootDisplayObject(root);
        }
        
        /**
         * 
         * @param root
         * 
         */
        public override function removeRootDisplayObject(root:DisplayObject):void{
            CONFIG::DEBUG{
                _debug("ExternalRootRemove",root);
            }
            super.removeRootDisplayObject(root);
            applicationMonitoringStop(root);
            
            if( _currentRoot === root ){
                _currentRoot = null;
            }
            InstanceCache.removeRoot(root);
        }
        
        /**
         * @private
         */
        private function systemManager_addedToStageHandler( event:Event ):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }
            if( event.target is DisplayObject ){
                doRegisterComponent(event.target as DisplayObject);
            }
        }
        
        /**
         * @private
         */
        private function systemManager_removeFromStageHandler(event:Event):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }        
            if( event.target is DisplayObject ){
                doUnregisterComponent(event.target as DisplayObject);
            }
        }

        /**
         * 
         * @param component
         * 
         */
        protected function doRegisterComponent( component:DisplayObject ):void{
        }
        
        /**
         * 
         * @param component
         * 
         */
        protected function doUnregisterComponent(component:DisplayObject):void{
        }
        
        yuis_internal function loaderInfoUncaughtErrorHandler(event:UncaughtErrorEvent):void
        {
            const frameworkBridge:FrameworkBridge = Yuis.public::frameworkBridge as FrameworkBridge;
            const runtimeErrorEvent:RuntimeErrorEvent = RuntimeErrorEvent.createEvent(event.error);
            frameworkBridge.application.dispatchEvent(runtimeErrorEvent);
            event.preventDefault();
        }
        
        /**
         * 
         * @param root
         * 
         */
        yuis_internal function applicationMonitoringStart(root:DisplayObject):void{
            const settings:YuiFrameworkSettings = Yuis.public::settings;
            //
            if( settings.isAutoMonitoring ){
                componentMonitoringStart(root);
            }
        }
        
        /**
         * 
         * @param root
         * 
         */
        yuis_internal function applicationMonitoringStop(root:DisplayObject):void{
            const settings:YuiFrameworkSettings = Yuis.public::settings;
            //stop detecting component addition for register
            if( settings.isAutoMonitoring ){
                componentMonitoringStop(root);
            }
        }
        
        /**
         * 
         * @param root
         * 
         */
        yuis_internal function componentMonitoringStart(root:DisplayObject):void{
            
            //detecting component addition for assemble
            if( root.hasEventListener(Event.ADDED_TO_STAGE)){
                root.removeEventListener(
                    Event.ADDED_TO_STAGE,
                    systemManager_addedToStageHandler,
                    true
                );
            }
            root.addEventListener(
                Event.ADDED_TO_STAGE,
                systemManager_addedToStageHandler,
                true,
                int.MAX_VALUE
            );
            
            //detecting component deletion for assemble
            if( root.hasEventListener(Event.REMOVED_FROM_STAGE)){
                root.removeEventListener(
                    Event.REMOVED_FROM_STAGE,
                    systemManager_removeFromStageHandler,
                    true
                );
            }
            root.addEventListener(
                Event.REMOVED_FROM_STAGE,
                systemManager_removeFromStageHandler,
                true,
                int.MAX_VALUE
            );
        }
        
        /**
         * 
         * @param root
         * 
         */
        yuis_internal function componentMonitoringStop(root:DisplayObject):void{
            root.removeEventListener(
                Event.ADDED_TO_STAGE,
                systemManager_addedToStageHandler,
                true
            );
            root.removeEventListener(
                Event.REMOVED_FROM_STAGE,
                systemManager_removeFromStageHandler,
                true
            );
        }
    }
}