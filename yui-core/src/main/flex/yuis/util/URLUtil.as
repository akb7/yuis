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
package yuis.util {

    public final class URLUtil {
        
        private static const SERVER_URL_PATTERN:RegExp = /^http[s]?:\/\/.+?\//;

        private static const SWF_DIR_URL_PATTERN:RegExp = /^http[s]?:\/\/.+\//;

        private static const HTTP:String = "http";

        private static const SLASH:String = "/";

        public static function isValidHttpUrl( url:String ):Boolean{
            return url != null && ( isHttpURL(url) || isHttpsURL(url));
        }

        public static function isHttpURL( url:String ):Boolean{
            return url != null && ( url.indexOf("http://") == 0 );
        }

        public static function isHttpsURL( url:String ):Boolean{
            return url != null && ( url.indexOf("https://") == 0 );
        }
    }
}