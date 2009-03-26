package com.desuade.partigen.renderers {
	
	import flash.display.*;
	
	import com.desuade.partigen.particles.*;
	import com.desuade.debugging.*;
	
	public class StandardRenderer extends Renderer {
		
		public var target:DisplayObjectContainer;
		public var order:String;
	
		public function StandardRenderer($target:DisplayObjectContainer, $order:String = 'top') {
			super();
			order = $order;
			target = $target;
		}
		
		public override function addParticle($p:Particle):void {
			switch (order) {
				case 'top' :
					target.addChild($p);
				break;
				case 'bottom' :
					target.addChildAt($p, 0);
				break;
			}
			super.addParticle($p);
		}
		
		public override function removeParticle($p:Particle):void {
			target.removeChild($p);
			super.removeParticle($p);
		}
	
	}

}