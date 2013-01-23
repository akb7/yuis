package
{
    import flash.utils.setTimeout;
    
    import yuis.event.YuiFrameworkEvent;
    import yuis.framework.YuiApplication;
    
    public class SampleApplication extends YuiApplication
    {
        public function SampleApplication()
        {
            super();
            
            this.addEventListener(YuiFrameworkEvent.APPLICATION_START,on_applicationStart);
        }
        
        private function on_applicationStart(event:YuiFrameworkEvent):void{
            event.preventDefault();
            
            setTimeout(requestApplicationStart,1000);
        }
        
        
    }
}