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
    
    import flash.display.DisplayObjectContainer;
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;
    
    import mx.core.UIComponent;
    
    import jp.akb7.yuis.core.YuiFrameworkController;
    import jp.akb7.yuis.core.ns.yui_internal;
    import jp.akb7.yuis.core.reflection.ClassRef;
    import jp.akb7.yuis.core.reflection.PropertyRef;
    import jp.akb7.yuis.logging.debug;
    import jp.akb7.yuis.message.MessageManager;
    
    [ExcludeClass]
    public class AbstractComponentCustomizer implements IViewCustomizer {

        protected function setPropertiesValue(target:Object,varClassName:String,value:Object):void {
            const targetClassRef:ClassRef = getClassRef(target);
            const propertyRefs:Vector.<PropertyRef> = targetClassRef.getPropertyRefByType(varClassName);
            
            if(propertyRefs != null) {
                for each(var propertyRef:PropertyRef in propertyRefs) {
                    propertyRef.setValue(target,value);
                }
            }
        }

        public function customizeView( view:UIComponent ):void{
            throw new IllegalOperationError("can't call");
        }

        public function uncustomizeView( view:UIComponent ):void{
            throw new IllegalOperationError("can't call");
        }
        
        CONFIG::DEBUG {
            protected function _debug(resourceName:String,...parameters):void{
                debug( this, MessageManager.yui_internal::yuiframework.getMessage.apply(null,[resourceName].concat(parameters)));
            }
        }
    }
}