package examples.yuis.helloworld.action
{
    import examples.yuis.helloworld.helper.HelloWorldHelper;
    
    import yuis.core.ns.yui_internal;
    
    public class HelloWorldAction {
        
        public var helloWorldHelper:HelloWorldHelper;
        
        public function showHelloWorld_clickHandler():void{
            helloWorldHelper.showMessage(helloWorldHelper.getInputValue());
        }
    }
}