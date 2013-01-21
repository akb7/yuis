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
package yuis.customizer
{
    import mx.core.UIComponent;
    
    import __AS3__.vec.Vector;
    
    import yuis.Yuis;
    import yuis.convention.NamingConvention;
    import yuis.core.reflection.ClassRef;
    import yuis.core.reflection.PropertyRef;
    import yuis.framework.InstanceCache;
    import yuis.util.UIComponentUtil;

    [ExcludeClass]
    public final class BehaviorCustomizer extends AbstractComponentCustomizer {
        
        public override function customizeView(view:UIComponent):void {
            const viewProperties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            const viewName:String = Yuis.namingConvention.getComponentName(view);
            
            try {
                const action:Object = viewProperties[NamingConvention.ACTION];
                if( action == null ){
                    //no action
                } else {
                    const actionClassRef:ClassRef = getClassRef(action);
                    const props:Vector.<PropertyRef> = actionClassRef.properties;
    
                    var behaviors:Array = viewProperties[NamingConvention.BEHAVIOR] = [];
                    var behavior:Object;
                    for each(var prop:PropertyRef in props) {
                        if( Yuis.namingConvention.isBehaviorClassName( prop.typeClassRef.name )){
    
                            CONFIG::DEBUG {
                                _debug("Customizing",viewClassName,prop.typeClassRef.name);
                            }
                            behavior = InstanceCache.newInstance(prop.typeClassRef);
                            prop.setValue(action,behavior);
                            behaviors.push(behavior);
    
                            CONFIG::DEBUG {
                                _debug("Customized",viewClassName,prop.typeClassRef.name);
                            }
                        } else {
                            CONFIG::DEBUG {
                                if( Yuis.namingConvention.isBehaviorClassName(prop.typeClassRef.name)){
                                    _debug("CustomizeWarning",prop.typeClassRef.name+"isn't the Behavior Class of "+viewClassName);
                                }
                            }
                        }
                        
                    }
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _debug("CustomizeError",view,e.getStackTrace());
                }
            }

        }

        public override function uncustomizeView(view:UIComponent):void {
            const viewProperties:Object = UIComponentUtil.getProperties(view);
            const viewName:String = Yuis.namingConvention.getComponentName(view);
            const viewClassName:String = getCanonicalName(view);
            const action:Object = viewProperties[NamingConvention.ACTION];
            if( action == null ){
                return;
            }
            try {
                const actionClassRef:ClassRef = getClassRef(action);
                const props:Vector.<PropertyRef> = actionClassRef.properties;

                var behaviors:Array = viewProperties[NamingConvention.BEHAVIOR];
                var behaviorClassName:String;
                for each(var behavior:Object in behaviors) {
                    CONFIG::DEBUG {
                        _debug("Uncustomizing",viewClassName,behaviorClassName);
                    }
					//
                    behaviorClassName = getCanonicalName(behavior);
                    ClassRef.clearCache(behaviorClassName);
                    //
                    CONFIG::DEBUG {
                        _debug("Uncustomized",viewClassName,behaviorClassName);
                    }
                }
                viewProperties[NamingConvention.BEHAVIOR] = null;
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _debug("CustomizeError",view,e.getStackTrace());
                }
            }
        }
    }
}