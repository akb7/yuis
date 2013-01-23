package examples.yuis.helloworld.helper
{
    import examples.yuis.helloworld.view.HelloWorldView;
    
    public class HelloWorldHelper
    {
        public var view:HelloWorldView;
        
        public function showMessage( message:String ):void{
            view.textDisplay.text = message;
        }
        
        public function getInputValue():String
        {
            return view.inputDisplay.text;
        }
    }
}