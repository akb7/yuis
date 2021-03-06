/*
 * Copyright 2004-2011 the Seasar Foundation and the Others.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */
package yuis.ds.responder {

    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;

    [ExcludeClass]
    public final class RpcDefaultEventResponder extends AbstractRpcEventResponder {

        public function RpcDefaultEventResponder( resultFunction:Function, faultFunction:Function){
            this.resultFunction = resultFunction;
            this.faultFunction = faultFunction;
        }

        public override function result(data:Object):void
        {
            resultFunction.call( null, data as ResultEvent );
            resultFunction = null;
            faultFunction = null;
        }

        public override function fault(info:Object):void
        {
            if( faultFunction != null ){
                faultFunction.call( null, info as FaultEvent);
            }
            resultFunction = null;
            faultFunction = null;
        }
    }
}