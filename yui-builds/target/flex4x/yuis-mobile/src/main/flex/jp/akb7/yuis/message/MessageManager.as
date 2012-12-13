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
package jp.akb7.yuis.message
{
    import mx.resources.ResourceManager;
    
    import jp.akb7.yuis.core.ns.yui_internal;
    import jp.akb7.yuis.util.StringUtil;
    
    
    [ResourceBundle("messages")]    
    [ResourceBundle("application")] 
    [ResourceBundle("errors")]
    [ResourceBundle("yui_framework")]    
    public final class MessageManager {
        public static const messages:Messages = new Messages("messages");
        public static const application:Messages = new Messages("application");
        public static const errors:Messages = new Messages("errors");
        yui_internal static const yuiframework:Messages = new Messages("yui_framework");
    }
}