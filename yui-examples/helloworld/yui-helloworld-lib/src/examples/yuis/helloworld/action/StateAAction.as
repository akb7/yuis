package examples.yuis.helloworld.action
{
    import flash.utils.setTimeout;
    
    import examples.yuis.helloworld.helper.StateAHelper;
    
    import yuis.core.ns.yuis_handler;

    /**
     * 
     */
    public class StateAAction {
        
        /**
         * 
         */
        public var helper:StateAHelper;

        /**
         * 
         */
        yuis_handler function on_viewInitialized():void{
            setTimeout(function():void{
                //something...
            },100);
        }
        
        /**
         * 
         */
        yuis_handler function showHelloWorld_click():void {
            helper.showMessage(helper.getInputValue());
        }
    }
}