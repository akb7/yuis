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
    import yuis.framework.ILifeCyclable;
    import yuis.framework.InstanceCache;
    import yuis.core.reflection.ClassRef;
    import yuis.core.reflection.PropertyRef;
    import yuis.ns.viewpart;
    import yuis.util.UIComponentUtil;

    [ExcludeClass]
    public final class HelperCustomizer extends AbstractComponentCustomizer implements IComponentCustomizer {
        
        public override function customizeView(container:UIComponent):void {
            const viewProperties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const helperClassName:String = Yuis.namingConvention.getHelperClassName(viewClassName);

            try {
                //
                const action:Object = viewProperties[NamingConvention.ACTION];
                
                if(action == null) {
                    //no action
                } else {
                    CONFIG::DEBUG {
                        _debug("Customizing",viewClassName,helperClassName);
                    }
                    viewProperties[NamingConvention.HELPER] = {};
                    setHelperProperties(container,action);
                    
                    //
                    const behaviors:Array = viewProperties[NamingConvention.BEHAVIOR];
                    if(behaviors != null) {
                        for each( var behavior:Object in behaviors){
                            setHelperProperties(container,behavior);
                        }
                    }
                    CONFIG::DEBUG {
                        _debug("Customized",viewClassName,helperClassName);
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
            const helperClassName:String = Yuis.namingConvention.getHelperClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    _debug("Uncustomizing",viewClassName,helperClassName);
                }
                //
                const helperMap:Object = viewProperties[NamingConvention.HELPER];
                for each( var helper:Object in helperMap){
                    if( helper is ILifeCyclable ){
                        (helper as ILifeCyclable).stop();
                    }
                    //
                    setPropertiesValue(helper,viewClassName,null);
                }
                viewProperties[NamingConvention.HELPER] = null;
                delete viewProperties[NamingConvention.HELPER];
                //
                CONFIG::DEBUG {
                    _debug("Uncustomized",viewClassName,helperClassName);
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _debug("CustomizeError",container,e.getStackTrace());
                }
            }
        }
        
        public function customizeComponent( view:UIComponent, component:UIComponent ):void{
            const viewProperties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            const helperClassName:String = Yuis.namingConvention.getHelperClassName(viewClassName);
            
            const helperMap:Object = viewProperties[NamingConvention.HELPER];
            const componentName:String = Yuis.namingConvention.getComponentName(component);
            for each( var helper:Object in helperMap){
                var helperClassRef:ClassRef = getClassRef(helper);
                var helperPropRef:PropertyRef = helperClassRef.getPropertyRef(componentName);
                if( helperPropRef != null && helperPropRef.uri == viewpart.toString()){
                    helperPropRef.setValue(helper,component);                   
                }
            }
        }
        
        public function uncustomizeComponent( view:UIComponent, component:UIComponent ):void{
            const viewProperties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            const helperClassName:String = Yuis.namingConvention.getHelperClassName(viewClassName);
            
            const helperMap:Object = viewProperties[NamingConvention.HELPER];
            const componentName:String = Yuis.namingConvention.getComponentName(component);
            for each( var helper:Object in helperMap){
                var helperClassRef:ClassRef = getClassRef(helper);
                var helperPropRef:PropertyRef = helperClassRef.getPropertyRef(componentName);
                if( helperPropRef != null && helperPropRef.uri == viewpart.toString()){
                    helperPropRef.setValue(helper,null);                   
                }
            }
        }
        
        
        private function setHelperProperties(container:UIComponent,obj:Object):void{
            const viewProperties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const targetClassRef:ClassRef = getClassRef(obj);
            const helperMap:Object = viewProperties[NamingConvention.HELPER];
            const props:Vector.<PropertyRef> =
                targetClassRef.properties.filter(
                    function(item:*,index:int,array:Vector.<PropertyRef>):Boolean {
                        return ( Yuis.namingConvention.isHelperOfView( viewClassName, (item as PropertyRef).typeClassRef.name ));
                    }
                );
            
            var helper:Object;
            var helperClassRef:ClassRef;
            for each(var prop:PropertyRef in props) {
                helperClassRef = getClassRef(prop.typeClassRef.name);
                if( helperClassRef.name in helperMap){
                    helper = helperMap[helperClassRef.name];
                } else {
                    helper = InstanceCache.newInstance(prop.typeClassRef);
                    helperMap[helperClassRef.name] = helper;               
                }
                
                setPropertiesValue(helper,viewClassName,container);
                setViewParts(container,helperClassRef,helper);

                prop.setValue(obj,helper);
                //
                if( helper is ILifeCyclable ){
                    (helper as ILifeCyclable).start();
                }
            }
        }

        private function setViewParts(container:UIComponent,helperClassRef:ClassRef,helper:Object):void{
            const ns:Namespace = viewpart;
            const helperProps:Vector.<PropertyRef> = helperClassRef.properties;
            
            for each(var helperProp:PropertyRef in helperProps) {
                if( helperProp.uri == ns.uri){
                    if( helperProp.name in container ){
                        helperProp.setValue(helper,container[helperProp.name]);
                    }
                }
            }       
        }
    }
}