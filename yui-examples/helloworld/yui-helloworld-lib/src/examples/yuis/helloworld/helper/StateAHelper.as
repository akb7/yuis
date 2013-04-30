package examples.yuis.helloworld.helper
{
    import examples.yuis.helloworld.view.StateAView;
    
    /**
     * 
     */
    public class StateAHelper
    {
        /**
         * 
         */
        public var view:StateAView;
        
        /**
         * 
         */
        public function showMessage( message:String ):void{
            view.textDisplay.text = message;
        }
        
        /**
         * 
         */
        public function getInputValue():String
        {
            return view.inputDisplay.text;
        }
    }
}