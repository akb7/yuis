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
    import yuis.ns.viewpart;
    import yuis.util.UIComponentUtil;

    [ExcludeClass]
    public final class ValidatorCustomizer extends AbstractComponentCustomizer {
        
        public override function customizeView(container:UIComponent):void {
            const viewProperties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const validatorClassName:String = Yuis.namingConvention.getValidatorClassName(viewClassName);

            try {
                const action:Object = viewProperties[NamingConvention.ACTION];
                if(action == null) {
                    //no action
                } else {
                    CONFIG::DEBUG {
                        _debug("Customizing",viewClassName,validatorClassName);
                    }
                    viewProperties[NamingConvention.VALIDATOR] = {};
                    //
                    setValidatorProperties(container,action);
                    //
                    const behaviors:Array = viewProperties[NamingConvention.BEHAVIOR];
                    if(behaviors != null) {
                        for each( var behavior:Object in behaviors){
                            setValidatorProperties(container,behavior);
                        }
                    }
                    CONFIG::DEBUG {
                        _debug("Customized",viewClassName,validatorClassName);
                    }
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _debug("CustomizeError",container,e.getStackTrace());
                }
            }
        }

        public override function uncustomizeView(container:UIComponent):void {
            const viewProperties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const validatorClassName:String = Yuis.namingConvention.getValidatorClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    _debug("Uncustomizing",viewClassName,validatorClassName);
                }
                //
                const validatorMap:Object = viewProperties[NamingConvention.VALIDATOR];
                for each( var validator:Object in validatorMap){
                    setPropertiesValue(validator,viewClassName,null);
                }
                viewProperties[NamingConvention.VALIDATOR] = null;
                delete viewProperties[NamingConvention.VALIDATOR];
                //
                CONFIG::DEBUG {
                    _debug("Uncustomized",viewClassName,validatorClassName);
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _debug("CustomizeError",container,e.getStackTrace());
                }
            }
        }
        
        
        private function setValidatorProperties(container:UIComponent,obj:Object):void{
            const viewProperties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const targetClassRef:ClassRef = getClassRef(obj);
            const validatorMap:Object = viewProperties[NamingConvention.VALIDATOR];
            const props:Vector.<PropertyRef> = 
                targetClassRef.properties.filter(
                    function(item:*,index:int,array:Vector.<PropertyRef>):Boolean {
                        return ( Yuis.namingConvention.isValidatorOfView( viewClassName, (item as PropertyRef).typeClassRef.name ));
                    }
                );
            
            var validator:Object;
            var validatorClassRef:ClassRef;
            for each(var prop:PropertyRef in props) {
                validatorClassRef = getClassRef(prop.typeClassRef.name);
                if( validatorClassRef.name in validatorMap){
                    validator = validatorMap[validatorClassRef.name];
                } else {
                    validator = InstanceCache.newInstance(prop.typeClassRef);
                    validatorMap[validatorClassRef.name] = validator;               
                }
                
                setPropertiesValue(validator,viewClassName,container);
                setViewParts(container,validatorClassRef,validator);

                prop.setValue(obj,validator);
            }
        }
        
        private function setViewParts(container:UIComponent,validatorClassRef:ClassRef,validator:Object):void{
            const ns:Namespace = viewpart;
            const validatorProps:Vector.<PropertyRef> = validatorClassRef.properties;
            
            for each(var validatorProp:PropertyRef in validatorProps) {
                if( validatorProp.uri == ns.uri){
                    if( validatorProp.name in container ){
                        validatorProp.setValue(validator,container[validatorProp.name]);
                    }
                }
            }       
        }
    }
}