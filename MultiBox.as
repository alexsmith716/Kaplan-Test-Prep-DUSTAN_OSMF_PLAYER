package  {
	import flash.display.MovieClip
	import Background;
	import MoveObject;
	import flash.events.Event;
	//
	public class MultiBox extends MovieClip{
		private var boxHolder:MoveObject
		//
		private var background:Background
		private var foreground:Background
		//
		private var boxArray:Array = new Array()
		//
		private var multiBoxWidth:Number
		private var multiBoxHeight:Number
		//
		private var currentRowArray:Array
		private var rowWidth:Number
		//
		private var centerRH:Boolean = new Boolean(true);
		private var centerRV:Boolean = new Boolean(false)
		//
		private var centerCH:Boolean = new Boolean(false);
		private var centerCV:Boolean = new Boolean(true)
		//
		var newX
		var newY
		//
		public var spc:int = new int(2)
		//
		public function MultiBox(width:Number,height:Number) {
			//constructor code
			////trace("----------MultiBox");
			background = new Background(width,height)
			background.color = 0x000000
			//background.bitmap = new Bitmap5()
			foreground = new Background(width,height)
			foreground.alpha = .2
			multiBoxHeight = height
			multiBoxWidth = width
			boxHolder = new MoveObject()
			//

			
			//
			boxHolder.x = spc
			addChild(background)
			addChild(boxHolder)
			addChild(foreground)
			boxHolder.mask = foreground
		}
		public function setContentArray(whichArray:Array){
			boxArray = whichArray
			layoutBoxes()
		}
		public function layoutBoxes(){
			while (boxHolder.numChildren > 0) {
				var ex = boxHolder.getChildAt(0)
				boxHolder.removeChildAt(0)
			}
			rowWidth = 0
			newX = spc
			newY = spc
			currentRowArray = new Array()
			var g
			for (var i = 0 ; i < boxArray.length;i++) {
				var currentClip = boxArray[i]
				currentClip.addEventListener(MoveObject.MOVE_COMPLETE,positionBoxes)
				currentClip.addEventListener(MoveObject.IN_MOVE,positionBoxes)
				if ((newX + currentClip.width + spc) > multiBoxWidth) {
					newX = 0
					currentRowArray = new Array
					currentRowArray.push(currentClip)
					rowWidth = currentClip.width + spc
					newY += g + spc
					g = centerRow()
					} else {
					currentRowArray.push(currentClip)
					rowWidth += currentClip.width + spc
					g = centerRow()
				}
				boxHolder.addChild(currentClip)
				newX += currentClip.width + spc
			}
		}
		public function centerRow(){
			var offset = (this.width - (rowWidth-spc))/2
			var newX
			if (centerRV) {
				newX = offset
				} else {
				newX = 0
			}
			var tallest = 0
			var currentClip:MoveObject
			for (var i = 0 ; i < currentRowArray.length;i++) {
				currentClip = currentRowArray[i]
				currentClip.height > tallest ? tallest = currentClip.height : null
				currentClip.moveTo(newX,null)
				newX += currentRowArray[i].width + spc
			}
			for (var p = 0 ; p < currentRowArray.length;p++) {
				currentClip = currentRowArray[p]
				var centerY
				if (centerRH) {
					centerY = (tallest/2) - (currentClip.height/2) + newY
				} else {
					centerY = newY
				}
				currentClip.moveTo(null,centerY)
			}
			return tallest
		}
		public function positionBoxes(e:Event){
			if (centerCV) {
				boxHolder.moveTo(0,(this.height/2)-(boxHolder.height/2))
				} else {
				boxHolder.moveTo(0,0)
			}
		}
		public function set centerRowsHorizontally(value:Boolean):void{
			centerRH = value
			layoutBoxes()
		}
		public function set centerRowsVertically(value:Boolean):void{
			centerRV = value
			layoutBoxes()
		}
		public function get centerRowsHorizontally():Boolean{
			return centerRH
		}
		public function set spacing(value:int):void{
			spc = value
			layoutBoxes()
		}
		public function get spacing():int{
			return spc
		}
		public function get centerRowsVertically():Boolean{
			return centerRV
		}
		public function set centerContentVertically(value:Boolean):void{
			centerCV = value
			layoutBoxes()
		}
		public function get centerContentVertically():Boolean{
			return centerCV
		}		
		public override function set width(width:Number):void{
			multiBoxWidth = width
			background.matchSizeOf(multiBoxWidth,multiBoxHeight)
			background.width = multiBoxWidth
			foreground.width = multiBoxWidth
			layoutBoxes()
		}
		public override function set height(height:Number):void{
			multiBoxHeight = height
			background.matchSizeOf(multiBoxWidth,multiBoxHeight)
			foreground.height = multiBoxHeight
			layoutBoxes()
		}
	
		public override function get width():Number{
			return multiBoxWidth
		}
		public override function get height():Number{
			return multiBoxHeight
		}

	}
	
}
