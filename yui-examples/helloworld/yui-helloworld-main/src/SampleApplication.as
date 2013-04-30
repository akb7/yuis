package
{
    import flash.utils.setInterval;
    import flash.utils.setTimeout;
    
    import spark.components.Label;
    
    import yuis.framework.YuiApplication;
    
    public class SampleApplication extends YuiApplication
    {
        public var booting:Label;
        
        public function SampleApplication()
        {
            super();
        }
        
        protected override function createRootView():void{
            booting.text = "1秒後に起動します。";
            setTimeout(super.createRootView,1000);
        }
    }
}