package playmachine.core;

import slplayer.ui.DisplayObject;
import slplayer.ui.group.IGroupable;
using slplayer.ui.group.IGroupable.Groupable;
import js.Dom;
import js.Lib;
import playmachine.event.Events;
import playmachine.helpers.HtmlDomHelper;
using playmachine.helpers.HtmlDomHelper;
import haxe.Json;


/**
 * The base component
 */
class BaseComponent extends DisplayObject, implements IGroupable {
    public var groupElement:HtmlDom;

    public var SLPid:String;

    /**
     * here we set the data for js and flash, so each component will have access to data before init
     */
    public function new(rootElement:HtmlDom, SLPid:String) {
        super(rootElement, SLPid);
        startGroupable();

        //FIXME : in Cocktail groupElement is always null if rootElement at the top level node of the application
        if(groupElement == null) {
            groupElement = rootElement;
        }
    }

    /**
     * get an Html element using its name
     * @param  {String} name: Name of the element
     * @return {HtmlDom}              The element
     */
    public function getElementByName(name:String):HtmlDom {
        return rootElement.getElementByClassName(name);
    }

    /**
     * dispatch an event on the group element
     * @param  {String} eventName: Name of the event
     * @param  {Dynamic} data:     data associated with the event
     * @return {Void}
     */
    public function dispatchEventOnGroup(eventName:String, ?eventData:Dynamic):Void
    {
        //dispatch the global events
        groupElement.dispatchCustomEvent(Events.BUZZPLAYER_EVENT, new BuzzplayerEventData(eventName,eventData));

        //finally we dispatchEvent to the component
        //better dispatch at the end, else event appear in wrong order on the JS API
        groupElement.dispatchCustomEvent(eventName, eventData);
    }
}
