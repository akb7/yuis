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
    import flash.events.Event;
    
    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    import mx.managers.LayoutManager;
    
    import spark.components.Application;
    
    import yuis.core.ns.yuis_internal;
    import yuis.error.YuiFrameworkError;
    import yuis.event.YuiFrameworkEvent;
    import yuis.logging.debug;
    
    use namespace yuis_internal;

    [Style(name="rootViewClass", type="Class",inherit="no")]
    [Event(name="applicationStart", type="yuis.event.YuiFrameworkEvent")]
    public class YuiApplication extends Application {
        
        private static const ROOT_VIEW_CLASS:String = "rootViewClass";
        
        private static const ROOT_VIEW:String = "rootView";
        
        private var _setting:YuiFrameworkSettings;

        public final function get setting():YuiFrameworkSettings{
            return _setting;
        }

        private var _rootView:UIComponent;
        
        private var _invalidateRootView:Boolean;

        public final function get rootView():UIComponent{
            return _rootView;
        }

        public function YuiApplication()
        {
            super();
            _setting = new YuiFrameworkSettings();
            
            addEventListener(FlexEvent.APPLICATION_COMPLETE,on_applicationCompleteHandler);
        }
        
        protected function on_applicationCompleteHandler(event:FlexEvent):void
        {
            createRootView();
        }
        
        public final override function dispatchEvent(event:Event):Boolean{
            var result:Boolean = super.dispatchEvent(event);
            if( event.isDefaultPrevented()){
                //nothing
            } else {
                if( !(event.type in YuiApplicationConsts.UNRECOMMEND_EVENT_MAP)){
                    if( result ){
                        if( initialized && _rootView != null && _rootView.initialized ){
                            result = _rootView.dispatchEvent(event);
                        }
                    }
                }
            }
            return result;
        }
        
        protected final override function createChildren():void{
            super.createChildren();
        }
        
        protected final override function commitProperties():void{
            super.commitProperties();
        }
        
        protected function createRootView():void{
            removeAllElements();
            doCreateRootView();
        }
        
        private final function doCreateRootView():void{
            CONFIG::DEBUG{
                debug(this,"RootView Creating...");
            }
            var viewClass:Class = getStyle(ROOT_VIEW_CLASS) as Class;
            if( viewClass == null ){
                throw new YuiFrameworkError("No setting rootViewClass style.");
            } else {
                _rootView = new viewClass();
                _rootView.name = ROOT_VIEW;
                _rootView.setVisible(false,true);
                LayoutManager.getInstance().addEventListener(FlexEvent.UPDATE_COMPLETE,rootView_updateCompleteHandler);
                addElement(_rootView);
            }
        }
        
        private final function rootView_updateCompleteHandler(event:FlexEvent):void
        {
            LayoutManager.getInstance().removeEventListener(FlexEvent.UPDATE_COMPLETE,rootView_updateCompleteHandler);
            CONFIG::DEBUG{
                debug(this,"RootView Created.");
            }
            _rootView.setVisible(true,true);
            doDispatchApplicationStartRequest();
        }
        
        private final function doDispatchApplicationStartRequest():void{
            systemManager.dispatchEvent(new YuiFrameworkEvent(YuiFrameworkEvent.yuis_internal::APPLICATION_START_REQUEST));
        }
    }
}