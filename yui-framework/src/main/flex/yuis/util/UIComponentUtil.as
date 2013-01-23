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

    import mx.core.UIComponent;
    import mx.core.UIComponentDescriptor;
    import mx.core.mx_internal;

    [ExcludeClass]
    public final class UIComponentUtil {

        public static function getDescriptor( component:UIComponent ):UIComponentDescriptor{
            var result:UIComponentDescriptor = component.descriptor;
            if( result == null ){
                result = component.descriptor = new UIComponentDescriptor({});
            }
            if( result.events == null ){
                result.events = {};
            }
            return result;
        }

        public static function getDocumentDescriptor( component:UIComponent ):UIComponentDescriptor{
            var result:UIComponentDescriptor = component.mx_internal::documentDescriptor;
            if( result == null ){
                result = component.mx_internal::documentDescriptor = new UIComponentDescriptor({});
            }
            if( result.events == null ){
                result.events = {};
            }
            return result;
        }

        public static function getProperties( component:UIComponent ):Object{
            return getDescriptor(component).properties;
        }
    }
}