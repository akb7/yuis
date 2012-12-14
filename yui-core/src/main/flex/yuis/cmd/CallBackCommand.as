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
package yuis.cmd
{
    public final class CallBackCommand extends AsyncCommand {
        
        private var _callback:Function;
        
        public function CallBackCommand(callback:Function){
            super();
            _callback = callback;
        }
        
        protected final override function runAsync():void{
            try{
                var callbackResult:* = _callback.apply(null,[argument]);
                
                if( callbackResult == undefined ){
                    doneAsync();
                } else {
                    returnAsync(callbackResult);
                }
            } catch( e:Error ) {
                errorAsync(e);
            }
        }
    }
}