package  {

	import KaplanVideo
	import Global;
	import TimeUtils;
	import MultiBox;
	import Scrubber;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize
	//
	public class VideoControl extends MoveObject{
		//trace("VideoControl+++++++++++++++++")
		//
		//
		var player:KaplanVideo
		//
		var controls:Background
		//
		var controlsContent:Array
		//
		var time:String
		//
		var timeField:TextField				
		//
		var playPause:PlayPause
		var scrubber:Scrubber
		var fullScreenBTN:FullScreenBTN
		//
		//private var bufferingAnim:loadingAnim = new loadingAnim()
		//
		var t:TextFormat = new TextFormat("_sans",18,0xFFFFFF)
		//
		public function VideoControl(whichVideo:KaplanVideo) {
			// constructor code
			time = new String()
			setupControls()
			setupEvents()
		}
		//
		public function setupEvents(){
			player.addEventListener(KaplanVideo.VIDEO_STATE_CHANGE,playerStateChange)
		}

		private function playerStateChange(e:Event){
			//trace("CONTROLS: " + player.playState)
			//Global.vars.debug.textBox.appendText("VideoControl: " + player.playState + "\n");
			var state = player.playState
			switch (state) {
				case "paused":
				//if(Global.vars.playerPausedState == true){
					playPause.gotoAndStop("play");		
				//}
				//
				break;
				case "playing":
				playPause.gotoAndStop("pause");
				//
				break;	
				case "stopped":
				//
				break;	
			}

		}
		private function setupControls():void{
			
			//trace("...............VideoControl - setupControls...............")
			////trace(theVideo.duration)
			player = Global.vars.activeVideo
			//
			player.addEventListener(KaplanVideo.UPDATE_TIME,updateTime)
			
			//
			controls = new Background(100,40)
			//controls.bitmap = new Bitmap2()
			controls.color = 0x000000
			//controls.alpha = .7
			///------------TEMP FOR TESTING CONTROLS BUILDING-------------///
			playPause = new PlayPause()
			playPause.x = 5
			playPause.y = 5
			playPause.addEventListener(MouseEvent.CLICK,player.togglePause)
			playPause.buttonMode = true;
			//
			scrubber = new Scrubber()
			scrubber.x = playPause.width + 20
			scrubber.buttonMode = true;
			//scrubber.alpha = 1
			scrubber.y = (controls.height/2) - (scrubber.height/2)
			scrubber.addEventListener(Scrubber.IN_SCRUB,updateTime)
			scrubber.addEventListener(Scrubber.SCRUBBER_RESIZE,scrubberResize)
			//
			//
			timeField = new TextField()
			timeField.autoSize = TextFieldAutoSize.LEFT
			timeField.x = scrubber.width + scrubber.x + 20
			timeField.y = (controls.height/2) - (timeField.textHeight/2)
			timeField.selectable = false
			//
			fullScreenBTN = new FullScreenBTN()
			fullScreenBTN.y = (controls.height/2) - (fullScreenBTN.height/2) 
			fullScreenBTN.x  = controls.width - fullScreenBTN.width - 5
			//
			addChild(controls)
			addChild(playPause)
			addChild(scrubber)
			addChild(timeField)
			addChild(fullScreenBTN)
			///
		}
		private function scrubberResize(e:Event){
			//trace("SCRUBBER _ RESIZE")
			timeField.y = (controls.height/2) - (timeField.height/2)
			timeField.x = scrubber.width + scrubber.x + 20
			timeField.selectable = false
		}
		public override function set width(width:Number):void{
			controls.width = width
			scrubber.width = width*.5
			fullScreenBTN.x  = controls.width - fullScreenBTN.width - 5
		}
		public function updateTime(e:Event){

			var toTime:Number
			if (scrubber.scrubbing) {
				toTime = player.duration * scrubber.seekTo
				} else {
				toTime = player.time
			}

			time = (TimeUtils.makeTime(toTime) + " – " + TimeUtils.makeTime(player.duration))
			//
			timeField.text = time
			timeField.setTextFormat(t)
			
			timeField.y = (controls.height/2) - (timeField.height/2)
			//			
			///////trace(player.time/player.duration)
			scrubber.position = player.time / player.duration
			
		}
	}
	
}
