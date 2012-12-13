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
package jp.akb7.yuis.logging
{
    import flash.errors.IllegalOperationError;
    import flash.utils.getDefinitionByName;
    
    import mx.core.ClassFactory;
    import mx.core.IFactory;
    
    import jp.akb7.yuis.core.ClassLoader;
    import jp.akb7.yuis.core.reflection.ClassRef;
    import jp.akb7.yuis.core.YuiFrameworkController;
    import jp.akb7.yuis.core.logging.ILogger;
    import jp.akb7.yuis.core.logging.ILoggerFactory;
    
    public final class Logging {
        
        private static const DEFAULT_LOGGER_FACTORY:ILoggerFactory = new SimpleLoggerFactory();
        
        private static var _loggerFactory:ILoggerFactory;
        
        public static function getLogger(target:Object):ILogger{
            return _loggerFactory.getLogger(target);
        }
        
        public static function initialize():void{
            var clazz:Class = null;
            try{
                clazz = findClass("jp.akb7.yuis.logging.LoggerFactory");
            } catch( e:Error ){
            }
            if( clazz == null ){
                _loggerFactory = DEFAULT_LOGGER_FACTORY;
            } else {
                _loggerFactory = new clazz() as ILoggerFactory;
            }
        }
    }
}