package examples.yuis.helloworld.helper
{
    import examples.yuis.helloworld.view.StateBView;
    
    /**
     * 
     */
    public class StateBHelper
    {
        /**
         * 
         */
        public var view:StateBView;
        
        /**
         * 
         */
        public function showPopup():void{
            view.popUp.displayPopUp = true;
        }
        /**
         * 
         */
        public function hidePopup():void{
            view.popUp.displayPopUp = false;
        }
    }
}