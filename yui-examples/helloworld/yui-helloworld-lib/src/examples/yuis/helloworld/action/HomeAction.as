package examples.yuis.helloworld.action
{
    import flash.utils.setTimeout;
    
    import examples.yuis.helloworld.helper.HomeHelper;
    
    import yuis.core.ns.yuis_handler;

    /**
     * 
     */
    public class HomeAction {

        /**
         * 
         */
        public var helper:HomeHelper;
        
        /**
         * 
         */
        yuis_handler function stateAButton_click():void {
            helper.changeStateA();
        }
        
        /**
         * 
         */
        yuis_handler function stateBButton_click():void {
            helper.changeStateB();
        }

        /**
         * 
         */
        yuis_handler function on_stateChangeComplete():void{
            setTimeout(function():void{
                //something...
            },100);
        }
    }
}