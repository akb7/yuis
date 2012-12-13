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
package jp.akb7.yuis.customizer
{
    import __AS3__.vec.Vector;

    import flash.events.IEventDispatcher;

    import mx.core.UIComponent;

    import jp.akb7.yuis.core.reflection.ClassRef;
    import jp.akb7.yuis.core.reflection.FunctionRef;
    import jp.akb7.yuis.core.reflection.PropertyRef;
    import jp.akb7.yuis.YuiFrameworkGlobals;
    import jp.akb7.yuis.util.UIComponentUtil;
    import jp.akb7.yuis.core.ILifeCyclable;
    import jp.akb7.yuis.logging.debug;
    import jp.akb7.yuis.core.InstanceCache;
    import jp.akb7.yuis.convention.NamingConvention;

    [ExcludeClass]
    public final class ActionCustomizer extends AbstractComponentCustomizer {
        
        public override function customizeView(view:UIComponent ):void {
            const viewProperties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            const viewName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);
            const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    _debug("Customizing",viewClassName,actionClassName);
                }
                //
                const actionClassRef:ClassRef = getClassRef(actionClassName);
                const action:Object = InstanceCache.newInstance(actionClassRef);
                
                viewProperties[NamingConvention.ACTION] = action;
                
                if( action is ILifeCyclable ){
                    (action as ILifeCyclable).start();
                }
                //
                CONFIG::DEBUG {
                    _debug("Customized",viewClassName,actionClassName);
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _debug("CustomizeError",view,e.getStackTrace());
                }
            }
        }

        public override function uncustomizeView(view:UIComponent ):void {
            const viewProperties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    _debug("Uncustomizing",viewClassName,actionClassName);
                }
                const action:Object = viewProperties[NamingConvention.ACTION];
                if( action is ILifeCyclable ){
                    (action as ILifeCyclable).stop();
                }
                //
                viewProperties[NamingConvention.ACTION] = null;
                delete viewProperties[NamingConvention.ACTION];
                //
                CONFIG::DEBUG {
                    _debug("Uncustomized",viewClassName,actionClassName);
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _debug("CustomizeError",view,e.getStackTrace());
                }
            }
        }
    }
}