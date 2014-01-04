package lines {
	import drawingAPI.utils.PressurePoint;
	

	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author nicolascrete
	 */
	public class ALine extends Sprite{
		//----------------------------
		//		
		//----------------------------
		protected var _aPointMouse : Array;
		protected var _aPointLine : Array;
		protected var _aLine : Array;
		protected var _idLastDrawSegement : int = 0;
		
		//----------------------------
		//		PROPERTY
		//----------------------------
		protected var _thickness : int;//épaisseur de la ligne en pixel
		protected var _color : int;//couleur de la ligne
		protected var _hardness : Number;//dureté de la ligne de 0 à l'infini
		protected var _continuity : Number;//continuité de la ligne en prc de 0 à 1
		protected var _respectOriginalLine : int;//val
		protected var _renderQuality : int;
		
		//----------------------------
		//
		//----------------------------
		protected var _duration : Number;
		protected var _delay : Number;//continuité de la ligne en prc de 0 à 1
		

		// name :: ClassicLine
		// description ::
		public function ALine():void{
			_aPointMouse = [];
			_aPointLine = [];
			_aLine = [];
		}
		
		//----------------------------
		//		ADD POINT
		//----------------------------
		
		// name :: addPoints
		// description ::
		public function addPoints( a : Array ):void{
			for( var i : int = 0; i < a.length; i++ ){
				var A : PressurePoint = PressurePoint( a[ i ] );
				addPoint( A.point, A.pressure );
			}
		}
		// name :: addPoint
		// description ::
		public function addPoint( A : Point, pressure : Number = 1 ):void{
			_aPointMouse.push( new PressurePoint(A, pressure) );
		}
		
		
		//----------------------------
		//		DRAW
		//----------------------------
		
		// name :: draw
		// description ::
		public function drawComplete():void{
			
		}
		// name :: drawLastStep
		// description ::
		public function drawLastStep():void{
			
		}
		// name :: clear
		// description ::
		public function clear():void{
		
		}
		
		
		//----------------------------
		//		GETTER / SETTER
		//----------------------------
		public function get thickness():int{
			return _thickness;
		}
		public function set thickness( value : int ):void{
			_thickness = value;
		}
		public function get hardness():Number{
			return _hardness;
		}
		public function set hardness( value : Number ):void{
			_hardness = value;
		}
		public function get color():int{
			return _color;
		}
		public function set color( value : int ):void{
			_color = value;
		}
		public function get continuity():int{
			return _continuity;
		}
		public function set continuity( value : int ):void{
			_continuity = value;
		}
		public function get respectOriginalLine():int{
			return _respectOriginalLine;
		}
		public function set respectOriginalLine( value : int ):void{
			_respectOriginalLine = value;
		}
		public function get renderQuality():int{
			return _renderQuality;
		}
		public function set renderQuality( value : int ):void{
			_renderQuality = value;
		}
		public function set duration( value : Number ):void{
			_duration = value;
		}
		public function set delay( value : Number ):void{
			_delay = value;
		}
	}
}
