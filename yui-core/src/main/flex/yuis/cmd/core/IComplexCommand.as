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
package yuis.cmd.core
{
    /**
     * 複合コマンド定義インターフェイス
     * 
     */
    public interface IComplexCommand extends ICommand
    {
        
        /**
         * 前回実行したコマンドを取得する
         * 
         */
        function get lastCommand():ICommand;

        /**
         * コマンドを追加する
         * 
         * @param command コマンド
         * @param name コマンド名
         * @return 複合コマンド
         * 
         */
        function add( command:ICommand, name:String=null ):IComplexCommand;
        
        /**
         * 名前よりコマンドを取得する
         * 
         * @param name コマンド名
         * @return 複合コマンド
         * 
         */
        function commandByName( name:String ):ICommand;
        
        /**
         * 子コマンドのイベント完了リスナーを設定する
         * 
         * @param handler イベント完了ハンドラ
         * @return 複合コマンド
         * 
         */
        function childComplete( handler:Function ):IComplexCommand;

        /**
         * 子コマンドのイベントエラーリスナーを設定する
         * 
         * @param handler イベントエラーハンドラ
         * @return 複合コマンド
         * 
         */
        function childError( handler:Function ):IComplexCommand;        
    }
}