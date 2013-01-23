package examples.yuis.helloworld.action
{
    import examples.yuis.helloworld.helper.HelloWorldHelper;
    
    import yuis.core.ns.yuis_handler;
    
    public class HelloWorldAction {
        
        public var helper:HelloWorldHelper;
        
        /**
         * 
         */
        yuis_handler function showHelloWorld_click():void {
            helper.showMessage(helper.getInputValue());
        }
    }
}