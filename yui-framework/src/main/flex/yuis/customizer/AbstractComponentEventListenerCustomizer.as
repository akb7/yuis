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
    import flash.events.IEventDispatcher;
    
    import mx.core.UIComponent;
    
    import __AS3__.vec.Vector;
    
    import yuis.core.reflection.ClassRef;
    import yuis.core.reflection.FunctionRef;
    import yuis.core.reflection.PropertyRef;
    
    [ExcludeClass]
    public class AbstractComponentEventListenerCustomizer extends AbstractComponentEventCustomizer {
        
        protected function doEventCustomize(name:String,component:UIComponent,listener:Object):void {
            const listenerClassRef:ClassRef = getClassRef(listener);
            const props:Vector.<PropertyRef> = listenerClassRef.properties;
            
            var child:Object;
            for each(var prop:PropertyRef in props) {
                child = prop.getValue(listener);
                
                if(child != null && child is IEventDispatcher) {
                    doCustomizingByComponent(
                        component,
                        prop.name,
                        child as IEventDispatcher,
                        listener,
                        listenerClassRef.functions.filter(
                            function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                            }
                        ),
                        int.MAX_VALUE>>2
                    );
                }
            }
        }
        
        protected function doEventUncustomize(component:UIComponent,listener:Object):void {
            const listenerClassRef:ClassRef = getClassRef(listener);
            const props:Vector.<PropertyRef> = listenerClassRef.properties;
            
            var child:Object;
            for each(var prop:PropertyRef in props) {
                child = prop.getValue(listener);
                
                if(child != null && child is IEventDispatcher) {
                    doUnCustomizingByComponent(
                        component,
                        prop.name,
                        child as IEventDispatcher,
                        listener,
                        listenerClassRef.functions.filter(
                            function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                            }
                        )
                    );
                }
            }
        }
    }
}