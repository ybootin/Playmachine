package playmachine.application;

import js.Dom;
import js.Lib;

class PlayMachine 
{
	private var data:Dynamic;

	private var components:Array<IComponent>;

#if js
	public function new(container:HtmlDom,data:Dynamic)
	{
		//js boot specific
#elseif flash 
	public function new(data:Dynamic)
	{
		//flash boot specific
		
#end
		
		initComponents();

	}

	public static function init(container:HtmlDom,data:Dynamic):Void 
	{
		return new PlayMachine(container,data);
	}

	/**
	 * HaXe bootstrap
	 */
	public static function main():Void
	{
#if flash
		var app:PlayMachine = new PlayMachine(loaderInfo.parameters.init);
#end
	}

	private function initComponents():Void
	{
		components = [];

		// Store components className and order
		var availables:Array<Dynamic> = [
			{'id':'AudioManager','class' : application.components.AudioManager},
			{'id':'ControlBar','class' : application.components.controlBar},
			{'id':'PlaylistPanel','class' : application.components.PlaylistPanel},
			{'id':'SeekBar','class' : application.components.SeekBar},
			{'id':'TrackImage','class' : application.components.TrackImage}
		];

		for (i in 0...availables.length) {
			var c:Dynamic = availables[i];
			var o:IComponent = new c.class(c.id,data);
			components.push(o);
		}

		//init component after all are instanciated
		for(i in 0...components.length) {
			components[i].init();
		}

	}
}