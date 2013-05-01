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
package yuis.service.responder
{
    import yuis.core.error.NotFoundError;
    import yuis.core.reflection.ClassRef;
    import yuis.core.reflection.FunctionRef;
    import yuis.service.IOperation;
    import yuis.ns.yuis_fault;
    import yuis.ns.yuis_result;
    import yuis.util.StringUtil;

    [ExcludeClass]
    public class ServiceResponderFactory {
        
        private static const EVENT_SEPARETOR:String = "_";

        private static const RESULT_HANDLER:String = "ResultHandler";

        private static const FAULT_HANDLER:String = "FaultHandler";

        protected var eventResoponderClassRef:ClassRef;

        protected var objectResponderClassRef:ClassRef;

        protected var noneResponderClassRef:ClassRef;

        public function ServiceResponderFactory(){

        }

        public function createResponder( operation:IOperation, responder:Object ):IServiceResponder{
            const classRef:ClassRef = getClassRef(responder);
            const resultFuncDef:FunctionRef = findResultFunctionRef( classRef, operation.serviceName, operation.name );
            const faultFuncDef:FunctionRef = findFaultFunctionRef( classRef, operation.serviceName, operation.name  );

            var rpcResponder:IServiceResponder = null;
            var responderClassRef:ClassRef;
            if( resultFuncDef.parameters.length <= 0 ){
                responderClassRef = noneResponderClassRef;
            } else {
                responderClassRef = objectResponderClassRef;
            }
            if( faultFuncDef == null){
                rpcResponder = responderClassRef.newInstance(resultFuncDef.getFunction(responder),null,true) as IServiceResponder;
            } else {
                rpcResponder = responderClassRef.newInstance(resultFuncDef.getFunction(responder),faultFuncDef.getFunction(responder),true) as IServiceResponder;
            }
            return rpcResponder as IServiceResponder;
        }

        public function findResultFunctionRef( classRef:ClassRef, serviceName:String, serviceMethodName:String ):FunctionRef{
            var serviceMethod:String = StringUtil.toLowerCamel( serviceName ) + StringUtil.toUpperCamel( serviceMethodName );
            var serviceResultMethod:String = serviceMethod + RESULT_HANDLER;
            var functionRef:FunctionRef = classRef.getFunctionRef( serviceResultMethod );
            do{
                var ns:Namespace = yuis.ns.yuis_result;
                if( functionRef == null ){
                    serviceMethod = StringUtil.toLowerCamel( serviceName ) + EVENT_SEPARETOR + serviceMethodName;
                    functionRef = classRef.getFunctionRef(serviceMethod,ns);
                    break;
                }
                if( functionRef == null ){
                    functionRef = classRef.getFunctionRef(serviceMethod,ns);
                    break;
                }
            }while(false);
            if( functionRef == null ){
                throw new NotFoundError( classRef.name, "\"public function " + serviceMethod + RESULT_HANDLER + "\" or \"yuis_result function " + serviceMethod + "\"");
            }
            return functionRef;
        }

        public function findFaultFunctionRef( classRef:ClassRef, serviceName:String, serviceMethodName:String ):FunctionRef{
            var serviceMethod:String = StringUtil.toLowerCamel( serviceName ) + StringUtil.toUpperCamel( serviceMethodName );
            var serviceFaultMethod:String = serviceMethod + FAULT_HANDLER;
            var functionRef:FunctionRef = classRef.getFunctionRef( serviceFaultMethod );

            do{
                var ns:Namespace = yuis.ns.yuis_fault;
                if( functionRef == null ){
                    serviceMethod = StringUtil.toLowerCamel( serviceName ) + EVENT_SEPARETOR + serviceMethodName;
                    functionRef = classRef.getFunctionRef(serviceMethod,ns);
                    break;
                }
                if( functionRef == null ){
                    functionRef = classRef.getFunctionRef(serviceMethod,ns);
                    break;
                }
            }while(false);

            return functionRef;
        }
    }
}