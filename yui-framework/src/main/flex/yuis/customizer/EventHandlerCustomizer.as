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
    
    import mx.core.IMXMLObject;
    import mx.core.IUIComponent;
    import mx.core.UIComponent;
    import mx.core.mx_internal;
    import mx.effects.IEffect;
    
    import __AS3__.vec.Vector;
    
    import yuis.Yuis;
    import yuis.convention.NamingConvention;
    import yuis.core.reflection.ClassRef;
    import yuis.core.reflection.FunctionRef;
    import yuis.core.reflection.PropertyRef;
    import yuis.util.UIComponentUtil;
    
    use namespace mx_internal;

    [ExcludeClass]
    public class EventHandlerCustomizer extends AbstractComponentEventCustomizer implements IComponentCustomizer {
        
        public function customizeComponent( owner:UIComponent, component:UIComponent ):void{
            const componentName:String = Yuis.namingConvention.getComponentName(component);
            const ownerName:String = Yuis.namingConvention.getComponentName(owner);
            const ownerClassName:String = getCanonicalName(component);
            const ownerProperties:Object = UIComponentUtil.getProperties(owner);
            const ownerAction_:Object = ownerProperties[NamingConvention.ACTION];
            
            if(ownerAction_ != null) {
                const actionClassRef:ClassRef = getClassRef(ownerAction_);
                CONFIG::DEBUG {
                    _debug("Customizing",ownerName+"#"+componentName,actionClassRef.name);
                }
                doCustomizingByComponent(
                    owner,
                    componentName,
                    component,
                    ownerAction_,
                    actionClassRef.functions.filter(
                        function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                            return ((item as FunctionRef).name.indexOf(componentName) == 0);
                        }
                    ),
                    int.MAX_VALUE>>1
                );
                CONFIG::DEBUG {
                    _debug("Customized",ownerName+"#"+componentName,actionClassRef.name);
                }
            }
            //
            const ownerBehaviors_:Array = ownerProperties[NamingConvention.BEHAVIOR];
            
            if(ownerBehaviors_ != null) {
                var behaviorClassRef:ClassRef;
                for each(var ownerBehavior_:Object in ownerBehaviors_) {
                    behaviorClassRef = getClassRef(ownerBehavior_);
                    CONFIG::DEBUG {
                        _debug("Customizing",ownerClassName+"#"+componentName,behaviorClassRef.name);
                    }
                    doCustomizingByComponent(
                        owner,
                        componentName,
                        component,
                        ownerBehavior_,
                        behaviorClassRef.functions.filter(
                            function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                return ((item as FunctionRef).name.indexOf(componentName) == 0);
                            }
                        ),
                        0
                    );
                    CONFIG::DEBUG {
                        _debug("Customized",ownerClassName+"#"+componentName,behaviorClassRef.name);
                    }
                }
            }
        }

        public override function customizeView(view:UIComponent):void {
            const viewName:String = Yuis.namingConvention.getComponentName(view);
            const viewClassName:String = getCanonicalName(view);
            const actionClassName:String = Yuis.namingConvention.getActionClassName(viewClassName);
            const viewProperties:Object = UIComponentUtil.getProperties(view);
            //
            const action_:Object = viewProperties[NamingConvention.ACTION];

            if(action_ != null) {
                CONFIG::DEBUG {
                    _debug("Customizing",viewClassName,actionClassName);
                }
                doCustomize(view,action_,int.MAX_VALUE>>1);
                
                doEventCustomize(viewName,view,action_);
                CONFIG::DEBUG {
                    _debug("Customized",viewClassName,actionClassName);
                }
            }
            //
            const behaviors_:Array = viewProperties[NamingConvention.BEHAVIOR];

            if(behaviors_ != null) {
                var behaviorClassName:String;
                for each(var behavior_:Object in behaviors_) {
                    behaviorClassName = getCanonicalName(behavior_);
                    CONFIG::DEBUG {
                        _debug("Customizing",viewClassName,behaviorClassName);
                    }
                    doCustomize(view,behavior_,int.MAX_VALUE>>1);
                    
                    doEventCustomize(viewName,view,behavior_);
                    CONFIG::DEBUG {
                        _debug("Customized",viewClassName,behaviorClassName);
                    }
                }
            }
        }

        public function isTargetComponent( component:UIComponent ):Boolean{
            return component.initialized && component.parent != null;
        }
        
        public function uncustomizeComponent( owner:UIComponent, component:UIComponent):void{
            const componentName:String = Yuis.namingConvention.getComponentName(component);
            const ownerClassName:String = getCanonicalName(owner);
            const ownerProperties:Object = UIComponentUtil.getProperties(owner);
            const ownerAction_:Object = ownerProperties[NamingConvention.ACTION];
            
            if(ownerAction_ != null) {
                const actionClassRef:ClassRef = getClassRef(ownerAction_);
                CONFIG::DEBUG {
                    _debug("Uncustomizing",ownerClassName+"#"+componentName,actionClassRef.name);
                }
                doUnCustomizingByComponent(
                    owner,
                    componentName,
                    component,
                    ownerAction_,
                    actionClassRef.functions.filter(
                        function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                            return ((item as FunctionRef).name.indexOf(componentName) == 0);
                        }
                    )
                );
                CONFIG::DEBUG {
                    _debug("Uncustomized",ownerClassName+"#"+componentName,actionClassRef.name);
                }
            }
            //
            const ownerBehaviors_:Array = ownerProperties[NamingConvention.BEHAVIOR];
            
            if(ownerBehaviors_ != null) {
                var behaviorClassRef:ClassRef;
                for each(var ownerBehavior_:Object in ownerBehaviors_) {
                    behaviorClassRef = getClassRef(ownerBehavior_);
                    CONFIG::DEBUG {
                        _debug("Uncustomizing",ownerClassName+"#"+componentName,behaviorClassRef.name);
                    }
                    doUnCustomizingByComponent(
                        owner,
                        componentName,
                        component,
                        ownerBehavior_,
                        behaviorClassRef.functions.filter(
                            function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                return ((item as FunctionRef).name.indexOf(componentName) == 0);
                            }
                        )
                    );
                    CONFIG::DEBUG {
                        _debug("Uncustomized",ownerClassName+"#"+componentName,behaviorClassRef.name);
                    }
                }
            }
        }
        
        public override function uncustomizeView(view:UIComponent):void {
            const viewProperties:Object = UIComponentUtil.getProperties(view);
            const viewName:String = Yuis.namingConvention.getComponentName(view);
            const viewClassName:String = getCanonicalName(view);
            const actionClassName:String = Yuis.namingConvention.getActionClassName(viewClassName);

            const action_:Object = viewProperties[NamingConvention.ACTION];

            if(action_ != null) {
                CONFIG::DEBUG {
                    _debug("Uncustomizing",viewClassName,actionClassName);
                }
                doUncustomize(view,action_);
                
                doEventUncustomize(view,action_);
                CONFIG::DEBUG {
                    _debug("Uncustomized",viewClassName,actionClassName);
                }
            }
            //
            const behaviors_:Array = viewProperties[NamingConvention.BEHAVIOR];

            if(behaviors_ != null) {
                var behaviorClassName:String;
                for each(var behavior_:Object in behaviors_) {
                    behaviorClassName = getCanonicalName(behavior_);
                    CONFIG::DEBUG {
                        _debug("Uncustomizing",viewClassName,behaviorClassName);
                    }
                    doUncustomize(view,behavior_);
                    
                    doEventUncustomize(view,behavior_);
                    CONFIG::DEBUG {
                        _debug("Uncustomized",viewClassName,behaviorClassName);
                    }
                }
            }
        }

        protected function doCustomize(container:UIComponent,action:Object,priority:int = int.MAX_VALUE):void {    
            const actionClassRef:ClassRef = getClassRef(action);
            //for children
            const props:Vector.<PropertyRef> = getClassRef(container).properties;
            
            var child:Object;
            for each(var prop:PropertyRef in props) {
                child = container[prop.name];

                if(child != null &&
                                child is IEventDispatcher &&
                                (child is IUIComponent || child is IMXMLObject || child is IEffect)) {
                    doCustomizeByComponent(
                                    container,
                                    prop.name,
                                    child as IEventDispatcher,
                                    action,
                                    actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                            return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                                        }
                                    ),
                                    priority
                                    );
                }
            }
            //for self
            doCustomizeByComponent(
                            container,
                            null,
                            null,
                            action,
                            actionClassRef.functions.filter(
                                function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                    return ((item as FunctionRef).name.indexOf(Yuis.namingConvention.getOwnHandlerPrefix()) == 0);
                                }
                            ),
                            priority
                            );
        }

        protected function doCustomizeByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,action:Object,functionRefs:Vector.<FunctionRef>,priority:int):void {
            if(componentName != null) {
                if(component == null) {
                    if(view.hasOwnProperty(componentName)) {
                        component = view[componentName] as IEventDispatcher;
                    } else {
                        component = view.getChildByName(componentName) as IEventDispatcher;
                    }
                }
            } else {
                componentName = Yuis.namingConvention.getOwnHandlerPrefix();
                component = view;
            }
            doCustomizingByComponent(view,componentName,component,action,functionRefs,priority);
        }

        protected function doUncustomize(container:UIComponent,action:Object):void {
            const actionClassRef:ClassRef = getClassRef(action);
            //for children
            const props:Vector.<PropertyRef> = getClassRef(container).properties;

            var child:Object;
            for each(var prop:PropertyRef in props) {
                child = container[prop.name];

                if(child != null &&
                        child is IEventDispatcher &&
                        (child is IUIComponent || child is IMXMLObject || child is IEffect)) {
                   doUncustomizeByComponent(
                                    container,
                                    prop.name,
                                    child as IEventDispatcher,
                                    action,
                                    actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                            return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                                        }
                                    )
                                    );
                }
            }
            //for self
            doUncustomizeByComponent(
                            container,
                            null,
                            null,
                            action,
                            actionClassRef.functions.filter(
                                function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                    return ((item as FunctionRef).name.indexOf(Yuis.namingConvention.getOwnHandlerPrefix()) == 0);
                                }
                            )
                            );
        }

        protected function doUncustomizeByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,action:Object,functionRefs:Vector.<FunctionRef>):void {
            if(componentName != null) {
                if(component == null) {
                    if(view.hasOwnProperty(componentName)) {
                        component = view[componentName] as IEventDispatcher;
                    } else {
                        component = view.getChildByName(componentName) as IEventDispatcher;
                    }
                }
            } else {
                componentName = Yuis.namingConvention.getOwnHandlerPrefix();
                component = view;
            }
            doUnCustomizingByComponent(view,componentName,component,action,functionRefs);
        }
        
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