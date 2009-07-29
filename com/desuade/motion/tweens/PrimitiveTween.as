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

package com.desuade.motion.tweens {
	
	import com.desuade.motion.eases.*;
	import com.desuade.motion.bases.*;
	import com.desuade.debugging.*

	/**
	 *  This is the most basic tween with no management. Users should not create this directly, instead use BasicTween.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  01.05.2009
	 */
	public class PrimitiveTween extends BasePrimitive {
		
		/**
		 *	The property to tween on the target.
		 */
		public var property:String;
		
		/**
		 *	The new (end) value the property will be tweened to.
		 */
		public var value:Number;
		
		/**
		 *	How long the tween will last in ms.
		 */
		public var duration:int;
		
		/**
		 *	What easing equation to use to tween.
		 */
		public var ease:Function;
		
		/**
		 *	@private
		 */
		internal var startvalue:Number;
		
		/**
		 *	@private
		 */
		internal var difvalue:Number;
		
		/**
		 *	This creates a new, raw PrimitiveTween. Users should use the Basic tweens instead of creating this directly.
		 *	
		 *	@param	target	 The target object to perform the tween on.
		 *	@param	property	 The property to tween on the target.
		 *	@param	value	 The new (end) value the property will be tweened to.
		 *	@param	duration	 How long the tween will last in ms.
		 *	@param	ease	 What easing equation to use to tween.
		 *	
		 *	@see	#target
		 *	@see	#property
		 *	@see	#value
		 *	@see	#duration
		 *	@see	#ease
		 *	
		 */
		public function PrimitiveTween($target:Object, $property:String, $value:Number, $duration:int, $ease:* = null) {
			super($target);
			duration = $duration, ease = makeEase($ease) || Easing.linear
			if($property != null) {
				property = $property, value = $value, startvalue = $target[$property];
				difvalue = (startvalue > value) ? (value-startvalue) : -(startvalue-value);
			}
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function render($time:int):void {
			$time -= starttime;
			if($time >= duration){
				target[property] = value;
				end();
			} else {
				target[property] = ease($time, startvalue, difvalue, duration);
				updateFunc(this);
			}
		}
		
		/**
		 *	@private
		 */
		protected function makeEase($ease:*):Function {
			if(typeof $ease == 'string'){
				return Easing[$ease];
			} else {
				Debug.output('motion', 50004);
				return $ease;
			}
		}
		
	}

}
