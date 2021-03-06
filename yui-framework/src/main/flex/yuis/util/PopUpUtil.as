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
package yuis.util
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.EventPhase;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    
    import mx.core.IDataRenderer;
    import mx.core.IFlexDisplayObject;
    import mx.core.IUIComponent;
    import mx.core.UIComponent;
    import mx.core.UIComponentDescriptor;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import yuis.Yuis;
    import yuis.framework.YuiFrameworkController;
    
    import yuis.core.ns.yuis_internal;
    import yuis.util.StringUtil;
    
    [ExcludeClass]
    [Deprecated(message="The PopUpUtil is deprecated. Use spark.components.PopUpAnchor or similar component instead.",replacement="Use spark.components.PopUpAnchor instead",since="1.1")]    
    public final class PopUpUtil {
        
        public static const POPUP_INFO:String = "__popUp_info";

        public static const POPUP_OWNER:String = "popUpOwner";

        public static const RELATED_OWNER:String = "relatedOwner";

        public static const CALLBACK:String = "callback";

        public static function openPopUpView( popupClass:Class,
                                              data:Object,
                                              relatedOwner:UIComponent
                                             ):IFlexDisplayObject{
            var popupClassName:String = getClassRef(popupClass).className;
            var viewName:String = StringUtil.toLowerCamel(popupClassName);
            var window:UIComponent =
                createPopUpView(
                    viewName,
                    popupClass,
                    true,
                    true,
                    relatedOwner,
                    data
                    ) as UIComponent;
            return window;
        }

        public static function createPopUpView( viewName:String,
                                                popupClass:Class,
                                                modal:Boolean = false,
                                                center:Boolean = false,
                                                relatedOwner:UIComponent=null,
                                                data:Object=null
                                               ):IFlexDisplayObject{
            var parent:UIComponent = null;
            if( relatedOwner == null ){
                parent = Yuis.frameworkBridge.application as UIComponent;
            } else {
                parent = relatedOwner.parentApplication as UIComponent;
            }
            var window:UIComponent =
                createPopUp(
                    viewName,
                    parent,
                    popupClass,
                    modal,
                    center,
                    null,
                    relatedOwner,
                    data
                    ) as UIComponent;
            return window;
        }

        public static function removePopUpView(popUp:IFlexDisplayObject):void{
            if( popUp is UIComponent ){
                var popUpUIComponent:UIComponent = popUp as UIComponent;
                YuiFrameworkController
                    .getInstance()
                    .uncustomizeComponent(
                        lookupRelatedOwner(popUpUIComponent),
                        popUpUIComponent
                    );
                removePopUp(popUp);
            }
        }

        public static function lookupPopupOwner( popUp:UIComponent ):UIComponent{
            var result:UIComponent = null;
            var properties_:Object = UIComponentUtil.getProperties(UIComponent(popUp));
            if( properties_.hasOwnProperty(POPUP_INFO)){
                result = properties_[POPUP_INFO][POPUP_OWNER];
            }

            return result;
        }

        public static function lookupRelatedOwner( popUp:UIComponent ):UIComponent{
            var result:UIComponent = null;
            var properties_:Object = UIComponentUtil.getProperties(UIComponent(popUp));
            if( properties_.hasOwnProperty(POPUP_INFO)){
                result = properties_[POPUP_INFO][RELATED_OWNER];
            }

            return result;
        }

        private static function createPopUp(name:String,
                                            parent:DisplayObject,
                                            className:Class,
                                            modal:Boolean = false,
                                            center:Boolean = false,
                                            childList:String = null,
                                            relatedOwner:UIComponent=null,
                                            data:Object=null
                                            ):IFlexDisplayObject{

            var window:IUIComponent = new className();
            window.name = name;
            window.setVisible(false,true);
            window.addEventListener(
                FlexEvent.INITIALIZE,
                function(event:FlexEvent):void{
                    if( event.eventPhase == EventPhase.AT_TARGET ){
                        (event.target as IEventDispatcher).removeEventListener(FlexEvent.INITIALIZE,arguments.callee);
                        var descriptor:UIComponentDescriptor = UIComponentUtil.getDescriptor(event.target as UIComponent);

                        var popUpinfo_:Dictionary = new Dictionary(true);
                        popUpinfo_[POPUP_OWNER] = parent;
                        popUpinfo_[RELATED_OWNER] = relatedOwner;
                        popUpinfo_[CALLBACK] = creationCompleteCallBack;

                        descriptor.properties[POPUP_INFO] = popUpinfo_;
                     }
                },
                false,
                int.MAX_VALUE,
                true
            );

            PopUpManager.addPopUp(
                window,
                parent,
                modal,
                childList
                );

            if( center ){
                window.addEventListener(
                    FlexEvent.CREATION_COMPLETE,
                    onPopupCreationForMoveCenterCompleteHandler,
                    false,
                    int.MAX_VALUE,
                    true
                );
            }
            if( window is UIComponent ){
                ( window as UIComponent)
                    .addEventListener(
                            FlexEvent.CREATION_COMPLETE,
                            popup_creationCompleteHandler,
                            false,
                            0,
                            true
                        );
                if( window is IDataRenderer){
                    ( window as IDataRenderer).data = data;
                }
            }

            return window;
        }

        private static function removePopUp(popUp:IFlexDisplayObject):void{
            if( popUp is UIComponent){
                var properties_:Object = UIComponentUtil.getProperties(UIComponent(popUp));
                if( properties_ != null ){
                    if( properties_.hasOwnProperty(POPUP_INFO)){
                        properties_[POPUP_INFO][POPUP_OWNER] = null;
                        delete properties_[POPUP_INFO][POPUP_OWNER];

                        properties_[POPUP_INFO][RELATED_OWNER] = null;
                        delete properties_[POPUP_INFO][RELATED_OWNER];

                        properties_[POPUP_INFO] = null;
                        delete properties_[POPUP_INFO];
                    }
                }
            }
            PopUpManager.removePopUp(popUp);
        }

        private static function popup_creationCompleteHandler(event:FlexEvent):void{
            if( event.eventPhase == EventPhase.AT_TARGET ){
                IEventDispatcher(event.target).removeEventListener(FlexEvent.CREATION_COMPLETE,arguments.callee);
                lookupCallBack(event.target as UIComponent).apply(null,[event]);
             }
        }

        private static function lookupCallBack( popUp:UIComponent ):Function{
            var result:Function = null;
            var properties_:Object = UIComponentUtil.getProperties(UIComponent(popUp));
            if( properties_.hasOwnProperty(POPUP_INFO)){
                result = properties_[POPUP_INFO][CALLBACK];
            }
            delete properties_[POPUP_INFO][CALLBACK];

            return result;
        }

        private static function onPopupCreationForMoveCenterCompleteHandler(event:Event):void{
            var window:UIComponent = event.target as UIComponent;

            window.removeEventListener(
                FlexEvent.CREATION_COMPLETE,
                onPopupCreationForMoveCenterCompleteHandler,
                false
            );
            PopUpManager.centerPopUp(window);
        }

        private static function creationCompleteCallBack(event:FlexEvent):void{
            var popup:UIComponent = event.target as UIComponent;
            YuiFrameworkController
                .getInstance()
                .customizeComponent(
                    lookupRelatedOwner(popup),
                    popup as UIComponent
                    );
            popup.setVisible(true,false);
        }
    }
}