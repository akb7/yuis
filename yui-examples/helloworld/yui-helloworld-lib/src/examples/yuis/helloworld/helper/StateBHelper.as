package examples.yuis.helloworld.helper
{
    import examples.yuis.helloworld.view.StateBView;
    
    public class StateBHelper
    {
        public var view:StateBView;
        
        public function showMessage( message:String ):void{
            view.textDisplay.text = message;
        }
        
        public function getInputValue():String
        {
            return view.inputDisplay.text;
        }
    }
}