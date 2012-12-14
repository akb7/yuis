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
package yuis.framework.mixin
{
    import flash.display.DisplayObject;
    
    import mx.core.IFlexModuleFactory;
    import mx.managers.ISystemManager;
    
    import yuis.Yuis;
    import yuis.bridge.FrameworkBridge;
    import yuis.framework.YuiFrameworkController;
    
    import yuis.core.ns.yui_internal;

    [ExcludeClass]
    [Mixin]
    [ResourceBundle("conventions")]
    /**
     * YuiFramework初期設定用Mixinクラス
     *
     * @author $Author: e1arkw $
     * @version $Revision: 1739 $
     */
    public final class YuiFrameworkMixin
    {
        private static var _this:YuiFrameworkMixin;

        private static var _container:YuiFrameworkController;

        public static function init( flexModuleFactory:IFlexModuleFactory ):void{            
            _this = new YuiFrameworkMixin();
            _container = new YuiFrameworkController();
            Yuis.yui_internal::setFrameworkBridge( FrameworkBridge.initialize() );

            if( flexModuleFactory is ISystemManager ){
                var systemManager_:ISystemManager = flexModuleFactory as ISystemManager;
                var root:DisplayObject = systemManager_ as DisplayObject;
                _container.yui_internal::systemManagerMonitoringStart(root);
            }
        }
    }
}