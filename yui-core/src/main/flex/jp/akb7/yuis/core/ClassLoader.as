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
    import flash.net.getClassByAlias;
    import flash.system.ApplicationDomain;
    import flash.utils.getDefinitionByName;
    
    import jp.akb7.yuis.core.error.ClassNotFoundError;

    public final class ClassLoader {
        
        public function findClass( name:String, ad:ApplicationDomain=null):Class {
            var clazz:Class = null;
            try{
                clazz = getDefinitionByName( name ) as Class;
            } catch( e:Error ){
            }
            if ( clazz == null ){
                try{
                    clazz = getClassByAlias( name );
                } catch( e:Error ){
                }
            }
            if ( clazz == null ){
                try{
                    clazz = findClassByApplicationDomain( name, ad == null ? ApplicationDomain.currentDomain : ad );
                } catch( e:Error ){
                }
            }
            if( clazz == null){
                var e:ClassNotFoundError = ClassNotFoundError.createError(name);
                throw e;
            }

            return clazz;
        }
        
        public function findClassByApplicationDomain( name:String, ad:ApplicationDomain):Class{
            var clazz:Class = null;
            if( ad.hasDefinition(name) ){
                clazz = ad.getDefinition( name ) as Class;
            }
            if( clazz == null){
                var e:ClassNotFoundError = ClassNotFoundError.createError(name);
                throw e;
            }
            return clazz;
        }
    }
}