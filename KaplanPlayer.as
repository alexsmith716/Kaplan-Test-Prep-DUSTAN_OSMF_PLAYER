package  {
	import flash.display.MovieClip;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.VideoEvent
	import flash.events.NetStatusEvent
	import flash.events.AsyncErrorEvent
	import Background;
	import flash.display.Sprite;
	import flash.display.Graphics;

	public class KaplanPlayer extends MoveObject{
	
	var videoHolder:MoveObject;
	var background:Background;
	var foreground:Background;
	private var video:Video;
	private var nc:NetConnection
	private var ns:NetStream
	private var NScallbacks:Object
	private var NCcallbacks:Object
	//
	private var _protocol:String
	private var _prepend:String
	private var _streamname:String
	private var _basepath:String
	private var _applicationpath:String
	private var _connectionpath:String
	private var _token:String
	var token:String = new String("d44f19a684109620e4841478a390");
	private var _append:String
	
	//
	private var videoWidth:int
	private var videoHeight:int
	private var videoDuration:int
	
	private var path:String
	
	var controlsHolder:MovieClip;
		public function KaplanPlayer() {
			// constructor code
		}
		public function initVideo(){
			//
			video = new Video(videoWidth,videoHeight)
			nc = new NetConnection()
			//
			nc.addEventListener(NetStatusEvent.NET_STATUS,ncEar)
			NCcallbacks = new Object()
			nc.client = NCcallbacks
			NCcallbacks.onBWDone = onBWDone
			//
			//trace("!                            _connectionpath: " + _connectionpath +  "/" +  _applicationpath)
			nc.connect(_connectionpath + "/" +  _applicationpath)
		}
		public function onBWDone(){
			return 0
		}
		public function nsEar(e:NetStatusEvent){
			//trace("--------NET-STREAM STATUS")
			var code = e.info.code
			//trace(code)
			switch (code) {
				case "NetStream.Play.Start" :
				//
				//
				break;
				case "NetStream.Buffer.Full" :
				drawPlaypause()
				//
				break;
				case "NetStream.Pause.Notify" :
				//
				//
				break;
				case "NetStream.Unpause.Notify" :
				//
				//
				break;				
			}
		}
		public function openStream(){
			
			ns = new NetStream(nc);
			ns.addEventListener(NetStatusEvent.NET_STATUS,nsEar)
			//trace(nc.client)
			//
			NScallbacks = new Object()
			ns.client = NScallbacks
			NScallbacks.onMetaData = metaDataHandler
			//
			var _correctedstreamname
			_correctedstreamname = _streamname.split(".flv").join("")
			//trace(" open stream _streamname: " + _correctedstreamname + "?" + token)
			//
			NScallbacks.onAsynchError = asyncErrorHandler
			
			//ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			ns.play("/" + _correctedstreamname + "?" + token)
			
			video.attachNetStream(ns)
		}
		function asyncErrorHandler(event:AsyncErrorEvent):void { 
			//trace("///////////asyncErrorHandler")
			//trace(event.text); 
		} 
		public function ncEar(e:NetStatusEvent){
			//trace("--------NET-CONNECTION STATUS")
			var code = e.info.code
			//trace(code)
			switch (code) {
				case "NetConnection.Connect.Success" :
				//trace("--NC STATUS IS GOOD--Now open stream.")
				openStream()
				//
				break;
			}
		}
		function metaDataHandler(infoObject:Object):void { 
			//trace("-------------------------------------metadata");
			for (var vars in infoObject) {
				////trace(vars)
				switch (vars) {
					case "width" :
					//trace("VIDEO WIDTH !!!!!!!!!!!!!!!!! " + infoObject[vars])
					videoWidth = infoObject[vars]
					//
					break;
					case "height" :
					//trace("VIDEO HEIGHT !!!!!!!!!!!!!!!!! " + infoObject[vars])
					videoHeight = infoObject[vars]
					//
					break;			
					case "duration" :
					videoDuration = infoObject[vars]
					//
					break;		
					default :
					//
					break;
				}
		
			}
			initDisplay()
		}
		public function initDisplay(){
			background = new Background(100,100)
			foreground = new Background(100,100)
			videoHolder = new MoveObject()
			this.addChild(background)
			videoHolder.addChild(video)
			this.addChild(videoHolder)
			this.addChild(foreground)
			//-----really need a content mask here, not a video mask, but whatevs
			video.mask = foreground
			//
			video.opaqueBackground = 0x333355
			video.width = videoWidth
			video.height = videoHeight
			//
			background.width = videoWidth
			background.height = videoHeight
			//var gg = 1.3
			foreground.width = videoWidth
			foreground.height = videoHeight
			//
			//foreground.moveTo(foreground.width*(gg-1),foreground.height*(gg-1))
		}
		public function deriveConnection(){
			//trace("----------------------------------------------------------------------deriveConnection------")
			//this could use a totallly new recode. I can use the OSMP code if I'm lazy.
			//trace("PATH: " + path)
			//
			_protocol = path.split("://")[0]
			_prepend
			_basepath = path.split("://")[1].split("/")[0]
			_token = "?" + path.split("?")[1]
			_connectionpath = _protocol + "://" + _basepath
			_applicationpath =  path.split(_connectionpath)[1].split("/")[1]
			//rtmp://fms.0355.edgecastcdn.net/000355/KaplanPlayer/JP_Road_Ahead_for_Faculty_v3
			
			_streamname = path.split(_applicationpath + "/")[1]
			
			//trace("connection path  " + _connectionpath)
			//trace("application path  " + _applicationpath)
			//trace("stream name  " + _streamname)
			//_connectionpath += "/" + _applicationpath
			//_connectionpath = "rtmp://fms.0355.edgecastcdn.net/000355/KaplanPlayer/"
			//
			//_streamname = "JP_Road_Ahead_for_Faculty_v3"
			//_streamname = "JP_Road_Ahead_for_Faculty_v3"
			//
			if (_streamname.split(".f4v").length > 1) {
				//trace("F4V: ")
				//trace(_streamname.split("/")[_streamname.split("/").length-1])
			}
			//_filename = path.split(_connectionpath)[1].split("/")[path.split(_connectionpath)[1].split("/").length-1].split(_token)[0]
			_append
		}
		public function set videoPath(v:String):void{
			path = v
			//trace("-------set videoPath   KICK IT");
			deriveConnection()
			initVideo()
		}
		function drawPlaypause(){
			//
		}
	}
}
