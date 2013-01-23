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
    
    import yuis.Yuis;
    import yuis.convention.NamingConvention;
    import yuis.core.reflection.ClassRef;
    import yuis.core.reflection.PropertyRef;
    import yuis.framework.InstanceCache;
    import yuis.util.UIComponentUtil;
    
    [ExcludeClass]
    public final class CommandCustomizer extends AbstractComponentCustomizer {
        
        public override function customizeView(view:UIComponent):void {
            const properties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            
            try {
                const action:Object = properties[NamingConvention.ACTION];
                
                if(action == null) {
                    //no action 
                } else {
                    processCustomize(action);
                    const behaviors:Array = properties[NamingConvention.BEHAVIOR];
                    if(behaviors != null) {
                        for each(var behavior:Object in behaviors) {
                            processCustomize(behavior);
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
            const properties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            
            try {
                const action:Object = properties[NamingConvention.ACTION];
                
                if(action != null) {
                    processUncustomize(action);
                }
                
                const behaviors:Array = properties[NamingConvention.BEHAVIOR];
                if(behaviors != null) {
                    for each(var behavior:Object in behaviors) {
                        processUncustomize(behavior);
                    }
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _debug("CustomizeError",view,e.getStackTrace());
                }
            }
        }
        
        private function processCustomize(target:Object):void {
            const classRef:ClassRef = getClassRef(target);
            
            var command:Object;
            for each(var propertyRef:PropertyRef in classRef.properties) {
                var className:String = propertyRef.typeClassRef.className;
                if(
                    Yuis.namingConvention.isCommandClassName(className) &&
                    (!propertyRef.typeClassRef.isInterface)
                ) {
                    CONFIG::DEBUG {
                        _debug("Customizing",classRef.name,propertyRef.name);
                    }
                    command = InstanceCache.newInstance( propertyRef.typeClassRef );
                    propertyRef.setValue(target,command);
                    CONFIG::DEBUG {
                        _debug("Customized",classRef.name,propertyRef.name);
                    }
                }
            }
        }
        
        private function processUncustomize(target:Object):void {
            const classRef:ClassRef = getClassRef(target);
            
            for each(var propertyRef:PropertyRef in classRef.properties) {
                var className:String = propertyRef.typeClassRef.className;
                if(
                    Yuis.namingConvention.isCommandClassName(className) &&
                    (!propertyRef.typeClassRef.isInterface)
                ) {
                    CONFIG::DEBUG {
                        _debug("Uncustomizing",classRef.name,propertyRef.name);
                    }
                    propertyRef.setValue(target,null);
                    CONFIG::DEBUG {
                        _debug("Uncustomized",classRef.name,propertyRef.name);
                    }
                }
            }
        }
    }
}