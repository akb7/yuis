package examples.yuis.helloworld.action
{
    import flash.utils.setTimeout;
    
    import examples.yuis.helloworld.helper.StateBHelper;
    
    import yuis.core.ns.yuis_handler;
    
    public class StateBAction {
        
        public var helper:StateBHelper;
        
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