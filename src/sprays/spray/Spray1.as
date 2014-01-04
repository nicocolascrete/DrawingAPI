package sprays.spray {
	import drawingAPI.sprays.ASprayParticle;

	import sanglier.tools.UMath;

	import com.greensock.TweenLite;

	import flash.geom.Point;

	/**
	 * @author n.crete
	 */
	public class Spray1 extends ASprayParticle {
		public function Spray1() {
			super();
		}
		override public function move( angle : Number, distance : Number, durationMove : Number, waiterMove : Number, durationAlpha : Number ) : void {

			var B : Point = UMath.translatePoint(new Point( x, y ), angle, distance );
//			trace( this, "move", B.x, B.y );
			TweenLite.to( this, Math.random() * 0.2, { alpha : 1 } );
			TweenLite.to( this, durationMove, { x:B.x, y:B.y, overwrite:false } );
			TweenLite.to( this, durationAlpha, { delay:waiterMove, alpha : 0, onComplete:__moveComplete, overwrite:false } );
		}
	}
}
