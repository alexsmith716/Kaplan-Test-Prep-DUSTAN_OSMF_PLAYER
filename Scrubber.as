package  {
	import flash.display.Sprite;
	import flash.display.Graphics
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import Global;
	import flash.display.Stage;
	import flash.display.MovieClip;
	
	//
	public class Scrubber extends MoveObject{
		public var track:Sprite
		public var thumb:Sprite
		//
		public var seekTo:Number
		//
		public static const BEGIN_SCRUB:String = "beginScrub"
		public static const IN_SCRUB:String = "inScrub"
		public static const END_SCRUB:String = "endScrub"
		//
		public static const SCRUBBER_RESIZE:String = "scrubberResize"
		//
		public var scrubbing:Boolean = new Boolean(false)
		//

		public function Scrubber() {
			// constructor code

			
			buildTrack(400,10)
			buildThumb(20,20)
			//
			this.addEventListener(Event.ADDED_TO_STAGE,init)
			//
			
			//
			//position = .25
		}
		private function init(e:Event){
			setupInteractions()
		}
		public function setupInteractions(){
			//trace("JNUJNJJJINJO")
			thumb.addEventListener(MouseEvent.MOUSE_DOWN,thumbDown)
			
			track.addEventListener(MouseEvent.MOUSE_DOWN,trackDown)
			
		}
		private function trackDown(e:MouseEvent){			
			thumb.x = this.mouseX - (thumb.width/2)
			thumb.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN))
		}
		private function stageMove(e:MouseEvent){
			//report position here.
			seekTo = thumb.x/(track.width-thumb.width)
			Global.vars.seekTo = seekTo
			Global.vars.scrubbing = true
			////trace("MOVE")
			var evt:Event = new Event(Scrubber.IN_SCRUB,true)
			dispatchEvent(evt)
		}
		private function stageUp(e:MouseEvent){
			Global.vars.scrubbing = false
			scrubbing = false
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,stageMove)
			stage.removeEventListener(MouseEvent.MOUSE_UP,stageUp)
			stopDrag()
			seekTo = thumb.x/(track.width-thumb.width)
			Global.vars.seekTo = seekTo
			//
			var evt:Event = new Event(Scrubber.END_SCRUB,true)
			dispatchEvent(evt)
		}
		private function thumbDown(e:MouseEvent){
			var rect:Rectangle = new Rectangle(0,thumb.y,track.width-thumb.width,0)
			Global.vars.scrubbing = true
			scrubbing = true
			thumb.startDrag(false,rect)
			stage.addEventListener(MouseEvent.MOUSE_UP,stageUp)
			stage.addEventListener(MouseEvent.MOUSE_MOVE,stageMove)
			//
			
			var evt:Event = new Event(Scrubber.BEGIN_SCRUB,true)
			dispatchEvent(evt)
		}
		//
		public function set position(pos:Number){
			//pos should be a percentage
			var newPosition = pos * (track.width-thumb.width)
			!scrubbing ? thumb.x = newPosition : null
		}
		
		public override function set width(width:Number):void{
			track.width = width
			var evt:Event = new Event(SCRUBBER_RESIZE,true)
			dispatchEvent(evt)
			//
			
		}

		
		
		
		
		private function buildTrack(width:Number,height:Number){
			track = new Sprite()
			var g:Graphics = track.graphics
			g.beginFill(0xCCCCCC,1)
			g.drawRect(0,0,width,height)
			g.endFill()
			//track.alpha = .8
			addChild(track)
		}
		private function buildThumb(width:Number,height:Number){
			thumb = new Sprite()
			var g:Graphics = thumb.graphics
			//g.lineStyle(0,0x000000,1,true,"noScale")
			g.beginFill(0xAAAAAA,1)
			g.drawRoundRect(0,0,width,height,width,height)
			g.endFill()
			//thumb.y = 
			track.y = (height/2) - (track.height/2)
			//thumb.cacheAsBitmap = true
			//thumb.alpha = .8
			addChild(thumb)
		}

	}
	
}
