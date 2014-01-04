package lines.line {
	import drawingAPI.lines.ALine;
	import drawingAPI.utils.PressurePoint;
	import drawingAPI.utils.UBezier;

	import sanglier.tools.UMath;

	import flash.display.Shape;
	import flash.geom.Point;

	/**
	 * @author nicolascrete
	 */
	public class AdvancedLine extends ALine {
		protected var _localPressure : Number = 0;
		protected var _bOpenLine : Boolean = true;
		protected var _bCloseLine : Boolean = false;
		private var _thicknessBegin : int;
		private var _thicknessEnd : int;
		private var _smoothing : int;
		
		private var B1 : Point;
		private var B2 : Point;
		
		
		// name :: AdvancedLine
		// description ::
		public function AdvancedLine( pThickness : int = 1, pColor : int = 0x000000, pSmoothing : int = 4, pContinuity : Number = 1, pRespectOriginalLine : int = 0, pHardness : Number = 0, pQuality : int = 5, pThicknessBegin : int = 0, pThicknessEnd : int = 0 ) : void {
			super();
			thickness = pThickness;
			color = pColor;
			continuity = pContinuity;
			respectOriginalLine = pRespectOriginalLine;
			hardness = pHardness;
			renderQuality = pQuality;
			thicknessBegin = pThicknessBegin;
			thicknessEnd = pThicknessEnd;
			smoothing = pSmoothing;
		}

		
		//----------------------------
		//		ADD POINT
		//----------------------------
		
		// name :: addPoint
		// description ::
		public override function addPoint( A : Point, pressure : Number = 1 ):void{
			if( _aPointMouse.length == 0 || A.x != _aPointMouse[ _aPointMouse.length - 1 ].point.x || A.y != _aPointMouse[ _aPointMouse.length - 1 ].point.y ){
				super.addPoint( A, pressure );
				var B : Point = new Point( UMath.random( A.x - _respectOriginalLine / 2, A.x + _respectOriginalLine / 2 ), UMath.random( A.y - _respectOriginalLine / 2, A.y + _respectOriginalLine / 2 ));
				_aPointLine.push( new PressurePoint( B, pressure ) );
			}
		}
		
		
		//----------------------------
		//		DRAW
		//----------------------------
		
		// name :: draw
		// description ::
		public override function drawComplete():void{
			for( var i:int = 3; i < _aPointLine.length; i++ ){
				__drawSegment( _aPointLine[ i - 3 ], _aPointLine[ i - 2 ], _aPointLine[ i - 1 ], _aPointLine[ i ] );
			}
		}
		// name :: drawLastStep
		// description ::
		public override function drawLastStep():void{
			if( _aPointLine.length >= 4 ){
				if( _idLastDrawSegement < _aPointLine.length ){
					_idLastDrawSegement = _aPointLine.length;
					__drawSegment( _aPointLine[ _aPointLine.length - 4 ], _aPointLine[ _aPointLine.length - 3 ], _aPointLine[ _aPointLine.length - 2 ], _aPointLine[ _aPointLine.length - 1 ] );
				}
			}
		}
		// name :: draw
		// description :: dessine le segement entre le point B et C
		protected function __drawSegment( A : PressurePoint, B : PressurePoint, C : PressurePoint, D : PressurePoint ):void{
			//calcul angle tangente en B
			var angleTanB : Number = Math.PI / 2 - UMath.rotationBetween2Point( A.point, C.point );
			
			if( _bOpenLine ){
				_bOpenLine = false;
				//B1 = B2 = B.point;
				B1 = UMath.translatePoint( B.point, angleTanB + Math.PI / 2, - _thicknessBegin / 2 );
				B2 = UMath.translatePoint( B.point, angleTanB + Math.PI / 2, _thicknessBegin / 2 );
			}
			//calcul la longueur de la tangente en B
			var distanceAB : Number = UMath.distanceBetween2Point( A.point, B.point ) / 4;
			//calcul les points d'ancrage
			var anchorB1 : Point = UMath.translatePoint( B1, angleTanB, distanceAB );
			var anchorB2 : Point = UMath.translatePoint( B2, angleTanB, distanceAB );
			
			//caclul angle tangente en C
			var angleTanC : Number = Math.PI / 2 - UMath.rotationBetween2Point( B.point, D.point );
			//calcul de la pression en C en fonction de l'angle, de l'épaisseur et de la pression du point C
			var userPressureC : Number = ( - ( _hardness / Math.PI ) * ( UMath.rotationBetween3Point( B.point, C.point, D.point ) ) ) + _hardness;
//			if( userPressureC ){ // Sécurité
				_localPressure = Math.floor( _localPressure + ( userPressureC - _localPressure ) / _smoothing );
//			}
			if( _localPressure < 1 ){
				_localPressure = 1;
			}
			
			var C1 : Point;
			var C2 : Point;
			if( _bCloseLine ){
				_bCloseLine = false;
				//C1 = C2 = C.point;
				C1 = UMath.translatePoint( C.point, angleTanC + Math.PI / 2, - _thicknessEnd / 2 );
				C2 = UMath.translatePoint( C.point, angleTanC + Math.PI / 2, _thicknessEnd / 2 );
			}else{
				C1 = UMath.translatePoint( C.point, angleTanC + Math.PI / 2, - _thickness / 2 * ( _localPressure ) - ( C.pressure / 2 ) );
				C2 = UMath.translatePoint( C.point, angleTanC + Math.PI / 2, _thickness / 2 * ( _localPressure ) + ( C.pressure / 2 ) );
			}
			//calcul la longueur de la tangente en C
			var distanceCD : Number = UMath.distanceBetween2Point( C.point, D.point ) / 4;
			//calcul les points d'ancrage
			var anchorC1 : Point = UMath.translatePoint( C1, angleTanC, -distanceCD );
			var anchorC2 : Point = UMath.translatePoint( C2, angleTanC, -distanceCD );
			
			//dessine la courbe
			var line : Shape = new Shape();
			line.graphics.beginFill( _color );
			line.graphics.moveTo( B1.x, B1.y );
			
			//dessine le segment
			UBezier.drawCubicBezier( line, B1, anchorB1, anchorC1, C1, renderQuality );
			line.graphics.lineTo( C2.x, C2.y );
			UBezier.drawCubicBezier( line, C2, anchorC2, anchorB2, B2, renderQuality );
			line.graphics.lineTo( B1.x, B1.y );
			line.graphics.endFill();
			
			B1 = C1;
			B2 = C2;
			
			addChild( line );
			_aLine.push( line );
		}
		// name :: clear
		// description ::
		public override function clear():void{
			for( var i : int = 0; i < _aLine.length; i++ ){
				removeChild( _aLine[i] );
				_aLine[i].graphics.clear();
				_aLine[i] = null;		
			}
			_aLine = null;
		}
		
		
		
		//----------------------------
		//		GETTER / SETTER
		//----------------------------
		public override function set hardness( value : Number ):void{
			_hardness = value * 20;
		}
		public function set thicknessBegin( value : int ):void {
			_thicknessBegin = value;
		}
		public function set thicknessEnd( value : int ):void {
			_thicknessEnd = value;
		}
		public function set smoothing( value : int ):void {
			_smoothing = value;
		}
	}
}
