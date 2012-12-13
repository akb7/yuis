package examples.yuis.helloworld.action
{
    import examples.yuis.helloworld.helper.HelloWorldHelper;
    
    public class HelloWorldAction {
        
        public var helloWorldHelper:HelloWorldHelper;

        public function showHelloWorld_clickHandler():void{
            helloWorldHelper.showMessage(helloWorldHelper.getInputValue());
        }
    }
}