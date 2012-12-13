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
package jp.akb7.yuis.core
{
    import __AS3__.vec.Vector;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.TimerEvent;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    
    import jp.akb7.yuis.convention.NamingConvention;
    import jp.akb7.yuis.core.ns.yui_internal;
    import jp.akb7.yuis.core.reflection.ClassRef;
    import jp.akb7.yuis.core.reflection.FunctionInvoker;
    import jp.akb7.yuis.customizer.IElementCustomizer;
    import jp.akb7.yuis.logging.debug;
    import jp.akb7.yuis.logging.info;
    import jp.akb7.yuis.message.MessageManager;
    import jp.akb7.yuis.util.StyleManagerUtil;
    
    use namespace yui_internal;
    
    [ExcludeClass]
    /**
     * 
     * @author arikawa.eiichi
     * 
     */
    internal class YuiFrameworkControllerCore implements IYuiFrameworkController
    {
        include "../Version.as";
        
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
        protected var _rootDisplayObjectMap:Dictionary;
        
        /**
         * 
         */
        protected var _customizers:Vector.<IElementCustomizer>;
        
        /**
         * 
         */
        protected var _rootDisplayObjects:Vector.<DisplayObject>;
        
        /**
         * 
         * @return 
         * 
         */
        public function get rootDisplayObjects():Vector.<DisplayObject>{
            return _rootDisplayObjects;
        }
        
        /**
         * 
         * @return 
         * 
         */
        public function get currentRoot():DisplayObject{
            return null;
        }
        
        /**
         * 
         * 
         */
        public function YuiFrameworkControllerCore(){
            _rootDisplayObjects = new Vector.<DisplayObject>;
            _rootDisplayObjectMap = new Dictionary(true);
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
                debug(this,MessageManager.yui_internal::yuiframework.getMessage.apply(null,[resourceName].concat(parameters)));
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
                info(this,MessageManager.yui_internal::yuiframework.getMessage.apply(null,[resourceName].concat(parameters)));
            }
        }
        
        protected function registerRootDisplayObject(root:DisplayObject):void{
            CONFIG::DEBUG{
                _debug("RootAdd",root);
            }
            _rootDisplayObjects.push(root);
            _rootDisplayObjectMap[ root ] = _rootDisplayObjects.length-1;
        }
        
        protected function unregisterRootDisplayObject(root:DisplayObject):void{
            CONFIG::DEBUG{
                _debug("RootRemove",root);
            }
            if( root in _rootDisplayObjectMap ){
                var index:int = _rootDisplayObjectMap[ root ] as int;
                delete _rootDisplayObjectMap[ root ];
                _rootDisplayObjects.splice(index,1);
            }
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