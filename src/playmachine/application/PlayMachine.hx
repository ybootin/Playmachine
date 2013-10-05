package playmachine.application;

import playmachine.core.Application;

#if js
@:expose class PlayMachine extends Application
#else
class PlayMachine extends Application
#end
{
	/**
	 * HaXe bootstrap
	 */
	static public function main():Void
	{
#if flash
		new PlayMachine(flash.Lib.current.loaderInfo.parameters.data);
#end
	}

	/**
	 * declare the playmachine components
	 */
	override private function declareComponents():Void
	{
		// Store components className and order
		components = [
			new playmachine.components.AudioManager(this,'AudioManager'),
			new playmachine.components.ControlBar(this,'ControlBar'),
			new playmachine.components.PlaylistPanel(this,'PlaylistPanel'),
			new playmachine.components.SeekBar(this,'SeekBar'),
			new playmachine.components.SoundLevel(this,'SoundLevel'),
			new playmachine.components.MuteButton(this,'MuteButton'),
			new playmachine.components.TrackImage(this,'TrackImage')
		];
	}

}
