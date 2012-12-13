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
package jp.akb7.yuis.core.event
{
    import flash.events.Event;

    /**
     * 通知イベントクラス
     * 
     * 子コンポーネントから親コンテナにメッセージを通知するためのイベントクラスです。
     * 
     */
    public final class NotificationEvent extends Event {
        
        private var _data:Object;
        
        public function get data():Object {
            return _data;
        }
        
        public function NotificationEvent(type:String,data:Object) {
            super(type, true, true);
            _data = data;
        }
        
        public override function clone():Event{
            return new NotificationEvent(type, _data);
        }
        
        public override function toString():String{
            return formatToString("NotificationEvent", "type", "bubbles", "cancelable","eventPhase","data");
        }
    }
}