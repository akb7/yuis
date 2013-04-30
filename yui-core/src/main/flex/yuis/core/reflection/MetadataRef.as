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
    public final class MetadataRef extends ObjectRef {

        private var _args:Vector.<String>;

        public function get args():Vector.<String>{
            return _args;
        }

        private var _argMap:Object;

        public function MetadataRef( describeTypeXml:XML )
        {
            super( describeTypeXml );
            assembleArgs( describeTypeXml );
            System.disposeXML(describeTypeXml);
        }

        public function hasArgs():Boolean{
            return _args.length > 0;
        }

        public function getArgValue( key:String ):Object{
            return _argMap[ key ];
        }

        public function toString():String{
            var toString_:String = "[" + name + "]{";

            for( var key:String in _argMap ){
                toString_ += key + ":" + _argMap[ key ] + ",";
            }

            toString_ += "}";

            return toString_;
        }

        private function assembleArgs( describeTypeXml:XML ):void{
            _args = new Vector.<String>();
            _argMap = {};

            var argsXMLList:XMLList = describeTypeXml.arg;
            var name:String;
            var value:Object;
            for each( var argXML:XML in argsXMLList ){
                name = argXML.@key.toString();
                value = argXML.@value.toString();

                _args.push( name );
                _argMap[ name ] = value;
            }
        }
    }
}