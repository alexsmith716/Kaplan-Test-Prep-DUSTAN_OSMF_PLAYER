package {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	//import fl.controls.*; 
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.net.StreamType;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.containers.MediaContainer;
	import org.osmf.elements.VideoElement;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.LoadEvent
	import org.osmf.traits.*;
	import org.osmf.events.BufferEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaError
	//
	import org.osmf.events.PlayEvent;
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.events.AudioEvent;
	import org.osmf.metadata.Metadata;
	//
	import flash.display.MovieClip;
	import org.osmf.events.SeekEvent;

	//
	public class KaplanVideo extends Sprite {
		//trace("KAPLAN VIDEO")
		private var videoElement:VideoElement;
		private var mediaPlayer:MediaPlayer;
		private var mediaPlayerSprite:MediaPlayerSprite;
		//
		public static const UPDATE_TIME:String = "updateTime"
		public static const VIDEO_LOADED:String = "videoLoaded"
		public static const VIDEO_LOAD_ERROR:String = "videoLoadError"
		//
		public static const VIDEO_STATE_CHANGE:String = "videoStateChange"
		//
		public static const BUFFERING:String = "buffering";
		public static const END_BUFFERING:String = "endBuffering";
		public static const VIDEO_COMPLETE:String = "videoComplete"
		//
		private var currentVideo:String
		//
		public var playState:String
		public var loadState:String
		//
		private var newLoadingAnim:loadingAnim = new loadingAnim()
		//
		public function KaplanVideo() {
			//trace("cccccccccccccccccc+++++++++++++++++++")
			newLoadingAnim.cacheAsBitmap = true;
			//l.blendMode = "difference"
			videoElement = new VideoElement();
			videoElement.smoothing = true;
			mediaPlayerSprite = new MediaPlayerSprite();

			mediaPlayerSprite.opaqueBackground = 0x000000
			//
			mediaPlayer = mediaPlayerSprite.mediaPlayer;
			//
			mediaPlayer.addEventListener(BufferEvent.BUFFERING_CHANGE,_bufferChanged)
			mediaPlayer.addEventListener(MediaErrorEvent.MEDIA_ERROR,_mediaError)
			mediaPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE,_currentTimeChange)
			mediaPlayer.addEventListener(TimeEvent.COMPLETE,_timeComplete)
			mediaPlayer.addEventListener(PlayEvent.PLAY_STATE_CHANGE,_playStateChange)

			mediaPlayer.addEventListener(LoadEvent.BYTES_LOADED_CHANGE,_bytesLoadedChange)
			mediaPlayer.addEventListener(LoadEvent.BYTES_TOTAL_CHANGE,_bytesTotalChange)
			mediaPlayer.addEventListener(LoadEvent.LOAD_STATE_CHANGE,_loadStateChanged)
			//
			mediaPlayerSprite.media = videoElement;
			//
			addChild(mediaPlayerSprite);
		}

		private function showBuffering(e:Event){
			//trace("-------------SHOW BUFFERING")
			newLoadingAnim.x = 20
			newLoadingAnim.y = 20

			newLoadingAnim.scaleX = .6
			newLoadingAnim.scaleY = .6
			try{
				if (mediaPlayerSprite.width != 0) {
					//addChild(newLoadingAnim)
					} else {
					//trace("EEEEEEEEE")
				}
			}catch(e:Error){
				//trace("F")
			}			
		}
		private function hideBuffering(e:Event){
			//trace("--------------HIDE BUFFERING")
			try{
				removeChild(newLoadingAnim)
			}catch(e:Error){
				//
			}
		}
		public function loadMedia(what:String):void {
			if (currentVideo == what) {
				return
			}
			currentVideo = what
			var url:String = what;				
			//var url:String = "Intramuscular_Introduction.mp4";
			//------------------------------------------------------//
			var r:StreamingURLResource = new StreamingURLResource(url)
			//------------------------------------------------------//			
			r.urlIncludesFMSApplicationInstance = true
			//
			videoElement.resource = r
			
		}
		public function togglePause(...args){
			if (mediaPlayer.paused) {
				//trace("TP 1 +++++++++++++++++++++++++++++++++++++++++++++++++")
				Global.vars.playerPausedState = false;
				mediaPlayer.play()
			} else {
				//trace("TP 2 +++++++++++++++++++++++++++++++++++++++++++++++++")
				Global.vars.playerPausedState = true;
				mediaPlayer.pause()
			}
		}
		public function play(){
			//trace("TP 3 +++++++++++++++++++++++++++++++++++++++++++++++++")
			mediaPlayer.play()
		}
		public function seek(where:Number){
			if (!mediaPlayer.seeking) {
				mediaPlayer.seek(where)
			}			
		}
		public function pause(){
			mediaPlayer.pause()
		}
		public function resume(){
			//trace("TP 4 +++++++++++++++++++++++++++++++++++++++++++++++++")
			if(Global.vars.playerPausedState == false){
				mediaPlayer.play();
			}
		}
		public function set volume(v:Number){
			mediaPlayer.volume = v
		}
		public function get duration():Number{
			return mediaPlayer.duration
		}
		public function get time():Number{
			return mediaPlayer.currentTime
		}
		public function get paused():Boolean{
			return mediaPlayer.paused
		}
		public function get seeking():Boolean{
			return mediaPlayer.seeking
		}
		///////////////////////////////////////////////
		private function _loadStateChanged(e:LoadEvent){
			//trace("--------LOAD STATE--------")
			//trace(e.loadState)
			//trace("--------------------------")
			loadState = e.loadState
			////trace(this.width + ":" + this.height)
			if (e.loadState == "ready") {
				//
				mediaPlayer.addEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE,_mediaSizeChange)
				//
				newLoadingAnim.x = mediaPlayerSprite.width/2
				newLoadingAnim.y = mediaPlayerSprite.height/2
			}
		}
		private function _bytesLoadedChange(e:LoadEvent){
			//trace("--------BYTES LOADED CHANGE--------")
		}
		private function _bytesTotalChange(e:LoadEvent){
			//trace("--------BYTES TOTAL CHANGE--------")
		}		
		///////////////////////////////////////////////
		private function _mutedChange(e:AudioEvent){
			//trace("--------MUTED CHANGE--------")
		}
		private function _volumeChange(e:AudioEvent){
			//trace("--------VOLUME CHANGE--------")
		}
		private function _currentTimeChange(e:TimeEvent){
			var evt:Event = new Event(UPDATE_TIME)
			dispatchEvent(evt)
		}
		private function _timeComplete(e:TimeEvent){
			//trace("--------TIME COMPLETE EVENT--------")
			var evt:Event = new Event(VIDEO_COMPLETE)
			dispatchEvent(evt)
		}
		private function _timeDurationChange(e:TimeEvent){
			//trace("--------TIME DURATION CHANGE-------")
		}
		private function _displayObjectStateChange(e:DisplayObjectEvent){
			//trace("--------DISPLAY OBJECT STATE CHANGE-------")
		}
		private function _mediaSizeChange(e:DisplayObjectEvent){
				//trace("-------------------MEDIA SIZE CHANGE---------------------")
			
			if (this.width != 0 && this.height != 0 && loadState == "ready") {
				//trace("VIDEO size change-" + this.width + ":" + this.height)
				//trace("--------------------FIRE VIDEO LOADED--------------------")
				mediaPlayer.bufferTime = 10;
				//var bitrate = mediaPlayer.getBitrateForDynamicStreamIndex(0)
				this.addEventListener(KaplanVideo.BUFFERING,showBuffering)
				this.addEventListener(KaplanVideo.END_BUFFERING,hideBuffering)
				mediaPlayer.addEventListener(SeekEvent.SEEKING_CHANGE,showBuffering)
				Global.vars.videoWidth = this.width
				Global.vars.videoHeight = this.height
				var evt:Event = new Event(VIDEO_LOADED)
				this.dispatchEvent(evt)
				mediaPlayer.removeEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE,_mediaSizeChange)
			}

		}		
		private function _playStateChange(e:PlayEvent){
			//trace("--------KAPLAN VIDEO STATE CHANGE-------")
			playState = e.playState
			var evt:Event = new Event(VIDEO_STATE_CHANGE)
			dispatchEvent(evt)
		}
		private function _bufferChanged(e:BufferEvent){
			//trace("---------BUFFER CHANGED---------")
			var evt:Event
			if (e.buffering) {
				evt = new Event(BUFFERING)
				} else {
				evt = new Event(END_BUFFERING)
			}
			dispatchEvent(evt)
			////trace("--------------------------------")
		}
		private function _bufferTimeChanged(e:BufferEvent){
			//trace("---------BUFFER TIME CHANGED---------")
		}
		private function _mediaError(e:MediaErrorEvent):void {
			//trace("---------MEDIA ERROR---------")
			var error:MediaError = e.error as MediaError;
			var evt:Event = new Event(VIDEO_LOAD_ERROR)
			dispatchEvent(evt)
		}
	}
}