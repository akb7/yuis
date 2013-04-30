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
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    import mx.core.UIComponent;
    import mx.core.UIComponentDescriptor;
    
    import yuis.Yuis;
    import yuis.core.event.MessageEvent;
    import yuis.core.event.NotificationEvent;
    import yuis.core.reflection.FunctionRef;
    import yuis.core.reflection.ParameterRef;
    import yuis.util.UIComponentUtil;
    
    [ExcludeClass]
    public class AbstractComponentEventCustomizer extends AbstractComponentCustomizer {
        
        private static const ENHANCED_SEPARETOR:String = "$";
        private static const ENHANCED_PREFIX:String = ENHANCED_SEPARETOR + "enhanced" + ENHANCED_SEPARETOR;
        private static const FUNCTION_OWNER:String = "$owner";
        private static const FUNCTION_PROTO:String = "$proto";

        protected function getEventName(functionRef:FunctionRef,componentName:String):String {
            return Yuis.namingConvention.getEventName(functionRef.name,functionRef.uri,componentName);
        }

        protected function getEnhancedEventName(viewName:String,eventName:String,listener:Object):String {
            var listenerClassName:String = getCanonicalName(listener);
            return viewName + ENHANCED_PREFIX + listenerClassName + ENHANCED_SEPARETOR + eventName;
        }

        protected function addEventListener(component:IEventDispatcher,eventName:String,handler:Function,priority:int):void {
            component.addEventListener(eventName,handler,false,priority,true);
        }

        protected function storeEnhancedEventHandler(component:UIComponent,enhancedEventName:String,handler:Function):void {
            var descriptor:UIComponentDescriptor = UIComponentUtil.getDescriptor(component);
            descriptor.events[enhancedEventName] = handler;
        }

        protected function removeEnhancedEventHandler(component:UIComponent,enhancedEventName:String):void {
            if(component.descriptor.events != null) {
                component.descriptor.events[enhancedEventName] = null;
                delete component.descriptor.events[enhancedEventName];
            }
        }

        protected function getEnhancedEventHandler(component:UIComponent,eventName:String):Function {
            var descriptor:UIComponentDescriptor = UIComponentUtil.getDescriptor(component);
            return descriptor.events[eventName];
        }

        protected function createEnhancedEventHandler(owner:IEventDispatcher,handler:Function):Function {
            const func_:Object = 
                function(event:Event):void {
                    var callee:Object = arguments.callee;
                    var proto:Function = callee[FUNCTION_PROTO] as Function;
                    if(proto != null) {
                        proto.apply(null,[event]);
                    } else {
                        throw new Error("EnhancedEventHandler doesn't have proto Handler");
                    }
                };
            func_[FUNCTION_PROTO] = handler;
            return func_ as Function;
        }

        protected function createEnhancedObjectHandler(owner:IEventDispatcher,handler:Function):Function {
            const func_:Object = 
                function(event:Event):void {
                    var callee:Object = arguments.callee;
                    var proto:Function = callee[FUNCTION_PROTO] as Function;
                    if(proto != null) {
                        if( event is MessageEvent ){
                            proto.apply(null,[(event as MessageEvent).data]);
                        } else if( event is NotificationEvent ){
                            proto.apply(null,[(event as NotificationEvent).data]);
                        } else {
                            proto.apply(null,[event]);
                        }
                    } else {
                        throw new Error("EnhancedEventHandler doesn't have proto Handler");
                    }
                };
            func_[FUNCTION_PROTO] = handler;
            return func_ as Function;
        }
        
        protected function createEnhancedEventNoneHandler(owner:IEventDispatcher,handler:Function):Function {
            const func_:Object =
                function(event:Event):void {
                    var callee:Object = arguments.callee;
                    var proto:Function = callee[FUNCTION_PROTO] as Function;
                    if(proto != null) {
                        proto.apply(null);
                    } else {
                        throw new Error("EnhancedEventHandler doesn't have proto Handler");
                    }
                };
            func_[FUNCTION_PROTO] = handler;
            return func_ as Function;
        }

        protected function doCustomizingByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,listener:Object,functionRefs:Vector.<FunctionRef>,priority:int):void {
            var eventName:String;
            var enhancedEventName:String;
            var enhancedFunction:Function;

            for each(var functionRef:FunctionRef in functionRefs) {
                eventName = getEventName(functionRef,componentName);
                enhancedEventName = getEnhancedEventName(componentName,eventName,listener);
                enhancedFunction = getEnhancedEventHandler(view,enhancedEventName);

                if(enhancedFunction != null) {
                    continue;
                }

                if(functionRef.parameters.length > 0) {
                    var param:ParameterRef = functionRef.parameters[0] as ParameterRef;
                    if( param.isEvent ){
                        enhancedFunction = createEnhancedEventHandler(view,functionRef.getFunction(listener));
                    } else {
                        enhancedFunction = createEnhancedObjectHandler(view,functionRef.getFunction(listener));
                    }
                } else {
                    enhancedFunction = createEnhancedEventNoneHandler(view,functionRef.getFunction(listener));
                }
                addEventListener(component,eventName,enhancedFunction,priority);
                storeEnhancedEventHandler(view,enhancedEventName,enhancedFunction);
                CONFIG::DEBUG {
                    _debug("Event_AddEventListener",getCanonicalName(view),componentName == Yuis.namingConvention.getOwnHandlerPrefix() ? view.name : componentName,eventName,getCanonicalName(listener),functionRef.name);
                }
            }
        }

        protected function doUnCustomizingByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,listener:Object,functionRefs:Vector.<FunctionRef>):void {
            var eventName:String;
            var enhancedEventName:String;
            var enhancedFunction:Function;

            for each(var functionRef:FunctionRef in functionRefs) {
                eventName = getEventName(functionRef,componentName);
                enhancedEventName = getEnhancedEventName(componentName,eventName,listener);
                enhancedFunction = getEnhancedEventHandler(view,enhancedEventName);

                if(enhancedFunction != null) {
                    component.removeEventListener(eventName,enhancedFunction);
                    removeEnhancedEventHandler(view,enhancedEventName);
                    CONFIG::DEBUG {
                        _debug("Event_RemoveEventListener",getCanonicalName(view),componentName == Yuis.namingConvention.getOwnHandlerPrefix() ? view.toString() : componentName,eventName,getCanonicalName(listener),functionRef.name);
                    }
                }
            }
        }
    }
}