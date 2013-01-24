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
package yuis.core.reflection
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    [ExcludeClass]
    public final class FunctionInvoker {
        
        private var _func:Function;
        
        private var _args:Array;
        
        private var _timer:Timer;
        
        private var _frameCount:int;
        
        private var _invokeFrame:int;
        
        public function get isStarted():Boolean{
            return (_timer != null && _timer.running);
        }
        
        public function FunctionInvoker(func:Function, args:Array=null){
            super();
            _func = func;
            _args = args;
        }
        
        public function invokeDelay(delay:Number=10):FunctionInvoker{
            _timer = new Timer(delay);
            _timer.addEventListener(TimerEvent.TIMER, delayTimer_timerEventHandler);
            _timer.start();
            
            return this;
        }
        
        public function invokeLater(base:DisplayObject,invokeFrame:int=1):FunctionInvoker{
            if( base == null ){
                clear();
            } else {
                _frameCount = 0;
                _invokeFrame = invokeFrame;
                base.addEventListener(Event.ENTER_FRAME,displayObject_enterFrameHandler);
            }
            return this;
        }
        
        private function displayObject_enterFrameHandler(event:Event):void{
            _frameCount++;
            if( _frameCount > 0 && _frameCount >= _invokeFrame ){
                var base:DisplayObject = event.target as DisplayObject;
                base.removeEventListener(Event.ENTER_FRAME,displayObject_enterFrameHandler);
                doInvoke();
            }
        }
        
        private function delayTimer_timerEventHandler(event:TimerEvent):void{
            _timer.stop();
            _timer.removeEventListener(TimerEvent.TIMER, delayTimer_timerEventHandler);
            _timer = null;
            
            doInvoke();
        }
        
        private function doInvoke():void{
            const func:Function = _func;
            try{
                var args:Array = _args;
                if( args != null && args.length > 0 ){
                    func.apply(null, args);
                } else {
                    func.apply(null);
                }
            } catch( e:Error ){
                throw e;
            } finally {
                clear();
            }
        }
        
        private function clear():void{
            _frameCount = 0;
            _invokeFrame = 0;
            _func = null;
            _args = null;
        }
    }
}