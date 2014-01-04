package sprays {
	import sanglier.tools.UMath;

	import com.greensock.TweenLite;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author nicolascrete
	 */
	public class ASprayParticle extends Sprite {
		protected var _bmp : Bitmap;
		protected var _bPermanent : Boolean = false;
		
		
		public function ASprayParticle() {
			alpha = 0;
		}
		
		public function draw( bmpData : BitmapData ) : void {
			_bmp = new Bitmap( bmpData, "auto", true );
			_bmp.x = - bmpData.width / 2;
			_bmp.y = - bmpData.height / 2;
			//__bmp.cacheAsBitmap = true;
			addChild( _bmp );
		}

		public function move( angle : Number, distance : Number, durationMove : Number, waiterMove : Number, durationAlpha : Number ) : void {
//			trace( this, "move", angle, distance, duration );

			

//			this.cacheAsBitmap = true;

			var B : Point = UMath.translatePoint(new Point( x, y ), angle, distance );
//			trace( this, "move", B.x, B.y );
			TweenLite.to( this, Math.random() * 0.2, { alpha : 1 } );
			TweenLite.to( this, durationMove, { x:B.x, y:B.y, overwrite:false } );
//			TweenLite.to( this, durationAlpha, { delay:waiterMove, alpha : 0, onComplete:__moveComplete, overwrite:false } );
		}
		protected function __moveComplete( ) : void {
//			trace( this, "__moveComplete" );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		//----------------------------
		//		GETTER / SETTER
		//----------------------------
		public function get permanent():Boolean{
			return _bPermanent;
		}
		
		
		// name :: flush
		// description ::
		public function flush():void{
			if( _bmp != null ){
				_bmp.bitmapData.dispose();
			}
		}
	}
}
