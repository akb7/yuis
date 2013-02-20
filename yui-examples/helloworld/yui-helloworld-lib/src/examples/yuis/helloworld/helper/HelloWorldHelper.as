package examples.yuis.helloworld.helper
{
    import examples.yuis.helloworld.view.HelloWorldView;
    
    public class HelloWorldHelper
    {
        public var view:HelloWorldView;
        
        public function changeStateA():void{
            view.currentState = "stateA";
        }
        public function changeStateB():void{
            view.currentState = "stateB";
        }
    }
}