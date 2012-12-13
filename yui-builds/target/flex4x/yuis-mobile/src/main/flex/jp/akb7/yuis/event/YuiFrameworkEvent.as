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
package jp.akb7.yuis.event
{
    import flash.events.Event;
    
    [ExcludeClass]
    public final class YuiFrameworkEvent extends Event {
        
        public static const APPLICATION_MONITOR_START:String = "applicationMonitorStart";
        
        public static const APPLICATION_MONITOR_STOP:String = "applicationMonitorStop";
        
        public static const APPLICATION_START:String = "applicationStart";

        public static const VIEW_INITIALIZED:String = "viewInitialized";
        
        public function YuiFrameworkEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
            super(type, bubbles, cancelable);
        }
        
        public override function clone():Event{
            return new YuiFrameworkEvent(type, bubbles, cancelable);
        }
        
        public override function toString():String{
            return formatToString("YuiFrameworkEvent", "type", "bubbles", "cancelable","eventPhase");
        }
    }
}