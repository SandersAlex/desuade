package com.desuade.partigen.pools {
	
	import com.desuade.partigen.particles.*;
	import com.desuade.debugging.*;

	public class Pool extends Object {
		
		protected var _particles:Object = {};
	
		public function Pool() {
			super();
			Debug.output('partigen', 20003);
		}
		
		public function addParticle($particleClass:Class):Particle {
			return null;
		}
		
		public function removeParticle($particle:Particle):void {
			//
		}
	
	}

}