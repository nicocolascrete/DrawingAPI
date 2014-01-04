package utils {
	import flash.geom.Point;

	/**
	 * @author n.crete
	 */
	public class PressurePoint {
		public var point : Point;
		public var pressure : int;
		
		
		
		// name :: ABrush
		// description ::
		public function PressurePoint( A : Point, p : int = 1 ):void{
			point = A;
			pressure = p;
		}
	}
}
