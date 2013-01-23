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
package yuis.cmd.core.impl
{
    import flash.utils.Dictionary;
    
    import yuis.cmd.core.ICommand;
    import yuis.cmd.core.IComplexCommand;
    import yuis.cmd.core.ISubCommand;
    import yuis.cmd.events.CommandEvent;
    import yuis.core.reflection.FunctionInvoker;
    
    [ExcludeClass]
    /**
     * 
     * 
     */
    public class AbstractComplexCommand extends AbstractAsyncCommand implements IComplexCommand {
        /**
         * 
         */
        protected var _commands:Array;
        
        /**
         * 
         */
        protected var _commandMap:Dictionary;
        
        /**
         * 
         */
        protected var _childCompleteEventListener:EventListener;
        
        /**
         * 
         */
        protected var _childErrorEventListener:EventListener;
        
        /**
         * 
         */
        protected var _lastCommand:ICommand;
        
        /**
         * 
         */
        public final function get lastCommand():ICommand{
            return _lastCommand;
        }
        
        /**
         * 
         */
        public final function AbstractComplexCommand(){
            super();
            _commands = [];
            _commandMap = new Dictionary();
            _childCompleteEventListener = new EventListener();
            _childErrorEventListener = new EventListener();
        }
        
        /**
         * 
         * @param handler
         * @return 
         * 
         */
        public final function childComplete(handler:Function):IComplexCommand{
            this._childCompleteEventListener.handler = handler;
            return this;
        }
        
        /**
         * 
         * @param handler
         * @return 
         * 
         */
        public final function childError(handler:Function):IComplexCommand{
            this._childErrorEventListener.handler = handler;
            return this;
        }
        
        /**
         * 
         * @param command
         * @return 
         * 
         */
        public final function add(command:ICommand,name:String=null):IComplexCommand{
            if( command is AbstractCommand ){
                doAddCommand(command as AbstractCommand);
            }
            if( name != null ){
                _commandMap[name] = command;
            }
            doRegisterCommand(command);
            return this;
        }

        /**
         * 
         * @param name
         * @return 
         * 
         */
        public final function commandByName(name:String):ICommand{
            var result:ICommand = _commandMap[name];
            return result;
        }

        /**
         * 
         * @param index
         * 
         */
        protected final function doStartCommandAt(index:int,args:Array):ICommand{
            var command:ICommand = _commands[ index ];
            new FunctionInvoker(command.start as Function,args).invokeDelay();
            return command;
        }         
                
        /**
         * 
         * @param event
         * 
         */
        protected function childCmd_completeHandler(event:CommandEvent):void{
        }

        /**
         * 
         * @param event
         * 
         */
        protected function childCmd_errorHandler(event:CommandEvent):void{
        }
        
        /**
         * 
         * @param command
         * 
         */
        protected final function doAddCommand(command:AbstractCommand):void{
            command
                .completeCallBack(childCmd_completeHandler)
                .errorCallBack(childCmd_errorHandler);
        }
        
        /**
         * 
         * @param command
         * 
         */
        protected final function doRegisterCommand(command:ICommand):void{
            _commands.push(command);
            if( command is ISubCommand ){
                (command as ISubCommand).parent = this;
            }
        }
        
    }
}