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
    import flash.events.Event;
    import flash.utils.getQualifiedClassName;

    public function dump(target:Object,value:Object,...args):void{
        if( value is Event ){
            var event:Event = value as Event;
            Logging
                .getLogger(target)
                .debug.apply(null,["[EVENT] " + getCanonicalName(event)+"."+event.type+"|"+event.target].concat(args));
        }
    }
}