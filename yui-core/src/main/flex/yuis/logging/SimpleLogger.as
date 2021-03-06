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
package yuis.logging
{
    import flash.utils.getTimer;
    
    import yuis.core.logging.ILogger;
    import yuis.util.DateUtil;
    
    public final class SimpleLogger implements ILogger {
        
        public function error(message:String,...args):void{
            log.apply(null,["[ERROR]",message].concat(args));
        }
        
        public function debug(message:String,...args):void{
            log.apply(null,["[DBGUG]",message].concat(args));
        }
        
        public function info(message:String,...args):void{
            log.apply(null,["[INFO_]",message].concat(args));
        }
        
        public function fatal(message:String,...args):void{
            log.apply(null,["[FATAL]",message].concat(args));
        }
        
        public function warn(message:String,...args):void{
            log.apply(null,["[WARN_]",message].concat(args));
        }
        
        private function log(level:String,message:String,...args):void{
            var time:String = "[" + DateUtil.getCurrentDateString() + "]";
            if( args.length == 0 ){
                trace(time,level,message);
            } else {
                trace.apply(null,[time,level,message].concat(args));
            }
        }
    }
}