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
package yuis.core
{
    import flash.display.DisplayObject;
    import yuis.core.ns.yuis_internal;

    public final class Environment {
        
        private static var _parameters:Object = {};

        private static var _root:DisplayObject;

        public static function getParameterValue( parameterName:String ):String{
            return _parameters[ parameterName ];
        }

        public static function get application():DisplayObject{
            return _root;
        }
        
        public static function get url():String{
            if( _root == null ){
                return null;
            } else {
                return _root.stage.loaderInfo.url;
            }
        }
        
        yuis_internal static function setParameters( value:Object ):void{
            _parameters = value;
        }
        
        yuis_internal static function setApplication(value:DisplayObject):void{
            _root = value;
        }

    }
}