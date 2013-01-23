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
    public final class PropertyRef extends AnnotatedObjectRef {
        
        private static const WRITE_ONLY:String = "writeonly";
        
        private static const READ_ONLY:String = "readonly";
        
        private static const READ_WRITE:String = "readwrite";

        private var _isReadable:Boolean;

        public function get isReadable():Boolean{
            return _isReadable;
        }

        private var _isWriteable:Boolean;

        public function get isWriteable():Boolean{
            return _isWriteable;
        }

        private var _type:String;

        public function get type():String{
            return _type;
        }

        public function get typeClassRef():ClassRef{
            return getClassRef(type);
        }

        private var _declaredBy:String;

        public function get declaredBy():String{
            return _declaredBy;
        }

        public function PropertyRef( describeTypeXml:XML ){
            super( describeTypeXml );
            assembleThis( describeTypeXml );
        }

        public function getValue( target:Object ):Object{
            var result:Object = null;
            if( _uri == null || _uri.length == 0 ){
                result = target[ _name ];
            } else {
                var ns:Namespace = new Namespace(_uri);
                result = target.ns::[ _name ];
            }
            return result;
        }

        public function setValue( target:Object, value:Object ):void{
            if( _uri == null || _uri.length == 0 ){
                target[ _name ] = value;
            } else {
                var ns:Namespace = new Namespace(_uri);
                target.ns::[ _name ] = value;
            }
        }

        private function assembleThis( rootDescribeTypeXml:XML ):void{
            var access:String = rootDescribeTypeXml.@access.toString();
            _isReadable = ( access == READ_ONLY || access == READ_WRITE );
            _isWriteable = ( access == WRITE_ONLY || access == READ_WRITE );
            _type = getTypeString(rootDescribeTypeXml.@type.toString());
            _declaredBy = getTypeString(rootDescribeTypeXml.@declaredBy.toString());
        }
    }
}