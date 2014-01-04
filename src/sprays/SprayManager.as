package sprays {
	import drawingAPI.utils.PressurePoint;

	import sanglier.tools.UMath;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author nicolascrete
	 */
	public class SprayManager extends Sprite {
		
		//-------------------------------
		//		STATIC
		//-------------------------------
		
		public static var LINE_MODE : String = "line_mode";
		public static var LINE_MODE_PRESSURE : String = "line_mode_pressure";
		public static var POINT_MODE : String = "point_mode";
		
		
		
		//-------------------------------
		//
		//-------------------------------
		private var __aPointMouse : Array;
		private var __aParticle : Array;
		private var __mode : String;
		private var __density : int;
		private var __hardness : int;
		private var __maxParticle : int;
		private var __distance : int;
		private var __amplitude : int;
		private var __durationMove : Number;
		private var __waiterAlpha : Number;
		private var __durationAlpha : Number;
		private var __idLastDrawSegement : int = 0;
		private var __localPressure : int = 0;
		private var __classSpray : Class;
		
		private var __bmpData : BitmapData;
		private var __bmpPrint : Bitmap;
		private var __bmpDataPrint : BitmapData;
		private var __aPool : Array;
		private var __drawPrint : Sprite;
		private var __preDrawPrint : Sprite;
		
		
		public function SprayManager( pMode : String = "line_mode", pDensity : int = 10, pHardness : int = 1, pDistance : int = 20, pAmplitude : int = 10, pDurationMove : Number = 1, pWaiterAlpha : Number = 0.5 ) {
			super();
			__aPointMouse = [];
			__aParticle = [];
			__aPool = [];
			
			__mode = pMode;
			__density = pDensity;
			__hardness = pHardness;
			__distance = pDistance;
			__amplitude = pAmplitude;
			__durationMove = pDurationMove;
			__waiterAlpha = pWaiterAlpha;
			__durationAlpha = __durationMove - __waiterAlpha;
			
			__maxParticle = 500;
		}

		//----------------------------
		//		ADD POINT
		//----------------------------
		
		// name :: addPoints
		// description ::
		public function addPoints( a : Array ) : void{
			for( var i : int = 0; i < a.length; i++ ){
				var A : PressurePoint = PressurePoint( a[ i ] );
				addPoint( A.point, A.pressure );
			}
		}
		// name :: addPoint
		// description ::
		public function addPoint( A : Point, pressure : Number = 1 ) : void{
			if( __aPointMouse.length == 0 || A.x != __aPointMouse[ __aPointMouse.length - 1 ].point.x || A.y != __aPointMouse[ __aPointMouse.length - 1 ].point.y ){
				__aPointMouse.push( new PressurePoint( A, pressure ) );
			}
		}
		
		public function addAssetParticle( s : Bitmap ) : void{
			__aParticle.push( s );
		}
		
		
		//----------------------------
		//		DRAW
		//----------------------------
		
		// name :: draw
		// description ::
		public function drawComplete():void{
//			trace( this, "drawComplete" );
			for( var i : int = 0; i < __aPointMouse.length-1; i++ ){
				if( __mode == LINE_MODE ){
					//si type egal line
					__drawSegement( __aPointMouse[ i ], __aPointMouse[ i + 1 ] );
				}else{
					//si type egal point
					__drawPoint( __aPointMouse[ i ] );
				}
			}
		}
		// name :: drawLastStep
		// description ::
		public function drawLastStep():void{
//			trace( this , "drawLastStep :::" , __mode, __idLastDrawSegement, __aPointMouse.length );
			if( __mode == LINE_MODE ){//si type egal line
				if( __idLastDrawSegement < __aPointMouse.length && __aPointMouse.length > 1 ){
					__idLastDrawSegement = __aPointMouse.length;
					__drawSegement( __aPointMouse[ __idLastDrawSegement - 2 ], __aPointMouse[ __idLastDrawSegement - 1 ] );
				}
			}else if( __mode == LINE_MODE_PRESSURE ){
				if( __aPointMouse.length >= 4 ){
					if( __idLastDrawSegement < __aPointMouse.length ){
						__idLastDrawSegement = __aPointMouse.length;
						__drawSegmentPressure( __aPointMouse[ __aPointMouse.length - 4 ], __aPointMouse[ __aPointMouse.length - 3 ], __aPointMouse[ __aPointMouse.length - 2 ], __aPointMouse[ __aPointMouse.length - 1 ] );
					}
				}
			}else{//si type egal point
				if( __idLastDrawSegement < __aPointMouse.length && __aPointMouse.length > 0 ){
					__idLastDrawSegement = __aPointMouse.length;
					__drawPoint( __aPointMouse[ __idLastDrawSegement - 1 ] );
				}
			}
		}
		private function __drawSegement( A : PressurePoint, B : PressurePoint ) : void{
//			trace( this, "_drawSegment", A, B );
			var angleAB : Number = Math.PI / 2 - UMath.rotationBetween2Point( A.point, B.point );
			var distanceAB : Number = UMath.distanceBetween2Point( A.point, B.point );
			
			var n : int = 0;
			while( n < __density ){
				var angleParticle : Number = Math.random() * Math.PI * 2;
				angleParticle += UMath.random( -Math.PI/4, Math.PI/4 );
				
				var particle : ASprayParticle;
				
				if( __aPool.length > 0 ){
					particle = __aPool[ 0 ];
					__aPool.splice( 0, 1 );
				}else{
					particle = ASprayParticle( new classSpray() );
				}
				
				var P : Point =	UMath.translatePoint( A.point, angleAB, Math.random() * distanceAB );
				particle.x = P.x;
				particle.y = P.y;
				particle.addEventListener( Event.COMPLETE, __removeParticle, false, 0, true );
//				particle.draw( __bmpData );
				addChild( particle ) ;
				particle.move( angleParticle, Math.floor( __distance - __amplitude + Math.random() * __amplitude ), __durationMove, __waiterAlpha, __durationAlpha );
				
				n ++;
			}
//			trace( this , "__drawSegement :::" , __aPool.length );
		}
		private function __drawSegmentPressure( A : PressurePoint, B : PressurePoint, C : PressurePoint, D : PressurePoint ) : void {
//			trace( this, "_drawSegment", A, B );
			var angleBC : Number = Math.PI / 2 - UMath.rotationBetween2Point( B.point, C.point );
			var distanceBC : Number = UMath.distanceBetween2Point( B.point, C.point );
			
			var userPressureB : Number = ( - ( __hardness / Math.PI ) * ( UMath.rotationBetween3Point( A.point, B.point, C.point ) ) ) + __hardness;
			var userPressureC : Number = ( - ( __hardness / Math.PI ) * ( UMath.rotationBetween3Point( B.point, C.point, D.point ) ) ) + __hardness;
			var userPressure : int = ( userPressureB + userPressureC ) / 2;
			__localPressure = Math.floor( __localPressure + ( userPressure - __localPressure ) * 0.5 );

			var n : int = 0;
			while( n < __density ){
				var angleParticle : Number = Math.random() * Math.PI * 2;
				angleParticle += UMath.random( -Math.PI/4, Math.PI/4 );
				
				var particle : ASprayParticle;
				
				if( __aPool.length > 0 ){
					particle = __aPool[ 0 ];
					__aPool.splice( 0, 1 );
				}else{
					particle = ASprayParticle( new classSpray() );
				}
				
				var P : Point =	UMath.translatePoint( B.point, angleBC, Math.random() * distanceBC );
				particle.x = P.x;
				particle.y = P.y;
				particle.addEventListener( Event.COMPLETE, __removeParticle, false, 0, true );
//				particle.draw( __bmpData );
				addChild( particle ) ;
				particle.move( angleParticle, Math.floor( ( __distance * __localPressure ) - __amplitude + Math.random() * __amplitude ), __durationMove, __waiterAlpha, __durationAlpha );
				
				n ++;
			}
		}
		private function __drawPoint( A : PressurePoint ) : void{
			for( var i : int = 0; i < __density; i++ ){
				var angleParticle : Number = Math.random() * Math.PI * 2;
				var particle : ASprayParticle = ASprayParticle( new classSpray() );
				particle.x = A.point.x;
				particle.y = A.point.y;
				particle.addEventListener( Event.COMPLETE, __removeParticle, false, 0, true );
				addChild( particle ) ;
				
				particle.move( angleParticle, Math.floor( __distance - __amplitude / 2 + Math.random() * __amplitude ), __durationMove, __waiterAlpha, __durationAlpha);
			}
		}
		
		//----------------------------
		//		PARTICLE
		//----------------------------
		
		
		// name :: print
		// description ::
		private function __print( particule : ASprayParticle ) : void{
//			trace( this , "__print :::" , particule, __bmpPrint, __bmpDataPrint );

			if( __bmpPrint == null ){
				__bmpDataPrint = new BitmapData( 990, 550, true, 0x000000 );
				__bmpPrint = new Bitmap( __bmpDataPrint, "auto", true);
				addChild( __bmpPrint );
				
				__drawPrint = new Sprite();
				addChild(__drawPrint);
				__preDrawPrint = new Sprite();
				addChild(__preDrawPrint);
			}
			__preDrawPrint.addChild( particule );
			__bmpDataPrint.draw( __preDrawPrint );
			addChild( particule );
		}
		
		private function __removeParticle(event : Event) : void {
			var particle : ASprayParticle = ASprayParticle( event.currentTarget );
			if( particle.permanent ){
				__print( particle );
			}
			particle.removeEventListener( Event.COMPLETE, __removeParticle );
			__aPool.push( particle );
			particle.flush();
			removeChild( particle );
		}
		// name :: clear
		// description ::
		public function clear():void{
		
		}
		
		
		//----------------------------
		//		GETTER / SETTER
		//----------------------------
		public function get mode():String{
			return __mode;
		}
		public function set mode( value : String ):void{
			__mode = value;
		}
		public function get classSpray():Class{
			return __classSpray;
		}
		public function set classSpray( value : Class ):void{
			__classSpray = value;
		}
		public function get density():int{
			return __density;
		}
		public function set density( value : int ):void{
			__density = value;
		}
		public function get distance():int{
			return __distance;
		}
		public function set distance( value : int ):void{
			__distance = value;
		}
		public function get amplitude():int{
			return __amplitude;
		}
		public function set amplitude( value : int ):void{
			__amplitude = value;
		}
		public function get durationMove():Number{
			return __durationMove;
		}
		public function set durationMove( value : Number ):void{
			__durationMove = value;
		}
		public function get waiterAlpha():Number{
			return __waiterAlpha;
		}
		public function set waiterAlpha( value : Number ):void{
			__waiterAlpha = value;
		}
		public function get hardness():int{
			return __hardness;
		}
		public function set hardness( value : int ):void{
			__hardness = value;
		}
	}
}
