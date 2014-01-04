package utils {
	import fl.motion.BezierSegment;

	import flash.display.Shape;
	import flash.geom.Point;

	/**
	 * @author nicolascrete
	 */
	public class UBezier {
		public static function drawCubicBezier( shape : Shape, A : Point, anchorA : Point, anchorB : Point, B : Point, renderQuality : int = 1 ) : void{
			//genere courbe de bézier
			var bezier : BezierSegment = new BezierSegment( A, anchorA, anchorB, B );
			
			shape.graphics.moveTo( A.x, A.y );
			
			var n : Number = 0;
			var inc : Number = 1 / renderQuality;
			while( n <= 1  ){
				var p : Point = bezier.getValue( n );
				shape.graphics.lineTo( p.x, p.y );
				n += inc;
			}
			
//		    graphics.beginFill(0x003366);
//		    graphics.drawPath(star_commands, star_coord);

		}
	}
}
