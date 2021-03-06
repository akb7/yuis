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
    
    import __AS3__.vec.Vector;

    [ExcludeClass]
    public final class FunctionRef extends AnnotatedObjectRef {
        
        private var _isInitialiedParameters:Boolean;

        private var _parameters:Vector.<ParameterRef>;

        public function get parameters():Vector.<ParameterRef>{
            return _parameters;
        }

        private var _parameterMap:Object;

        private var _returnType:String;

        public function get returnType():String{
            return _returnType;
        }

        private var _isReturnAnyType:Boolean;

        public function get isReturnAnyType():Boolean{
            return _isReturnAnyType;
        }

        private var _declaredBy:String;

        public function get declaredBy():String{
            return _declaredBy;
        }

        public function FunctionRef( describeTypeXml:XML )
        {
            super( describeTypeXml );
            assembleThis( describeTypeXml );
            assembleParameter(describeTypeXml );
            System.disposeXML(describeTypeXml);
        }

        public function getFunction( object:Object ):Function{
            var result:Function = null;
            if( _uri == null || _uri.length == 0 ){
                result = object[ _name ];
            } else {
                var ns:Namespace = new Namespace(_uri);
                result = object.ns::[ _name ];
            }
            return result;
        }

        private function assembleThis( describeTypeXml:XML ):void{
            var access:String = describeTypeXml.@access.toString();
            _returnType = getTypeString(describeTypeXml.@returnType.toString());
            _declaredBy = getTypeString(describeTypeXml.@declaredBy.toString());

            _isReturnAnyType = ( _returnType == TYPE_ANY );
        }

        private function assembleParameter( describeTypeXml:XML ):void{
            _parameters = new Vector.<ParameterRef>();
            _parameterMap = {};

            var parameterRef:ParameterRef = null;
            var parametersXMLList:XMLList = describeTypeXml.parameter;
            for each( var parameterXML:XML in parametersXMLList ){
                parameterRef = new ParameterRef(parameterXML);

                _parameters.push( parameterRef );
                _parameterMap[ parameterRef.name ] = parameterRef;
            }

            _isInitialiedParameters = true;
        }
    }
}