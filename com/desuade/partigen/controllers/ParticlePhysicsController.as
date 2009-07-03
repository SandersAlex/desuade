/*
This software is distributed under the MIT License.

Copyright (c) 2009 Desuade (http://desuade.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.desuade.partigen.controllers {
	
	import com.desuade.motion.controllers.*;
	import com.desuade.motion.tweens.*;
	
	/**
	 *  Used to configure PhysicsMultiControllers for the particles
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  02.07.2009
	 */
	public dynamic class ParticlePhysicsController extends Object {
		
		/**
		 *	The boolean flip (for cartesian reversal) value to be passed to the internal 'physics' object.
		 *	@see com.desuade.motion.physics.BasicPhysics#flip
		 */
		public var flip:Boolean = false;
		
		/**
		 *	If this is set to true, the physics object will use the emitter's angle value. If false, no angle will be used in calculating the initial velocity.
		 */
		public var useAngle:Boolean = true;
		
		/**
		 *	@private
		 */
		protected var _duration:Number;
		
		/**
		 *	This is like a PhysicsMultiController from the Motion Package, but is used as a placeholder to configure emitters.
		 *	
		 *	ParticlePhysicsControllers create PhysicsMultiControllers on each particle that's created, allowing the particles to change over their lives with physics.
		 *	
		 *	Each one has 3 sub ParticleTweenControllers: velocity, acceleration, friction. These can each be configured like normal ParticleTweenControllers.
		 *	
		 *	Using the addPhysics() method is recommended over calling this directly.
		 *	
		 *	@param	duration	 The entire duration for the controller. If this is 0, the duration will be set to the particle's life.
		 *	@param	containerClass	 The class to use for Keyframes. Null will use the default.
		 *	@param	tweenClass	 The class to use for tweening on the controller. Null will use the default.
		 */
		public function ParticlePhysicsController($duration:Number, $containerClass:Class = null, $tweenClass:Class = null) {
			super();
			_duration = $duration;
			this.velocity = new ParticleTweenController($duration, $containerClass, $tweenClass);
			this.acceleration = new ParticleTweenController($duration, $containerClass, $tweenClass);
			this.friction = new ParticleTweenController($duration, $containerClass, $tweenClass);
			this.velocity.keyframes.precision = 3;
			this.acceleration.keyframes.precision = 3;
			this.friction.keyframes.precision = 3;
		}
		
		/**
		 *	This sets/gets the duration for all the ParticleTweenControllers inside (velocity, acceleration, friction)
		 */
		public function get duration():Number{
			return _duration;
		}
		
		/**
		 *	@private
		 */
		public function set duration($value:Number):void {
			_duration = $value;
			for (var p:String in this) {
				this[p].duration = $value;
			}
		}
	
	}

}
