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
    
    import yuis.convention.NamingConvention;
    import yuis.core.ns.yuis_internal;
    import yuis.core.reflection.FunctionInvoker;
    import yuis.customizer.IElementCustomizer;
    import yuis.logging.debug;
    import yuis.logging.info;
    import yuis.message.MessageManager;
    
    use namespace yuis_internal;
    
    [ExcludeClass]
    /**
     * 
     * @author arikawa.eiichi
     * 
     */
    internal class YuiFrameworkControllerCore implements IYuiFrameworkController
    {
        /**
         * 
         */
        protected var _isApplicationStarted:Boolean = true;
        
        /**
         * 
         */
        protected var _namingConvention:NamingConvention;
        
        /**
         * 
         */
        protected var _customizers:Vector.<IElementCustomizer>;
        
        /**
         * 
         */
        protected var _currentRoot:DisplayObject;
        
        /**
         * 
         * @return 
         * 
         */
        public function get currentRoot():DisplayObject{
            return _currentRoot;
        }
        
        /**
         * 
         * 
         */
        public function YuiFrameworkControllerCore(){
        }
        
        /**
         * 
         * @param root
         * 
         */
        public function addRootDisplayObject(root:DisplayObject ):void{
        }
        
        /**
         * 
         * @param root
         * 
         */
        public function removeRootDisplayObject(root:DisplayObject ):void{
        }
        
        /**
         * 
         * @param container
         * 
         */
        public function customizeView( container:DisplayObjectContainer ):void{
        }
        
        /**
         * 
         * @param container
         * 
         */
        public function uncustomizeView( container:DisplayObjectContainer ):void{
        }
        
        /**
         * 
         * @param container
         * @param child
         * 
         */
        public function customizeComponent( container:DisplayObjectContainer, child:DisplayObject):void{
        }
        
        /**
         * 
         * @param container
         * @param child
         * 
         */
        public function uncustomizeComponent( container:DisplayObjectContainer, child:DisplayObject):void{
        }
        
        /**
         * 
         * @param callBack
         * 
         */
        public function callLater(callBack:Function):void{
            new FunctionInvoker(callBack).invokeDelay();
        }
        
        CONFIG::DEBUG{
            /**
             * 
             * @param resourceName
             * @param parameters
             * 
             */
            protected function _debug(resourceName:String,...parameters):void{
                debug(this,MessageManager.yuis_internal::yuiframework.getMessage.apply(null,[resourceName].concat(parameters)));
            }
        }
        CONFIG::DEBUG{
            /**
             * 
             * @param resourceName
             * @param parameters
             * 
             */
            protected function _info(resourceName:String,...parameters):void{
                info(this,MessageManager.yuis_internal::yuiframework.getMessage.apply(null,[resourceName].concat(parameters)));
            }
        }
        
        protected function registerRootDisplayObject(root:DisplayObject):void{
            CONFIG::DEBUG{
                _debug("RootAdd",root);
            }
            _currentRoot = root;
        }
        
        protected function unregisterRootDisplayObject(root:DisplayObject):void{
            CONFIG::DEBUG{
                _debug("RootRemove",root);
            }
            _currentRoot = null;
        }
        
        protected function getDefaultCustomizers():Vector.<IElementCustomizer>{
            var classes:Array = getDefaultCustomizerClasses();
            var result:Vector.<IElementCustomizer> = new Vector.<IElementCustomizer>();
            for each( var customizerClass:Class in classes ){
                result.push(new customizerClass());
            }
            return result;
        }

        protected function getDefaultCustomizerClasses():Array{
            return [];
        }
    }
}