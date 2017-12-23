package  {
	//
	import Global;
	import VideoControl;
	//
	import flash.events.Event;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.geom.*;
	//
	import KaplanVideo;
	//
	import flash.text.TextFormat;
	import flash.text.TextField;
	//
	public class Playback extends MovieClip{
		var videoContainer:MoveObject
		var player:KaplanVideo
		var controls:VideoControl
		var videoContainerMover:PlayPause;
		var controlsTimer:Timer;
		//
		var currentTitle:String
		var currentLoadPath
		//
		public var isFullscreen:Boolean;
		// 
		Global.vars.mode = "edit"
		//
		Global.vars.transcriptFormat = new TextFormat("_sans",16)
		//
		Global.vars.currentTime = Number(0)
		Global.vars.timingArray = new Array()
		//				
		private var token:String;       
        private var baseURL:String;
        private var videoPath:String;	
		private var debug:Symbol1;	
		private var goingNormalScreen:Boolean=false;	
		//
		public function Playback() {
			//
			//trace("Playback+++++++++++++++++++++++++")					
			stage.align = "TL"
			stage.scaleMode = StageScaleMode.NO_SCALE
			// constructor code
			//--------------------------------------------------
			//videoPath = String(LoaderInfo(this.loaderInfo).parameters["vidPathVar"]);
        	//baseURL = String(LoaderInfo(this.loaderInfo).parameters["vidBasePathVar"]);
        	//token = String(LoaderInfo(this.loaderInfo).parameters["vidTokenKeyVar"]);
			
			//rtmp://cp138157.edgefcs.net/ondemand/GRAD/GRE/gr10s03l02_350.flv?auth=eaCd_d_d_d_d_d_d_d_d_d_d_d_d_d_d_d_bVaFdhb5dZbEb6cybzbpcmaKb8dwb7c5-boI19N-cjvea-wmBEqoGDq&aifp=1234
			//rtmp://cp138157.edgefcs.net/ondemand/GRAD/GRE/gr11vs04l07_high.f4v?auth=eaCd_d_d_d_d_d_d_d_d_d_d_d_d_d_d_d_bVaFdhb5dZbEb6cybzbpcmaKb8dwb7c5-boI19N-cjvea-wmBEqoGDq&aifp=1234
			videoPath = "gr10s03l02_350.flv";
			//videoPath = "gr11vs04l07_high.f4v";
			baseURL="rtmp://cp138157.edgefcs.net/ondemand/GRAD/GRE/";
			token="eaCd_d_d_d_d_d_d_d_d_d_d_d_d_d_d_d_bVaFdhb5dZbEb6cybzbpcmaKb8dwb7c5-boI19N-cjvea-wmBEqoGDq";
			//			
			var myFoo:Boolean = initPlayer()
			//
			videoContainer = new MoveObject()
			Global.vars.fsContent = videoContainer
			videoContainer.addChild(player)
			//
			controls = new VideoControl(player)
			//
			videoContainer.addEventListener(Event.ADDED_TO_STAGE,videoContainerAddedToStage,false)
			addChild(videoContainer)
			//
			//stage.addEventListener(Event.RESIZE,resizeStage)
			//
			stage.addEventListener(FullScreenBTN.GOING_FULL_SCREEN,prepareFullScreen)
			stage.addEventListener(FullScreenBTN.GOING_NORMAL_SCREEN,prepareNormalScreen)
			//
			stage.addEventListener(MouseEvent.MOUSE_MOVE, doControlsMouseMoved);
			controlsTimer = new Timer(3000,1);
			controlsTimer.addEventListener(TimerEvent.TIMER, controlsOnTimer);
		}		
		
		private function videoContainerAddedToStage(e:Event):void{			
			//trace("videoContainerAddedToStage ADDED TO STAGE +++++++++++++++++++++")
			
			debug = new Symbol1();
			addChild(debug)
			
			debug.textBox.appendText("ADDED TO STAGE +++++++++++++++++++++"+"\n");
			
			
			var filename = videoPath.split(".flv").join("")
			var newLoadPath:String = baseURL + filename + "?auth=" + token + "&aifp=1234";
			//
			
			debug.textBox.appendText("newLoadPath ++++++++: "+ newLoadPath + "\n");
			
			if (newLoadPath.split(".f4v").length > 1) {				
				debug.textBox.appendText("---------IS F4V"+"\n");
				if (newLoadPath.split("edgecast").length > 1) {					
					debug.textBox.appendText("-----IS EDGECAST-----"+"\n");
					var g:String = newLoadPath.split("/groups/").join("/groups/mp4:")
					newLoadPath = g
				}
			}
			
			//debug.textBox.appendText("--------prepareNormalScreen"+"\n");
			
			//trace("videoPath++++++1++++++ " + videoPath)
			//trace("baseURL++++++2++++++ " + baseURL)
			//trace("token++++++3++++++ " + token)
			//trace("newLoadPath+++++4++++++ " + newLoadPath)
			if (currentLoadPath == g) {
				//trace("==========------------=======================")
				//return
			}
			g="rtmp://cp138157.edgefcs.net/ondemand/GRAD/mp4:GRE/gr11vs04l07_high.f4v?auth=eaCd_d_d_d_d_d_d_d_d_d_d_d_d_d_d_d_bVaFdhb5dZbEb6cybzbpcmaKb8dwb7c5-boI19N-cjvea-wmBEqoGDq&aifp=1234"
			currentLoadPath = g;
			newLoadPath="rtmp://cp138157.edgefcs.net/ondemand/GRAD/mp4:GRE/gr11vs04l07_high.f4v?auth=eaCd_d_d_d_d_d_d_d_d_d_d_d_d_d_d_d_bVaFdhb5dZbEb6cybzbpcmaKb8dwb7c5-boI19N-cjvea-wmBEqoGDq&aifp=1234"
			player.loadMedia(newLoadPath)			
		}
		
		private function prepareFullScreen(e:Event){
			goingNormalScreen = false;
			//trace("--------prepareFullScreen")			
			stage.fullScreenSourceRect = videoContainer.getBounds(stage)
		}
		private function prepareNormalScreen(e:Event){	
			goingNormalScreen = true;
			controlsTimer.reset();
			controlsTimer.start();
			//trace("--------prepareNormalScreen")
		}
		public function initPlayer(){
			//trace("initPlayer+++++++++++++++++++++++++")		
			player = new KaplanVideo();
			player.addEventListener(KaplanVideo.VIDEO_LOADED,videoLoaded)
			player.addEventListener(KaplanVideo.VIDEO_STATE_CHANGE,stateChange)
			//
			Global.vars.activeVideo = player;
			return true;
		}
		public function stateChange(e:Event){
			//trace("stateChange+++++++++++++++++++++++++")
			//tempDebug.text = player.playState;
			////trace("------------player state change------------")
			////trace(player.playState )
			////trace("-------------------------------------------")
			//
			if (player.playState == "playing") {
				player.addEventListener(KaplanVideo.UPDATE_TIME,updateAfterStart)
			}
			if(player.playState == "paused"){
				//
			}
			if(player.playState == "stopped") {
				player.addEventListener(KaplanVideo.UPDATE_TIME,updateAfterStart)
			}
		}
		
		public function updateAfterStart(e:Event){			
			//trace("!!!!!--------------updateAfterStart----------------")			
			player.removeEventListener(KaplanVideo.UPDATE_TIME,updateAfterStart);			
			//playPause.gotoAndStop("pause")			
		}
		
		public function videoLoaded(e:Event){
			//trace(" - - - - - - - - - - - - VIDEO LOADED - - - - - - - - - - - - > " + Global.vars.videoHeight)
			//
			//stage.dispatchEvent(new Event(Event.RESIZE))
			videoContainer.opaqueBackground = 0xFF0000;
					
			//
			//trace("Global.vars.videoWidth!!!!!!!!! " + Global.vars.videoWidth)
			//trace("Global.vars.videoHeight!!!!!!!!! " + Global.vars.videoHeight)
			controls.width = Global.vars.videoWidth
			controls.x = 0
			controls.y = 432-controls.height
			//
			videoContainer.addChild(controls)
			//
			controls.addEventListener(Scrubber.BEGIN_SCRUB,videoBeginSeekTo)
			controls.addEventListener(Scrubber.IN_SCRUB,videoInSeekTo)
			controls.addEventListener(Scrubber.END_SCRUB,videoEndSeekTo)
			//
			/*
			stage.addEventListener(MouseEvent.MOUSE_MOVE, doControlsMouseMoved);
			controlsTimer = new Timer(3000,1);
			controlsTimer.addEventListener(TimerEvent.TIMER, controlsOnTimer);
			Global.vars.playerPausedState = false;
			controlsTimer.start();
			*/
			Global.vars.playerPausedState = false;
			controlsTimer.start();
		}

		private function doControlsMouseMoved(e:MouseEvent):void {
    		//controls.moveTo(0,(Global.vars.videoHeight-controls.height)); 
			controls.moveTo(0,(432-controls.height));
			controlsTimer.start();
		}		
		
		function controlsOnTimer(e:TimerEvent):void{
			if (controls.hitTestPoint(mouseX,mouseY,true) && goingNormalScreen == false) {
				//controls.moveTo(0,(Global.vars.videoHeight-controls.height)); 
				controls.moveTo(0,(432-controls.height));
			} else {
				//controls.moveTo(0,Global.vars.videoHeight);
				goingNormalScreen = false;
				controls.moveTo(0,432);
			}
			//controls.removeEventListener(Event.ENTER_FRAME,controllaMouse);
		}	
		
		private function videoBeginSeekTo(e:Event){
			player.pause()
			//
		}
		private function videoInSeekTo(e:Event){
			player.seek(player.duration*Global.vars.seekTo)
		}
		private function videoEndSeekTo(e:Event){
			player.seek(player.duration*Global.vars.seekTo)
			player.resume()
			//
		}
		
		public function resizeStage(e:Event){			
			var newX = ((stage.stageWidth-200)/2)-(videoContainer.width/2) + 200;
			var newY = (stage.stageHeight/2)-(videoContainer.height/2);
			//var newY = 0
			if (stage.displayState == "normal" || stage.displayState == null) {
				videoContainer.moveTo(newX, newY)
			}
		}
	}
}