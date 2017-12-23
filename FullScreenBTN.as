package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.StageDisplayState

	
	public class FullScreenBTN extends MovieClip {
		public static const GOING_FULL_SCREEN:String = "goingFullScreen"
		public static const GOING_NORMAL_SCREEN:String = "goingNormalScreen"
		
		public function FullScreenBTN() {
			// constructor code
			this.gotoAndStop(2)
			this.addEventListener(Event.ADDED_TO_STAGE,init)
		}
		private function init(e:Event){
			this.addEventListener(MouseEvent.CLICK,changeFullscreen)
			this.buttonMode = true;
		}
		private function changeFullscreen(e:MouseEvent){
			//trace("CHANGE FS")
			//stage.fullScreenSourceRect = 
		
			var evt:Event
			
			//trace(stage.displayState)
			
			if (stage.displayState == null) {
					evt = new Event(GOING_FULL_SCREEN,true)
					dispatchEvent(evt)
			}

			if (stage.displayState == "normal") {
					this.gotoAndStop(1)
					evt = new Event(GOING_FULL_SCREEN,true)
					dispatchEvent(evt)
					stage.displayState = StageDisplayState.FULL_SCREEN;
				} else {
					this.gotoAndStop(2)
					evt = new Event(GOING_NORMAL_SCREEN,true)
					dispatchEvent(evt)
					stage.displayState = StageDisplayState.NORMAL
			}

			
		}
	}
	
}
