package playmachine.model;

interface IComponent
{
    private var global:EventDispatcher;
    private var element:HtmlDom;
    private var stylesAreInitiated:Bool;
    public var application:IApplication;


    /**
     * here we set the data for js and flash, so each component will have access to data before init
     */
    public function new(application:IApplication,?nodeClassName:String = null);
    /**
     * The basic init component, must be override by each component
     */
    public function init():Void;

    /**
     * get an Html element using its name
     * @param  {String} name: Name of the element
     * @return {HtmlDom}              The element
     */
    public function getElementByName(name:String):HtmlDom;

    /**
     * dispatch an event on the group element
     * @param  {String} eventName: Name of the event
     * @param  {Dynamic} data:     data associated with the event
     * @return {Void}
     */
    public function dispatchEventOnApplication(eventName:String, ?eventData:Dynamic):Void;
}
