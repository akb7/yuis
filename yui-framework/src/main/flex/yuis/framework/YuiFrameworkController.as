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
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	import mx.managers.DragManager;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;
	import mx.managers.SystemManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;
	
	import yuis.Yuis;
	import yuis.bridge.FrameworkBridge;
	import yuis.convention.NamingConvention;
	import yuis.core.Environment;
	import yuis.core.ns.yuis_internal;
	import yuis.customizer.IComponentCustomizer;
	import yuis.customizer.IElementCustomizer;
	import yuis.customizer.IViewCustomizer;
	import yuis.error.YuiFrameworkError;
	import yuis.event.YuiFrameworkEvent;
	import yuis.logging.Logging;
	import yuis.logging.debug;
	import yuis.util.StyleManagerUtil;

    import flash.events.UncaughtErrorEvent;

    use namespace yuis_internal;
    
    [ExcludeClass]
    public final class YuiFrameworkController extends YuiFrameworkControllerBase {
        
        private static function isView(component:DisplayObject):Boolean{
            if( component == null ){
                return false;
            }
            const frameworkBridge:FrameworkBridge = Yuis.public::frameworkBridge as FrameworkBridge;
            if( frameworkBridge.isContainer(component)){
                const namingConvention:NamingConvention = Yuis.public::namingConvention as NamingConvention;
                return namingConvention.isViewClassName( getCanonicalName(component) );
            } else {
                return false;
            }
        }
        
        private static function isComponent( target:DisplayObject ):Boolean{
            if( target == null ){
                return false;
            }
            const frameworkBridge:FrameworkBridge = Yuis.public::frameworkBridge as FrameworkBridge;
            return frameworkBridge.isComponent(target);            
        }
        
        private static function getDocumentOf(target:DisplayObject):UIComponent{
            if( target == null || !isComponent(target) ){
                return null;
            }
            const frameworkBridge:FrameworkBridge = Yuis.public::frameworkBridge as FrameworkBridge;
            return frameworkBridge.getDocumentOf(target) as UIComponent; 
        }
        
        {
            CursorManager;
            PopUpManager;
            DragManager;
        }
        
        private static var _this:IYuiFrameworkController;
        
        public static function getInstance():IYuiFrameworkController{
            return _this;
        }
        
        public function YuiFrameworkController(){
            super();
            if( _this == null ){
                _this = this;
            } else {
                throw new YuiFrameworkError("container is already created.");
            }            
        }
        
        public override function customizeView( container:DisplayObjectContainer ):void{
            var viewCustomizer_:IViewCustomizer;
            var view:UIComponent = container as UIComponent;
            if( view == null ){   
                return;
            }
            CONFIG::DEBUG{
                _debug("ViewCustomizing", view, view.owner);
            }
            if( !view.initialized ){   
                CONFIG::DEBUG{
                    _debug("ViewCustomizeInitializeError",view);
                }
                return;
            }
            //
            processViewRegister(view); 
            for each( var customizer_:IElementCustomizer in _customizers ){
                viewCustomizer_ = customizer_ as IViewCustomizer;
                if( viewCustomizer_ != null ){
                    viewCustomizer_.customizeView( view );
                }
            }
            if( view.hasEventListener(YuiFrameworkEvent.VIEW_INITIALIZED)){
                view.dispatchEvent( new YuiFrameworkEvent(YuiFrameworkEvent.VIEW_INITIALIZED));
            }
            CONFIG::DEBUG{
                _debug("ViewCustomized",view,view.owner);
            }
        }
        
        public override function uncustomizeView( container:DisplayObjectContainer ):void{
            var viewCustomizer_:IViewCustomizer;
            var view:UIComponent = container as UIComponent;
			if( view == null ){   
				return;
			}
            if( !view.initialized ){     
                CONFIG::DEBUG {
                    _debug("ViewUncustomizeInitializeError",view);       
                }
                return;
            }
            CONFIG::DEBUG{
                _debug("ViewUncustomizing",view,view.owner);
            }
            var numCustomizers:int = customizers.length;
            for( var i:int = numCustomizers-1; i >= 0; i-- ){
                viewCustomizer_ = customizers[i] as IViewCustomizer;
                if( viewCustomizer_ != null ){
                    viewCustomizer_.uncustomizeView( view );
                }
            }
            processViewUnregister(view);
            CONFIG::DEBUG{
                _debug("ViewUncustomized",view,view.owner);
            }
        }
        
        public override function customizeComponent( container:DisplayObjectContainer, child:DisplayObject ):void{
            if( container == null || !isView(container) ){
                return;
            }
            if( child == null || !isComponent(child) ){
                return;
            }
            //
            var componentCustomizer_:IComponentCustomizer;
            var view:UIComponent = container as UIComponent;
            var component:UIComponent = child as UIComponent;
            if( !component.initialized ){     
                CONFIG::DEBUG{
                    _debug("ComponentCustomizeViewInitializeError",view,view.owner);       
                }
                return;
            }
            CONFIG::DEBUG{
                _debug("ComponentCustomizing",child,container);
            }
            for each( var customizer_:IElementCustomizer in _customizers ){
                componentCustomizer_ = customizer_ as IComponentCustomizer;
                if( componentCustomizer_ != null ){
                    componentCustomizer_.customizeComponent( view, component );
                }
            }
            CONFIG::DEBUG{
                _debug("ComponentCustomized",child,container);
            }
        }
        
        public override function uncustomizeComponent( container:DisplayObjectContainer, child:DisplayObject ):void{
            if( container == null || !isView(container) ){
                return;
            }
            if( child == null || !isComponent(child) ){
                return;
            }
            //
            var componentCustomizer_:IComponentCustomizer;
            var view:UIComponent = container as UIComponent;
            var component:UIComponent = child as UIComponent;
            if( !view.initialized ){     
                CONFIG::DEBUG{       
                    _debug("ComponentUncustomizeViewInitializeError",view);
                }
                return;
            }
            CONFIG::DEBUG{
                _debug("ComponentUncustomizing",child, container);
            }
            var numCustomizers:int = customizers.length;
            for( var i:int = numCustomizers-1; i >= 0; i-- ){
                componentCustomizer_ = customizers[i] as IComponentCustomizer;
                if( componentCustomizer_ != null ){
                    componentCustomizer_.uncustomizeComponent( view, component );
                }
            }
            CONFIG::DEBUG{
                _debug("ComponentUncustomized",child, container);
            }
        }        
        
        private function application_initCompleteHandler( event:Event ):void{
            Logging.initialize();
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }
        }
        
        private function application_preloaderDoneHandler( event:Event ):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }
            if( event.currentTarget is ISystemManager ){
                var root:ISystemManager = event.currentTarget as ISystemManager;
                CONFIG::DEBUG{
                    _info("SystemManagerMonitoringStart",root);
                }
                registerRootDisplayObject(root as DisplayObject);
                
                //detecting component addition for register
                root.addEventListener(
                    Event.ADDED_TO_STAGE,
                    systemManager_addedToStageHandler,
                    true,
                    int.MAX_VALUE
                );
            } else {
                throw new IllegalOperationError("Illegal SystemManager"+event.currentTarget);
            }
            Yuis.initNamingConvention();
            CONFIG::DEBUG{
                _debug("ApplicationConventions",Yuis.public::namingConvention.conventions.toString());
            }            
        }
        
        private function application_applicationCompleteHandler( event:FlexEvent ):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }
            const frameworkBridge:FrameworkBridge = Yuis.public::frameworkBridge as FrameworkBridge;
            const root:DisplayObject = frameworkBridge.systemManager;
            systemManagerMonitoringStop(root);
            customizersInitialize();
            componentMonitoringStart(root);
            processApplicationStart();   
        }
        
        private function systemManager_applicationStartRequestHandler( event:YuiFrameworkEvent ):void{
            CONFIG::DEBUG{
                _info("ApplicationStart");
            }  
            var root:ISystemManager = event.target as ISystemManager;
            root.removeEventListener(YuiFrameworkEvent.APPLICATION_START_REQUEST,systemManager_applicationStartRequestHandler);  
			doApplicationStart();
        }
        
        private function systemManager_addedToStageHandler( event:Event ):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }
            var component:UIComponent = event.target as UIComponent;
            if( component == null || !component.initialized ){
                return;
            }
            const frameworkBridge:FrameworkBridge = Yuis.public::frameworkBridge as FrameworkBridge;
            if( frameworkBridge.application == null && frameworkBridge.isApplication(component) ){
                processApplicationRegisteration(component as DisplayObjectContainer);
            } else {
                processViewRegister(component); 
            }
        }
        
        private function systemManager_creationCompleteHandler(event:FlexEvent):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }            
            doRegisterComponent(event.target as DisplayObject);
        }
        
        private function processApplicationRegisteration(component:DisplayObjectContainer):void{
            CONFIG::DEBUG{
                _debug("ApplicationRegistered",component.toString());
            }
            const frameworkBridge:FrameworkBridge = Yuis.public::frameworkBridge as FrameworkBridge;
            const app:UIComponent = component as UIComponent;
            app.mouseEnabled = false;
            app.mouseFocusEnabled = false;
//            app.setVisible(false,true);
            frameworkBridge.application = app;
            
            Environment.yuis_internal::setApplication( app );
            Environment.yuis_internal::setParameters( frameworkBridge.parameters );
            
            const root:DisplayObject = frameworkBridge.systemManager;
            root.loaderInfo.uncaughtErrorEvents
                .addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, loaderInfoUncaughtErrorHandler,false,int.MAX_VALUE);
            if( root is SystemManager ){
                var sm:SystemManager = root as SystemManager;
                var preloadedRSLs:Dictionary = sm.preloadedRSLs;
                var loaderInfo:LoaderInfo;
                
                for( var item:Object in preloadedRSLs ){
                    loaderInfo = item as LoaderInfo;
                    CONFIG::DEBUG{
                        debug(this,"preloadedRSLs:"+loaderInfo.url);
                    }
                    loaderInfo.loader.uncaughtErrorEvents
                        .addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, loaderInfoUncaughtErrorHandler,false,int.MAX_VALUE);
                }
            }
        }
        
        private function processApplicationStart():void{
            const frameworkBridge:FrameworkBridge = Yuis.public::frameworkBridge as FrameworkBridge;
            const app:UIComponent = frameworkBridge.application as UIComponent;
            var event:YuiFrameworkEvent = new YuiFrameworkEvent(YuiFrameworkEvent.APPLICATION_START,false,true);
            app.dispatchEvent(event);
            CONFIG::DEBUG{
                _info("ApplicationStartPending");
            }
            app.systemManager.addEventListener(YuiFrameworkEvent.APPLICATION_START_REQUEST,systemManager_applicationStartRequestHandler);
        }
        
        private function doApplicationStart():void{
            const frameworkBridge:FrameworkBridge = Yuis.public::frameworkBridge as FrameworkBridge;
            const settings:YuiFrameworkSettings = Yuis.public::settings;
            //
            const rootView:DisplayObjectContainer = frameworkBridge.rootView as DisplayObjectContainer;
            if( rootView != null ){
                if( rootView.hasEventListener(YuiFrameworkEvent.APPLICATION_START)){
                    rootView.dispatchEvent( new YuiFrameworkEvent(YuiFrameworkEvent.APPLICATION_START));
                }
                rootView.visible = true;
            }
            _isApplicationStarted = true;
            //
            const root:DisplayObject = frameworkBridge.systemManager;
            const app:UIComponent = frameworkBridge.application as UIComponent;
//            app.setVisible(true,true);
            app.mouseEnabled = true;
            app.mouseFocusEnabled = true;
            if( !settings.isAutoMonitoring ){
                componentMonitoringStop(root);
            }
        }

        private function processViewRegister( container:DisplayObjectContainer ):void{
			if( isView(container)){
	            const namingConvention:NamingConvention = Yuis.public::namingConvention;
	            const componentId:String = namingConvention.getComponentName(container);
	            if( !ViewComponentRepository.hasComponent( componentId )){
	                ViewComponentRepository.addComponent( container );
	                CONFIG::DEBUG{
	                    _debug("ViewRegistered",container.toString());
	                }
	            }
			}
        }
        
        private function processViewUnregister( container:DisplayObjectContainer ):void{
			if( isView(container)){
	            const namingConvention:NamingConvention = Yuis.public::namingConvention;
	            const componentId:String = namingConvention.getComponentName(container);
	            if( ViewComponentRepository.hasComponent( componentId )){
	                ViewComponentRepository.removeComponent( container );
	                CONFIG::DEBUG{
	                    _debug("ViewUnRegistered",container.toString());
	                }
	            }
			}
        }
        
        protected function customizersInitialize():void{
            if( _customizers == null ){
                _customizers = getDefaultCustomizers();
            }
        }
        
		protected override function getDefaultCustomizerClasses():Array{
			const styleManager:IStyleManager2 = StyleManagerUtil.getStyleManager();
			const customizersDef:CSSStyleDeclaration = styleManager.getStyleDeclaration(".customizers");
			const defaultFactory:Function = customizersDef.defaultFactory;
			
			const result:Array = [];
			const keys:Array = [];
			
			var customizers:Object = {};
			var customizer:Class;
			var numKeys:int;
			
			if (defaultFactory != null){
				defaultFactory.prototype = {};
				customizers = new defaultFactory();
			}
			
			for( var key:String in customizers ){
				keys.push(key);
			}
			keys.sort();
			numKeys = keys.length;
			for( var i:int = 0; i < numKeys; i++ ){
				customizer = customizers[keys[i]] as Class;
				result.push(customizer);
			}
			CONFIG::DEBUG{
				_debug("CustomizerLoaded",result);
			}
			return result;
		}
		
		protected override function doRegisterComponent( target:DisplayObject ):void{
			var component:UIComponent = target as UIComponent;
			if( component == null || !component.initialized ){
				return;
			}
			if( isView(component) ){
				customizeView(component);
			} else {
				customizeComponent(getDocumentOf(component),component);
			}
		}
		
		protected override function doUnregisterComponent(target:DisplayObject):void{
			var component:UIComponent = target as UIComponent;
			if( component == null || !component.initialized ){
				return;
			}
			if( isView(component)){
				uncustomizeView( component as DisplayObjectContainer);
			} else {
				uncustomizeComponent(getDocumentOf(component),component);
			}
		}
		
        yuis_internal function systemManagerMonitoringStart( root:DisplayObject ):void{
            CONFIG::DEBUG{
                Logging.initialize();
            }
            root.addEventListener(
                FlexEvent.INIT_COMPLETE,
                application_initCompleteHandler,
                true,
                int.MAX_VALUE
            );
            
            root.addEventListener(
                FlexEvent.PRELOADER_DONE,
                application_preloaderDoneHandler,
                true,
                int.MAX_VALUE
            );
            
            root.addEventListener(
                FlexEvent.APPLICATION_COMPLETE,
                application_applicationCompleteHandler,
                false,
                int.MAX_VALUE
            );
        }
        
		yuis_internal function systemManagerMonitoringStop( root:DisplayObject ):void{
            
            root.removeEventListener(
                FlexEvent.APPLICATION_COMPLETE,
                application_applicationCompleteHandler,
                false
            );
            
            root.removeEventListener(
                FlexEvent.INIT_COMPLETE,
                application_initCompleteHandler,
                true
            );
            
            root.removeEventListener(
                FlexEvent.PRELOADER_DONE,
                application_preloaderDoneHandler,
                true
            );
            root.removeEventListener(
                Event.ADDED_TO_STAGE,
                systemManager_addedToStageHandler,
                true
            );
        }
        
        yuis_internal override function componentMonitoringStart(root:DisplayObject):void{
            super.componentMonitoringStart(root);
            root.addEventListener(
                FlexEvent.CREATION_COMPLETE,
                systemManager_creationCompleteHandler,
                true,
                int.MAX_VALUE
            );
        }
        
        yuis_internal override function componentMonitoringStop(root:DisplayObject):void{
            super.componentMonitoringStop(root);
            root.addEventListener(
                FlexEvent.CREATION_COMPLETE,
                systemManager_creationCompleteHandler,
                true,
                int.MAX_VALUE
            );
        }
    }
}