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
package jp.akb7.yuis.bridge
{
    import __AS3__.vec.Vector;

    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;

    [ExcludeClass]
    public interface IFrameworkBridgePlugin {
        function get application():DisplayObjectContainer;

        function set application(value:DisplayObjectContainer):void;

        function get parameters():Object;

        function get systemManager():DisplayObject;
        
        function get rootView():DisplayObjectContainer;

        function isApplication(application:DisplayObject):Boolean;

        function isContainer(component:DisplayObject):Boolean;

        function isComponent(component:DisplayObject):Boolean;

        function getDocumentOf(component:DisplayObject):DisplayObject;
        
        function getChildren(component:DisplayObjectContainer):Vector.<DisplayObject>;
    }
}