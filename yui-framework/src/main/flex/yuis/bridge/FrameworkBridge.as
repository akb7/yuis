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
package yuis.bridge
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.errors.IllegalOperationError;
    
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.IStyleManager2;
    
    import __AS3__.vec.Vector;
    
    import yuis.util.StyleManagerUtil;

    [ExcludeClass]
    public final class FrameworkBridge {
        
        public static function initialize():FrameworkBridge{
            var styleManager:IStyleManager2 = StyleManagerUtil.getStyleManager();
            var result:FrameworkBridge = new FrameworkBridge();
            var frameworkBridgeCss:CSSStyleDeclaration = styleManager.getStyleDeclaration("yuis.framework.YuiFrameworkSettings");
            if( frameworkBridgeCss == null ){
                frameworkBridgeCss = styleManager.getStyleDeclaration("YuiFrameworkSettings");
            }
			if( frameworkBridgeCss == null ){
				result = new FrameworkBridge();
				result._plugin = new DefaultFrameworkBridgePlugin();
			} else {
				var pluginClass:Class = frameworkBridgeCss.getStyle("frameworkBridgePlugin");
				if( pluginClass == null ){
					pluginClass = DefaultFrameworkBridgePlugin;
				}
				result._plugin = new pluginClass();

			}
            return result;
        }

        private var _plugin:IFrameworkBridgePlugin;

        public function get application():DisplayObjectContainer{
            return _plugin.application;
        }

        public function set application(value:DisplayObjectContainer):void{
            _plugin.application = value;
        }
        
        public function get parameters():Object{
            return _plugin.parameters;
        }
        
        public function get rootView():DisplayObjectContainer{
            return _plugin.rootView;
        }

        public function get systemManager():DisplayObject{
            return _plugin.systemManager;
        }

        public function isApplication(application:DisplayObject):Boolean{
            return _plugin.isApplication(application);
        }

        public function isContainer(component:DisplayObject):Boolean{
            return _plugin.isContainer(component);
        }
        
        public function isComponent(component:DisplayObject):Boolean{
            return _plugin.isComponent(component);
        }
        
        public function getDocumentOf(component:DisplayObject):DisplayObject{
            return _plugin.getDocumentOf(component);
        }
        
        public function getChildren(component:DisplayObjectContainer):Vector.<DisplayObject>{
            return _plugin.getChildren(component);
        }
    }
}