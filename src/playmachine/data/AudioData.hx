package playmachine.data;

import playmachine.core.Constants;

class AudioData
{
    public var volume:Float;
    public var currentTime:Float;
    public var duration:Float;
    public var percentLoaded:Float;
    public var percentPlayed:Float;

    public function new()
    {
    	volume = Constants.DEFAULT_SOUND_LEVEL;

    	currentTime = duration = percentLoaded = percentPlayed = 0;
    }
}