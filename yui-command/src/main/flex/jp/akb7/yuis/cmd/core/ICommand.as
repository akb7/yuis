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
package jp.akb7.yuis.cmd.core
{
    /**
     * コマンド定義インターフェイス
     *  
     * 
     */
    public interface ICommand {

        /**
         * コマンドの結果があるか
         * 
         */
        function get hasResult():Boolean;
        
        /**
         * コマンドの結果
         * 
         */
        function get result():Object;
        
        /**
         * コマンドのエラーステータスがあるか
         * 
         */
        function get hasStatus():Boolean;
        
        /**
         * コマンドのエラーステータス
         * 
         */
        function get status():Object;
        
        /**
         * コマンドの名前を指定
         * 
         * @param value 名前
         * 
         */
        function get name():String;
        function set name(value:String):void;
        
        /**
         * コマンドの引数を指定
         * 
         * @param value 名前
         * 
         */
        function get argument():Object;
        
        /**
         * コマンドを開始する
         * 
         * @param args コマンド引数
         * 
         */
        function start(data:Object=null):ICommand;

        /**
         * コマンドを初期化する
         * 
         */
        function clear():void;
        
        /**
         * コマンド完了イベントリスナーを設定する
         * 
         * @param handler コマンド完了イベントハンドラ
         * @return コマンド
         * 
         */
        function completeCallBack(handler:Function):ICommand;

        /**
         * コマンドエラーイベントリスナーを設定する
         * 
         * @param handler コマンドエラーイベントハンドラ
         * @return コマンド
         * 
         */
        function errorCallBack(handler:Function):ICommand;

        /**
         * コマンドイベントリスナーを設定する
         * 
         * @param listener コマンドイベントリスナー
         * @return コマンド
         * 
         */
        function listener(listenerObj:Object):ICommand;

    }
}