package com.desuade.partigen.controllers {
	
	import com.desuade.partigen.debug.*
	import com.desuade.partigen.proxies.*
	import com.desuade.partigen.utils.*

	public class ValueController extends Object {
	
		public var points:PointsContainer;
		public var target:Object;
		public var property:String;
		public var duration:Number;
		private var _active:Boolean = false;
		public function get active():Boolean{
			return _active;
		}
	
		public function ValueController(target:Object, property:String, duration:Number){
			super();
			this.target = target;
			this.property = property;
			this.duration = duration;
			points = new PointsContainer(target[property]);
		}
		
		//public methods
		
		public function addPoint(value:*, position:Number, ease:* = 'linear', label:String = 'point'):Object {
			return points.addPoint(value, position, ease, label);
		}
		
		public function removePoint(label:String):void {
			points.removePoint(label);
		}
		
		public function start():void {
			var ta:Array = createTweens();
			ta[ta.length-1].func = this.tweenEnd;
			TweenProxy.sequence(ta);
			_active = true;
		}
		
		public function stop():void {
			_active = false;
		}
		
		public function getPoints():Array {
			return points.getSortedPoints();
		}
		
		public function tweenEnd(... args):void {
			_active = false;
			Debug.output('develop', 1003, [target.name, property]);
		}
		//private methods
		
		private function calculateDuration(previous:Number, position:Number):Number {
			return duration*(position-previous);
		}

		private function createTweens():Array {
			var pa:Array = points.getSortedPoints();
			var ta:Array = [];
			//skip beginning point (i=1), it gets set and doesn't need to be tweened to initial value
			for (var i:int = 1; i < pa.length; i++) {
				var tmo:Object = {target:target, ease:points[pa[i]].ease, duration:calculateDuration(points[pa[i-1]].position, points[pa[i]].position), delay:0};
				tmo[property] = (points[pa[i]].value is Random) ? points[pa[i]].value.randomValue : points[pa[i]].value;
				ta.push(tmo);
			}
			return ta;
		}
	
	}

}

