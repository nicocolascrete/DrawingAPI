package lines {
	
	import flash.geom.Point;

	/**
	 * @author nicolascrete
	 */
	public class LineManager extends ALine {
		protected var _aLines : Array;
		
		// name :: MultiLine
		// description ::
		public function LineManager( a : Array = null ):void{
			super();
			_aLines = [];
			if( a != null ){
				for( var i : int = 0; i < a.length; i++ ){
					addLine( a[ i ] );
				}
			}
		}
		
		// name :: addPoint
		// description ::
		public override function addPoint( A : Point, pressure : Number = 1 ):void{
			if( _aPointMouse.length == 0 || A.x != _aPointMouse[ _aPointMouse.length - 1 ].point.x || A.y != _aPointMouse[ _aPointMouse.length - 1 ].point.y ){
				super.addPoint( A, pressure );
				for( var i : int = 0; i < _aLines.length; i++ ){
					ALine( _aLines[ i ] ).addPoint( A, pressure );
				}
			}
		}
		
		public function addLine( line : ALine ) : void{
			_aLines.push( line );
			addChild( line );
		}
		
		// name :: draw
		// description ::
		public override function drawComplete():void{
		}
		
		// name :: drawLastStep
		// description ::
		public override function drawLastStep():void{
			if( _idLastDrawSegement < _aPointMouse.length ){
				_idLastDrawSegement = _aPointMouse.length;
				for( var i : int = 0; i < _aLines.length; i++ ){
						ALine( _aLines[ i ] ).drawLastStep();
				}
			}
		}
		
		// name :: clear
		// description ::
		public override function clear():void{
		}
	}
}
