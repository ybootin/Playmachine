package playmachine.core;

import js.html.HtmlElement;
import playmachine.core.IApplication;

interface IComponent
{
    private var element:HtmlElement;
    private var application:IApplication;


    /**
     * The basic init component, must be override by each component
     */
    public function init():Void;

    /**
     * get an Html element using its name
     * @param  {String} name: Name of the element
     * @return {HtmlElement}              The element
     */
    public function getElementByName(name:String):HtmlElement;

}
