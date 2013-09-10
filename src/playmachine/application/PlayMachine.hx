package playmachine.application;

import js.Dom;
import js.Lib;

class PlayMachine 
{
	private var data:Dynamic;

	private var components:Array<Dynamic>;

#if js
	public function new(container:HtmlDom,data:Dynamic)
	{
		//js boot specific
#elseif flash 
	public function new(data:Dynamic)
	{
		//flash boot specific
		
#end


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
		// Store components className and order
		var components:Array<Dynamic> = [
			{'id':'AudioManager','class' : application.ui.AudioManager},
			{'id':'ControlBar','class' : application.ui.controlBar},
			{'id':'PlaylistPanel','class' : application.ui.PlaylistPanel},
			{'id':'SeekBar','class' : application.ui.SeekBar},
			{'id':'TrackImage','class' : application.ui.TrackImage}
		];
	}
}