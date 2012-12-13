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
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.utils.Dictionary;
    
    import jp.akb7.yuis.core.reflection.ClassRef;
    import jp.akb7.yuis.core.rule.IVolatileObject;
    import jp.akb7.yuis.logging.debug;
    
    [ExcludeClass]
    /**
     * 
     */
    public final class InstanceCache {
        
        /**
         * @private 
         */
        private static const INSTANCE_REF_CACHE:Dictionary = new Dictionary(true);
        
        /**
         * 
         * @param classRef
         * @param args
         * @return 
         * 
         */
        public static function newInstance(classRef:ClassRef,...args):Object{
            var result:Object = null;
            var cache:Dictionary = getCurrentInstanceRefCache();
            if( classRef.name in cache ){
                result = cache[ classRef.name ];
            } else {
                result = classRef.newInstance.apply(null,args);
                if( result is IVolatileObject ){
                } else {
                    cache[ classRef.name ] = result;
                }
            }
            return result;
        }

        /**
         * 
         * @param root
         * 
         */
        public static function addRoot(root:Object):void{
            if( root != null ){
                removeRoot(root);
                INSTANCE_REF_CACHE[root] = new Dictionary(true);
            }
        }
        
        /**
         * 
         * @param root
         * 
         */
        public static function removeRoot(root:Object):void{
            if( root != null && root in INSTANCE_REF_CACHE ){
                INSTANCE_REF_CACHE[root] = null;
                delete INSTANCE_REF_CACHE[root];
            }
        }
        
        /**
         * @private
         */
        private static function getCurrentInstanceRefCache():Dictionary{
            const currentRoot:Object = YuiFrameworkController.getInstance().currentRoot;
            var result:Dictionary;
            if( currentRoot in INSTANCE_REF_CACHE ){
                result = INSTANCE_REF_CACHE[ currentRoot ];   
            } else {
                result = new Dictionary(true);
                INSTANCE_REF_CACHE[ currentRoot ] = result;
            }
            return result;
        }
    }
}