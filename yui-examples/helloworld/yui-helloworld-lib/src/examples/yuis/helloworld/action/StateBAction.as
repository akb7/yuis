package examples.yuis.helloworld.action
{
    import flash.utils.setTimeout;
    
    import examples.yuis.helloworld.helper.StateBHelper;
    
    import yuis.core.ns.yuis_handler;

    /**
     * 
     */
    public class StateBAction {

        /**
         * 
         */
        public var helper:StateBHelper;

        /**
         * 
         */
        yuis_handler function on_viewInitialized():void{
            setTimeout(function():void{
                //something...
                trace("StateBAction.on_viewInitialized()");
            },100);
        }
        
        /**
         * 
         */
        yuis_handler function showPopup_click():void {
            helper.showPopup();
        }
        
        /**
         * 
         */
        yuis_handler function titleWindow_close():void {
            trace(1);
            helper.hidePopup();
        }
    }
}