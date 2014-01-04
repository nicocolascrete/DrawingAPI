package lines.line {
	import com.greensock.TweenLite;
	import drawingAPI.lines.ALine;
	import drawingAPI.utils.UBezier;

	import sanglier.tools.UMath;

	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.geom.Point;

	/**
	 * @author n.crete
	 */
	public class SimpleLine extends ALine{
		protected var _lineScaleMode : String;

		
		// name :: SimpleLine
		// description ::
		public function SimpleLine( pThickness : int = 1, pColor : int = 0x000000, pContinuity : Number = 1, pRespectOriginalLine : int = 0, pLineScaleMode : String = LineScaleMode.NORMAL, pQuality : int = 5 ) : void {
			super();
			thickness = pThickness;
			color = pColor;
			continuity = pContinuity;
			respectOriginalLine = pRespectOriginalLine;
			lineScaleMode = pLineScaleMode;
			renderQuality = pQuality;
		}
		
		
		//----------------------------
		//		ADD POINT
		//----------------------------
		
		// name :: addPoints
		// description ::
		public override function addPoints( a : Array ):void{
			for( var i : int = 0; i < a.length; i++ ){
				addPoint( a[ i ] );
			}
		}
		// name :: addPoint
		// description ::
		public override function addPoint( A : Point, pressure : Number = 1 ):void{
			if( _aPointMouse.length == 0 || A.x != _aPointMouse[ _aPointMouse.length - 1 ].point.x || A.y != _aPointMouse[ _aPointMouse.length - 1 ].point.y ){
				super.addPoint( A, pressure );
				var B : Point = new Point( UMath.random( A.x - _respectOriginalLine / 2, A.x + _respectOriginalLine / 2 ), UMath.random( A.y - _respectOriginalLine / 2, A.y + _respectOriginalLine / 2 ));
				_aPointLine.push( B );
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
					var line : Shape = __drawSegment( _aPointLine[ _aPointLine.length - 4 ], _aPointLine[ _aPointLine.length - 3 ], _aPointLine[ _aPointLine.length - 2 ], _aPointLine[ _aPointLine.length - 1 ] );
					TweenLite.to(line, _duration, {alpha:0, delay:_delay});
//					TweenLite.to(line, 0.2, {alpha:0, delay:0.05});
//					TweenLite.to(line, 0.6, {alpha:0, delay:0.1});
				}
			}
		}
		// name :: draw
		// description :: dessine le segement entre le point B et C
		private function __drawSegment( A : Point, B : Point, C : Point, D : Point, quality : int = 10 ):Shape{
			//calcul angle tangente en B
			var angleTanB : Number = Math.PI / 2 - UMath.rotationBetween2Point( A, C );
			//calcul la longueur de la tangente en B
			var distanceAB : Number = UMath.distanceBetween2Point( A, B ) / 4;
			//caclul angle tangente en C
			var angleTanC : Number = Math.PI / 2 - UMath.rotationBetween2Point( B, D );
			//calcul la longueur de la tangente en C
			var distanceCD : Number = UMath.distanceBetween2Point( C, D ) / 4;
			
			//calcul les points d'ancrage
			var anchorB : Point = UMath.translatePoint( B, angleTanB, distanceAB );
			var anchorC : Point = UMath.translatePoint( C, angleTanC, -distanceCD );
			
			//dessine la courbe
			var line : Shape = new Shape();
			line.graphics.lineStyle( _thickness, _color, 1, false, _lineScaleMode );
			//line.graphics.moveTo( B.x, B.y );
			//dessine le segment
			UBezier.drawCubicBezier( line, B, anchorB, anchorC, C, renderQuality );
			
			addChild( line );
			//ajoute la courbe au tableau
			_aLine.push( line );
			
			return line;
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
		public function get lineScaleMode():String{
			return _lineScaleMode;
		}
		public function set lineScaleMode( value : String ):void{
			_lineScaleMode = value;
		}
	}
}
