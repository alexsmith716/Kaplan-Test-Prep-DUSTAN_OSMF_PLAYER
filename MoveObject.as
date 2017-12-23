package  {
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.Event
	public class MoveObject extends MovieClip{
		var timer:Timer
		var difX:Number
		var difY:Number
		var newX:Number
		var newY:Number
		var speed:Number = new Number(6)
		//FOR TIMING CONTROL
		public var whichXML:XML
		public var inTimer
		public var outTimer		
		//
		public static const MOVE_COMPLETE:String = "moveComplete";
		public static const IN_MOVE:String = "inMove";
		//
		public function moving(e:TimerEvent){
			difX = newX - x
			difY = newY - y
			x += difX/speed
			y += difY/speed
			var newEvent:Event
			newEvent = new Event(IN_MOVE,true,true)
			dispatchEvent(newEvent)
			if (Math.abs(difX) <= 1 && Math.abs(difY) <= 1) {
				timer.stop()
				x = newX
				y = newY
				newEvent = new Event(MOVE_COMPLETE,true,true)
				dispatchEvent(newEvent)
			}
		}
		public function moveTo(xPos,yPos){
			xPos != null ? newX = xPos : null;
			yPos != null ? newY = yPos : null;
			if (timer == null) {
				timer = new Timer(.33,0)
				timer.addEventListener(TimerEvent.TIMER,moving)
				timer.start()
				} else {
				if (!timer.running) {
					timer.start()
				}			
			}
		}
	}
}