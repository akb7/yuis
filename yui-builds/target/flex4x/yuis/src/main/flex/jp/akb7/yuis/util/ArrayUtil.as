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
package jp.akb7.yuis.util
{
    import flash.utils.Dictionary;

    public final class ArrayUtil {
        
        private static const _UID_:String = "uid";
        
        public static function toUidMap(value:Array):Dictionary{
            return toMap(value,_UID_);
        }
        
        public static function toMap(value:Array,key:String=null):Dictionary{
            var map:Dictionary = null;
            if( value != null ){
                if( key == null ){
                    map = toStringMap(value);
                } else {
                    map = toObjectMap(value,key);
                }
            }
            return map;
        }
        
        private static function toStringMap(value:Array):Dictionary{
            var map:Dictionary = new Dictionary();
            
            for each( var item:String in value ){
                map[ item ] = null;
            }
            
            return map;
        }
        
        private static function toObjectMap(value:Array,key:String):Dictionary{
            var map:Dictionary = new Dictionary();
            
            for each( var item:Object in value ){
                if( item.hasOwnProperty( key )){
                    map[ item[key] ] = item;
                }
            }
            
            return map;
        }
    }
}