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
package 
{
    import flash.events.IEventDispatcher;
    import jp.akb7.yuis.core.event.NotificationEvent;

    /**
     * 指定されたターゲットに対して通知を送ります。
     */
    public function sendNotification(target:IEventDispatcher,type:String,...args):void {
        var n:NotificationEvent;
        
        if( args.length > 1 ){
            n = new NotificationEvent(type,args);
        } else if( args.length == 1 ){
            n = new NotificationEvent(type,args[0]);
        } else {
            n = new NotificationEvent(type,null);
        }
        
        sendEvent(target,n);
    }
}