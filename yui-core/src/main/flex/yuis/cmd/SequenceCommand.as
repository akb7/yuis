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
package yuis.cmd
{
    import yuis.cmd.core.impl.AbstractComplexCommand;
    import yuis.cmd.events.CommandEvent;

    public class SequenceCommand extends AbstractComplexCommand {

        protected var _currentCommandIndex:int;
        
        protected final override function runAsync():void{
            _currentCommandIndex = 0;
            if( _commands.length > 0 ){
                doStartCommands();
            } else {
                doneAsync();
            }
        }
        
        protected final override function childCmd_completeHandler(event:CommandEvent):void{
            _lastCommand = event.command;
            if( _childCompleteEventListener.handler != null ){
                _childCompleteEventListener.handler(event);
            }
            if( _lastCommand.hasResult ){
                pendingResult = _lastCommand.result;
            }
            _currentCommandIndex++;
            if( _currentCommandIndex < _commands.length ){
                var args:Array = [];
                
                if( _lastCommand == null ){
                    args = [argument];
                } else {
                    if( hasPendingResult ){
                        args = [pendingResult];
                    } else {
                        args = [argument];
                    }
                }
                
                doStartCommandAt(_currentCommandIndex,args);
            } else {
                doneAsync();
            }
        }

        protected final override function childCmd_errorHandler(event:CommandEvent):void{
            _lastCommand = event.command;
            if( _childErrorEventListener.handler != null ){
                _childErrorEventListener.handler(event);
            }
            errorAsync(event.data);
        }
        
        protected final function doStartCommands():void{
            _currentCommandIndex = 0;
            doStartCommandAt(_currentCommandIndex,[argument]);
        }
    }
}