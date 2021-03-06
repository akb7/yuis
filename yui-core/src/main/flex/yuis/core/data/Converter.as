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
package yuis.core.data
{
    import flash.utils.ByteArray;
    
    import yuis.core.reflection.ClassRef;
    import yuis.core.reflection.PropertyRef;
    
    public final class Converter {
        
        private static var cloneBuffer:ByteArray = new ByteArray();
        
        private static var _instance:Converter;
                
        public static function getInstanceBy():Converter{
            if( _instance == null ){
                _instance = new Converter();
            }
            
            return _instance;
        }
        
        public function convert(value:Object,toClass:Class):Object{
            var result:Object = null;
            if( value != null && toClass != null ){
                result = processObjectConvert(value,toClass);
            }
            
            return result;
        }
        
        private function processObjectConvert(value:Object,toClass:Class):Object{
            var result:Object = new toClass();
            
            var toClassRef:ClassRef = ClassRef.getInstance(toClass);
            var objectClassRef:ClassRef = ClassRef.getInstance(value);
            
            if( toClassRef.name == objectClassRef.name ){
                return doClone(value);
            } else {
                if(!toClassRef.isInterface){
                    for each( var propertyRef:PropertyRef in toClassRef.properties ){
                        if( propertyRef.name in value ){
                            result[propertyRef.name] = processPropertyConvert(value[propertyRef.name],propertyRef.typeClassRef);
                        }
                    }
                }
            }
                
            return result;
        }
        
        private function processPropertyConvert(value:Object,classRef:ClassRef):*{
            var result:Object;
            if( classRef.isPrimitive ){
                result = value;
            } else if( classRef.isTopLevel ){
                result = doClone(value);
            } else if( classRef.isArray ){
                result = doArrayConvert(value as Array);
            } else if( classRef.isVector ){
                result = doVectorConvert(value,classRef);
            } else {
                result = doConvertTypedObject(value,classRef);
            }
            return result;
        }
        
        private function doClone(value:Object):*{
            if( value == null ){
                return null;
            }
            
            cloneBuffer.clear();
            cloneBuffer.position = 0;
            
            cloneBuffer.writeObject(value);
            cloneBuffer.position = 0;
            
            var result:Object = cloneBuffer.readObject();
            
            return result;
        }
        
        private function doArrayConvert(value:Array):*{
            return doClone(value);
        }
        
        private function doVectorConvert(value:Object,classRef:ClassRef):*{
            if( value == null ){
                return null;
            }
            var propertyName:String = classRef.name;
            var result:Object = classRef.newInstance();
            var numLen:int = value.length;
            var className:String = propertyName.substring(ClassRef.VECTOR_CLASS.length,propertyName.length-1);
            for (var i:int = 0; i < numLen; i++)
            {
                result[i] = processPropertyConvert(value[i],getClassRef(className));
            }
            
            return result;
        }
        
        private function doConvertTypedObject(value:Object,classRef:ClassRef):*{
            if( value == null ){
                return null;
            }
            var result:Object = processObjectConvert(value,classRef.concreteClass);
            
            return result;
        }
    }
}