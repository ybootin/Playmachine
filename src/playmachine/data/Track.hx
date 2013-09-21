package playmachine.data;

/**
 * Use type for flash cast
 */
typedef Track = {
    id:Int,
    title:String,
    /**
     * The mp3 file absolute url
     * ex : http://mywebsite/myfolder/my.mp3
     */
    file:String,
    /**
     * The absolute path to the track image
     */
    image:String
}