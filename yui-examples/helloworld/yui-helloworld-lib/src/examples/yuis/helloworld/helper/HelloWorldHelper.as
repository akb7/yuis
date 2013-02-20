package examples.yuis.helloworld.helper
{
    import examples.yuis.helloworld.view.HelloWorldView;
    import examples.yuis.helloworld.view.StateAView;
    import examples.yuis.helloworld.view.StateBView;
    
    import yuis.ns.yuis_viewpart;

    /**
     * 
     */
    public class HelloWorldHelper
    {
        /**
         * 
         */
        public var view:HelloWorldView;
        
        /**
         * 
         */
        yuis_viewpart var a:StateAView;
        
        /**
         * 
         */
        yuis_viewpart var b:StateBView;
        
        /**
         * 
         */
        public function changeStateA():void{
            view.currentState = "stateA";
        }
        
        /**
         * 
         */
        public function changeStateB():void{
            view.currentState = "stateB";
        }
    }
}