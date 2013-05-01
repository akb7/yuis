package examples.yuis.helloworld.action
{
    import flash.events.MouseEvent;
    
    import examples.yuis.helloworld.helper.HomeHelper;
    
    import yuis.core.ns.yuis_handler;
    import yuis.ds.HttpService;

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
        public var twitter:HttpService;
        
        public function HomeAction()
        {
        }
        
        /**
         * 
         */
        yuis_handler function twitter_click(event:MouseEvent):void{
        }
    }
}