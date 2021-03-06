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
    
    import mx.core.IVisualElementContainer;
    import mx.core.UIComponent;
    import mx.managers.ISystemManager;
    
    import spark.components.Application;
    import spark.components.Group;
    import spark.components.SkinnableContainer;
    import spark.components.supportClasses.Skin;
    
    import yuis.bridge.IFrameworkBridgePlugin;

    [ExcludeClass]
    public final class DefaultFrameworkBridgePlugin implements IFrameworkBridgePlugin {

        private static const ROOT_VIEW:String = "rootView";
        
        private static const SKIN_NAME:String = "Skin";
        
        private static const HOST_COMPONENT:String = "hostComponent";

        protected var _application:Application;

        public function get application():DisplayObjectContainer{
            return _application;
        }

        public function set application(value:DisplayObjectContainer):void{
            _application = value as Application;
        }

        public function get parameters():Object{
            return _application.parameters;
        }

        public function get systemManager():DisplayObject{
            return _application.systemManager as DisplayObject;
        }

        public function get rootView():DisplayObjectContainer{
            var result:UIComponent = null;
            if( _application.hasOwnProperty(ROOT_VIEW)){
                 result = _application[ ROOT_VIEW ] as UIComponent;
            }
            return result;
        }

        public function isApplication(component:DisplayObject):Boolean{
            return (component is spark.components.Application);
        }

        public function isContainer(component:DisplayObject):Boolean{
            return !( component is Skin ) && ( component is IVisualElementContainer ) && ( component is Group || component is SkinnableContainer );
        }
        
        public function isComponent(component:DisplayObject):Boolean{
            var className:String = getCanonicalName(component) as String;
            return !( component is Skin ) && !( className.indexOf(SKIN_NAME) == className.length-SKIN_NAME.length) && ( component is UIComponent);
        }
        
        public function getDocumentOf(component:DisplayObject):DisplayObject{
            var result:UIComponent = null;
            if( component is UIComponent ){
                result = (component as UIComponent).document as UIComponent;
                if( result is Skin && HOST_COMPONENT in result){
                    result = result[HOST_COMPONENT] as UIComponent;
                }
            }
            return result;
        }

        public function getChildren(component:DisplayObjectContainer):Vector.<DisplayObject>{
            var result:Vector.<DisplayObject> = new Vector.<DisplayObject>();
            if( component is IVisualElementContainer ){
                var container:IVisualElementContainer = component as IVisualElementContainer;
                var numChildren:int = container.numElements;
                for( var j:int = 0; j < numChildren; j++ ){
                    result.push(container.getElementAt(j));
                }
            }
            return result;
        }
    }
}