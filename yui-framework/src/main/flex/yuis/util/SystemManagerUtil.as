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
package yuis.util
{
    import mx.managers.ISystemManager;

    [ExcludeClass]
    public final class SystemManagerUtil {
        
        public static function getRootSystemManager(systemManager:ISystemManager):ISystemManager{
            if( systemManager != null ){
                return systemManager.getSandboxRoot() as ISystemManager;
            }
            return null;
        }
    }
}