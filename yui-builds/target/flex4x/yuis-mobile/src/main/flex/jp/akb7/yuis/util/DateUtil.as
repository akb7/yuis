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
package jp.akb7.yuis.util
{
    public final class DateUtil {
        
        private static const _ZERO:String = "0";
        
        public static function getCurrentDateString():String{
            return toDateTimeString(new Date());
        }
        
        public static function toDateString(value:Date,dateDelimiter:String="/"):String{
            return StringUtil.fill(value.fullYear,4,_ZERO) +
                    dateDelimiter +
                    StringUtil.fill(value.month+1,2,_ZERO) +
                    dateDelimiter +
                    StringUtil.fill(value.date,2,_ZERO);
        }
        
        public static function toSimpleTimeString(value:Date,timeDelimiter:String=":"):String{
            return StringUtil.fill(value.hours,2,_ZERO) +
                    timeDelimiter +
                    StringUtil.fill(value.minutes,2,_ZERO) +
                    timeDelimiter +
                    StringUtil.fill(value.seconds,2,_ZERO);
        }
        
        public static function toTimeString(value:Date,timeDelimiter:String=":",msDelimiter:String=","):String{
            return toSimpleTimeString(value,timeDelimiter)+
                    msDelimiter +
                    StringUtil.fill(value.milliseconds,3,_ZERO);
        }
        
        public static function toSimpleDateTimeString(value:Date,dateDelimiter:String="/",dateTimeDelimiter:String=" ",timeDelimiter:String=":"):String{
            return toDateString(value,dateDelimiter) + 
                    dateTimeDelimiter +
                    toSimpleTimeString(value,timeDelimiter);
        }
        
        public static function toDateTimeString(value:Date,dateDelimiter:String="/",dateTimeDelimiter:String=" ",timeDelimiter:String=":",msDelimiter:String=","):String{
            return toDateString(value,dateDelimiter) + 
                    dateTimeDelimiter +
                    toTimeString(value,timeDelimiter,msDelimiter);
        }
    }
}