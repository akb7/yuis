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
package yuis.ds {
    import mx.core.mx_internal;
    import mx.messaging.messages.IMessage;
    import mx.rpc.AbstractOperation;
    import mx.rpc.AsyncToken;
    import mx.rpc.IResponder;
    import mx.rpc.Responder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import yuis.core.ns.yuis_internal;
    import yuis.core.reflection.ClassRef;
    import yuis.core.reflection.FunctionRef;
    import yuis.core.reflection.ParameterRef;
    import yuis.ds.responder.RpcDefaultEventResponder;
    import yuis.ds.responder.RpcEventResponder;
    import yuis.ds.responder.RpcNoneResponder;
    import yuis.ds.responder.RpcObjectResponder;
    import yuis.ds.responder.RpcResponderFactory;
    import yuis.service.IManagedService;
    import yuis.service.IPendingCall;
    import yuis.service.IService;
    import yuis.service.OperationCallBack;
    import yuis.service.responder.IServiceResponder;
    import yuis.service.responder.ServiceResponderFactory;

    use namespace mx_internal;

    [ExcludeClass]
    public class DsPendingCall extends AsyncToken implements IPendingCall {

        yuis_internal static var RpcObjectResponderClass:Class = RpcObjectResponder;
        yuis_internal static var RpcEventResponderClass:Class = RpcDefaultEventResponder;
        yuis_internal static var RpcNoneResponderClass:Class = RpcNoneResponder;
        
        private static const RESULT_HANDLER:String = "ResultHandler";

        private static const FAULT_HANDLER:String = "FaultHandler";

        private static const RESPONDER_FACTORY:ServiceResponderFactory = new RpcResponderFactory();
        
        private static function createResponder( destination:String,operationName:String, responder:Object ):IResponder{
            const classRef:ClassRef = getClassRef(responder);
            const resultFuncDef:FunctionRef = RESPONDER_FACTORY.findResultFunctionRef( classRef, destination, operationName );
            const faultFuncDef:FunctionRef = RESPONDER_FACTORY.findFaultFunctionRef( classRef, destination, operationName );

            var result:IResponder = null;
            var responderClass:Class;
            if( resultFuncDef.parameters.length <= 0 ){
                responderClass = yuis_internal::RpcNoneResponderClass;
            } else {
                responderClass = yuis_internal::RpcObjectResponderClass;
            }
            if( faultFuncDef == null){
                result = new responderClass(resultFuncDef.getFunction(responder),null);
            } else {
                result = new responderClass(resultFuncDef.getFunction(responder),faultFuncDef.getFunction(responder));
            }
            return result;
        }

        protected var _internalAsyncToken:AsyncToken;

        protected var _responder:IResponder;

        protected var _responderOwner:Object;

        protected var _operation:AbstractOperation;

        public function DsPendingCall(message:IMessage=null)
        {
            super(message);
        }

        public function clear():void{
            _responder = null;
        }

        public function setResponder( responder:Object ):void{
            if( responder is IResponder ){
                _responderOwner = null;
                _responder = responder as IResponder;
            } else if( responder is IServiceResponder ){
                _responderOwner = null;
                _responder = new RpcEventResponder(responder.onResult,responder.onFault);
            } else {
                _responderOwner = responder;
                var service:IService = _operation.service as IService;
                _responder = createResponder( service.name, _operation.name, responder );
            }
        }

        public function getResponder():Object{
            if( _responderOwner == null ){
                return _responder;
            } else {
                return _responderOwner;
            }
        }

        public function get service():IService{
            return _operation.service as IService;
        }

        public function onResult( resultEvent:ResultEvent ):void{
            if( service is IManagedService ){
                ( service as IManagedService ).finalizePendingCall(this);
            }

            if( OperationCallBack.resultCallBack != null ){
                OperationCallBack.resultCallBack.apply(null,[resultEvent]);
            }

            if( _responder != null ){
                _responder.result( resultEvent );
            }

            _responder = null;
            _responderOwner = null;
            _operation = null;
            _internalAsyncToken = null;
        }

        public function onStatus( faultEvent:FaultEvent ):void{
            if( service is IManagedService ){
                ( service as IManagedService ).finalizePendingCall(this);
            }
            
            if( OperationCallBack.faultCallBack != null ){
                OperationCallBack.faultCallBack.apply(null,[faultEvent]);
            }

            if( _responder != null ){
                _responder.fault( faultEvent );
            }

            _responder = null;
            _responderOwner = null;
            _operation = null;
            _internalAsyncToken = null;
        }
        
        yuis_internal function setInternalAsyncToken( asyncToken:AsyncToken, operation:AbstractOperation ):void{
            _internalAsyncToken = asyncToken;
            _internalAsyncToken.addResponder( new mx.rpc.Responder(onResult,onStatus));
            _operation = operation;
        }
        
        mx_internal override function setResult(newResult:Object):void
        {
        }

    }
}