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
package yuis
{
    import flash.system.Capabilities;
    
    import mx.core.ClassFactory;
    import mx.core.IFactory;
    import mx.resources.ResourceManager;
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.IStyleManager2;
    
    import __AS3__.vec.Vector;
    
    import yuis.bridge.FrameworkBridge;
    import yuis.convention.NamingConvention;
    import yuis.core.ns.yuis_internal;
    import yuis.framework.YuiFrameworkSettings;
    import yuis.util.StyleManagerUtil;
    
    use namespace yuis_internal;

    [ExcludeClass]
    public final class Yuis
    {
        private static var _frameworkBridge:FrameworkBridge;

        public static function get frameworkBridge():FrameworkBridge{
            return _frameworkBridge;
        }

        private static var _namingConvention:NamingConvention;

        public static function get namingConvention():NamingConvention{
            return _namingConvention;
        }
        
        private static var _settings:YuiFrameworkSettings;
        
        public static function get settings():YuiFrameworkSettings{
            return _settings;
        }
        
        private static var _namingConventionClassFactory:IFactory;
        
        yuis_internal static function setFrameworkBridge(value:FrameworkBridge):void{
            _frameworkBridge = value;
        }
        
        yuis_internal static function setNamingConvention( value:NamingConvention ):void{
            _namingConvention = value;
        }
        
        yuis_internal static function setSettings(value:YuiFrameworkSettings):void{
            _settings = value;
        }
        
        yuis_internal static function initNamingConventionClassFactory():void{
            var styleManager:IStyleManager2 = StyleManagerUtil.getStyleManager();
            var namingConventionClassFactoryDef:CSSStyleDeclaration = styleManager.getStyleDeclaration("yuis.framework.core.YuiFrameworkSettings");
            if( namingConventionClassFactoryDef == null ){
                _namingConventionClassFactory = new ClassFactory(NamingConvention);
            } else {
                var classFactory:Class = namingConventionClassFactoryDef.getStyle("namingConventionClass") as Class;
                _namingConventionClassFactory = new ClassFactory(classFactory);
            }
        }

        yuis_internal static function initNamingConvention():void{
            initNamingConventionClassFactory();

            var namingConvention:NamingConvention = _namingConventionClassFactory.newInstance() as NamingConvention;
            namingConvention.conventions = Vector.<String>(ResourceManager.getInstance().getStringArray("conventions","package"));

            Yuis.yuis_internal::setNamingConvention( namingConvention );
        }
		
		//
		private static const DEBUG:Boolean = CONFIG::DEBUG;
		public static const REVISION:String = function():String{
			var rev:String = "$Revision: 1734 $"; return rev.substring(11,rev.length-2);
			
			trace("yui-frameworks-"+VERSION);
			trace("Copyright 2012 AKABANA.  All Rights Reserved.");
			
			if( DEBUG ){
				if( Capabilities.isDebugger ){
					trace("using Flash Debug Player " + Capabilities.version);
				} else {
					trace("using Flash Player " + Capabilities.version);
				}
			}
		}();
		public static const VERSION:String = "1.0.0."+REVISION+"-beta2-snapshot" + (DEBUG?"-debug":"");
    }
}