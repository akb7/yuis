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
package yuis.core.reflection
{
    [ExcludeClass]
    internal class ObjectRef {
        
        internal static const BOOL_TRUE:String = "true";
        
        internal static const BOOL_FALSE:String = "false";
        
        internal static const CLASS_NAME_SEPARATOR:String = "::";

        internal static const DOT:String = ".";

        internal static const TYPE_ANY:String = "*";

        internal static const EXCLUDE_DECLARED_BY_FILTER_REGEXP:RegExp = new RegExp(/^((mx\.)|(flash\.)|(fl\.)|(spark\.)|(air\.)|(yuis\.))/);

        internal static const EXCLUDE_URI_FILTER_REGEXP:RegExp = new RegExp(/^(http:\/\/adobe.com)/);

        internal static function getTypeString( type:String ):String{
            if( type != TYPE_ANY){
                return type.replace(CLASS_NAME_SEPARATOR,DOT);
            } else {
                return type;
            }
        }

        internal static function getTypeName( type:String ):String{
            var result:String;
            var dotIndex:int = type.lastIndexOf(DOT);
            if( dotIndex > 0 ) {
                result = type.substring(dotIndex+1);
            } else {
                result = type;
            }
            return result;
        }

        protected var _name:String;

        public function get name():String{
            return _name;
        }

        protected var _uri:String;

        public function get uri():String{
            return _uri;
        }

        public function ObjectRef( describeTypeXml:XML ){
            _name = getName( describeTypeXml );
            _uri = getUri( describeTypeXml );
        }
        
        public function dispose():void{
        }

        protected function getName( describeTypeXml:XML ):String{
            return describeTypeXml.@name.toString();
        }

        protected function getUri( describeTypeXml:XML ):String{
            return describeTypeXml.@uri.toString();
        }
    }
}