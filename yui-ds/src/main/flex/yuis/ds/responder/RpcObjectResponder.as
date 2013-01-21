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
    
    import mx.rpc.Fault;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import yuis.service.event.FaultStatus;
    
    [ExcludeClass]
    public final class RpcObjectResponder extends AbstractRpcEventResponder {
        
        private static function toFaultStatus(faultEvent:FaultEvent):FaultStatus{
            const fault:Fault = faultEvent.fault;
            var result:FaultStatus = new FaultStatus(fault.faultCode,fault.faultDetail,fault.faultString);
            return result;
        }
        
        public function RpcObjectResponder( resultFunction:Function, faultFunction:Function){
            this.resultFunction = resultFunction;
            this.faultFunction = faultFunction;
        }
        
        public override function result(data:Object):void {
            var resultEvent:ResultEvent = data as ResultEvent;
            if( resultEvent == null ){
                resultFunction.call( null, data);
            } else {
                resultFunction.call( null, (data as ResultEvent).result );
            }
            resultFunction = null;
            faultFunction = null;
        }
        
        public override function fault(info:Object):void {
            if( faultFunction != null ){
                var faultEvent:FaultEvent = info as FaultEvent;
                if( faultEvent == null ){
                    faultFunction.call( null, info );
                } else {
                    faultFunction.call( null, toFaultStatus(faultEvent) );
                }
            }
            resultFunction = null;
            faultFunction = null;
        }
        
    }
}