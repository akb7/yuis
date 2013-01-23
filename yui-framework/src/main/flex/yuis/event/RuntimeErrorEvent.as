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
package yuis.event
{
    import flash.events.ErrorEvent;
    
    import yuis.core.reflection.ClassRef;
    
    public final class RuntimeErrorEvent extends ErrorEvent {
        
        public static const RUNTIME_ERROR:String = "runtimeError";
        
        public static function createEvent( e:Error ):RuntimeErrorEvent{
            var runtimeErrorEvent:RuntimeErrorEvent = new RuntimeErrorEvent(RUNTIME_ERROR, e);
            runtimeErrorEvent.error = e;
            return runtimeErrorEvent;
        }
        
        private var _error:Error;

        public function get error():Error{
            return _error;
        }

        public function set error(value:Error):void{
            _error = value;
        }

        public function RuntimeErrorEvent(type:String, error:Error, bubbles:Boolean = true, cancelable:Boolean = true){
            super(type,bubbles,cancelable,error.toString(),error.errorID);
            this.error = error;
        }
    }
}