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
    import flash.system.System;

    [ExcludeClass]
    public final class ParameterRef extends ObjectRef {
        
        private var _index:int;

        public function get index():int{
            return _index;
        }

        private var _type:String;

        public function get type():String{
            return _type;
        }

        private var _isOptional:Boolean;

        public function get isOptional():Boolean{
            return _isOptional;
        }

        private var _isAnyType:Boolean;

        public function get isAnyType():Boolean{
            return _isAnyType;
        }
        
        public function ParameterRef( describeTypeXml:XML )
        {
            super( describeTypeXml );
            assembleThis( describeTypeXml );
            System.disposeXML(describeTypeXml);
        }

        private function assembleThis( describeTypeXml:XML ):void{
            var type:String = describeTypeXml.@type.toString();
            _index = parseInt( describeTypeXml.@index.toString());
            _type = getTypeString(type);
            _isOptional = ( type == ObjectRef.BOOL_TRUE);
            _isAnyType = ( _type == ObjectRef.TYPE_ANY );
        }

        protected override function getName( describeTypeXml:XML ):String{
            return describeTypeXml.@index.toString();
        }
    }
}