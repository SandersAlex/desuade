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
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.desuade.debugging.*
	import com.desuade.utils.*
	import com.desuade.motion.events.*
	
	/**
	 *  Changes a property's value over time by 'tweening'. The standard tweening class to use.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  02.05.2009
	 */
	public class Tween extends BasicTween {
		
		/**
		 *	@private
		 */
		protected var _delayTimer:Timer;
		
		/**
		 *	@private
		 */
		protected var _completed:Boolean = false;
		
		/**
		 *	@private
		 */
		protected var _pausepos:Number;
		
		/**
		 *	@private
		 */
		protected var _newval:Number;
		
		/**
		 *	@private
		 */
		protected var _startvalue:Number;
		
		/**
		 *	@private
		 */
		protected var _difvalue:Number;

		/**
		 *	<p>The constructor accepts an object that has all the paramaters needed to create a new tween.</p>
		 *	<p>Paramaters for the tween object:</p>
		 *	<ul>
		 *	<li>target:Object – an object to have it's property tweened</li>
		 *	<li>property:String – the property to tween</li>
		 *	<li>value:* – the new (end) value. Passing a Number will tween it to that absolute value, passing a String will use a relative value (target.property + value) - ie: <code>{value: 100}</code> or <code>{value:"200"}</code></li>
		 *	<li>ease:Function – the easing function to use. Default is Linear.none.</li>
		 *	<li>duration:Number – how long in seconds for the tween to last</li>
		 *	<li>delay:Number – how long in seconds to delay starting the tween</li>
		 *	<li>position:Number – what position to start the tween at 0-1</li>
		 *	<li>bezier:Array – an array of bezier curve points</li>
		 *	<li>round:Boolean – round the values on update (to an int)</li>
		 *	<li>relative:Boolean – this overrides the number/string check on the value to set the value relative to the current value</li>
		 *	</ul>
		 *	
		 *	<p>Example: <code>var mt:Tween = new Tween({target:myobj, property:'x', value:50, duration:2, ease:Bounce.easeIn, delay:2, position:0, round:false, relative:true, bezier:[60, '200, -10]})</code></p>
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#property
		 *	@see	PrimitiveTween#value
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	
		 */
		public function Tween($tweenObject:Object) {
			super($tweenObject);
		}
		
		/**
		 *	<p>This is a static method that creates and starts a tween with a strict syntax.</p>
		 *	
		 *	@param	target	an object to have it's property tweened
		 *	@param	property	the property to tween
		 *	@param	value	the new (end) value. Passing a Number will tween it to that absolute value, passing a String will use a relative value (target.property + value) - ie: <code>{value: 100}</code> or <code>{value:"200"}</code>
		 *	@param	duration	how long in seconds for the tween to last
		 *	@param	ease	the easing function to use. Default is Linear.none.
		 *	@param	delay	how long in seconds to delay starting the tween
		 *	@param	round	round the values on update (to an int)
		 *	@param	position	what position to start the tween at 0-1
		 *	@param	bezier	an array of bezier curve points
		 *	
		 *	<p>Example: <code>Tween.tween(myobj, 'x', 300, 2.5, null, 0, false, 0, [100])</code></p>
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#property
		 *	@see	PrimitiveTween#value
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	
		 */
		public static function tween($target:Object, $property:String, $value:*, $duration:Number, $ease:Function = null, $delay:Number = 0, $round:Boolean = false, $position:Number = 0, $bezier:Array = null):Tween {
			var st:Tween = new Tween({target:$target, value:$value, property:$property, duration:$duration, ease:$ease, delay:$delay, round:$round, position:$position, bezier:$bezier});
			st.start();
			return st;
		}
		
		/**
		 *	This starts the tween. If the tween was previously stopped, this will resume it.
		 *	
		 *	@param	delay	 Overrides the tween's delay and uses the passed one.
		 *	@param	position	 Starts the tween at a given position 0-1.
		 *	
		 *	@return		True if the tween could be started, false if already active or has ended. Use reset() to start again.
		 *	
		 */
		public override function start($delay:Number = -1, $position:Number = -1):Boolean {
			if(!_completed && !active){
				_tweenconfig.delay = ($delay == -1) ? _tweenconfig.delay : $delay;
				if($position == -1){
					if(!isNaN(_pausepos)) _tweenconfig.position = _pausepos;
				} else {
					_tweenconfig.position = $position;
				}
				_tweenconfig.position = ($position == -1) ? _tweenconfig.position : $position;
				_active = true;
				dispatchEvent(new TweenEvent(TweenEvent.STARTED, {tween:this}));
				if(_tweenconfig.delay > 0) delayedTween(_tweenconfig.delay);
				else _tweenID = createTween(_tweenconfig);
				return true;
			} else {
				Debug.output('motion', 10005);
				return false;
			}
		}
		
		/**
		 *	This stops the currently playing tween at it's current position. Starting the tween will resume it.
		 *	
		 *	@return		True if could be stopped, false if the tween is not active or has ended.
		 */
		public override function stop():Boolean {
			if(!_completed){
				if(_tweenID != 0){
					if(!_completed){
						setPauses();
					}
					BasicTween._tweenholder[_tweenID].end();
				} else {
					_delayTimer.stop();
					dispatchEvent(new TweenEvent(TweenEvent.ENDED, {tween:this}));
				}
				return true;
			} else {
				Debug.output('motion', 10004);
				return false;
			}
		}
		
		/**
		 *	@private
		 */
		protected override function createTween($to:Object):int {
			if($to.func != undefined){
				$to.func.apply(null, $to.args);
				_completed = true;
				dispatchEvent(new TweenEvent(TweenEvent.ENDED, {tween:this}));
				return 0;
			} else {
				var pt:PrimitiveTween;
				var ftv:Object = $to.target[$to.property];
				var ntval:*;
				if(isNaN(_newval)){
					if($to.value is Random) ntval = $to.value.randomValue;
					else ntval = $to.value;
					if($to.relative === true) _newval = ftv + Number(ntval);
					else if($to.relative === false) _newval = Number(ntval);
					else _newval = (typeof ntval == 'string') ? ftv + Number(ntval) : ntval;
				}
				if($to.bezier == undefined || $to.bezier == null){
					 pt = BasicTween._tweenholder[PrimitiveTween._count] = new PrimitiveTween($to.target, $to.property, _newval, $to.duration*1000, $to.ease);
				} else {
					var newbez:Array = [];
					for (var i:int = 0; i < $to.bezier.length; i++) {
						newbez.push((typeof $to.bezier[i] == 'string') ? ftv + Number($to.bezier[i]) : $to.bezier[i]);
					}
					pt = BasicTween._tweenholder[PrimitiveTween._count] = new PrimitiveBezierTween($to.target, $to.property, _newval, $to.duration*1000, newbez, $to.ease);
				}
				pt.addEventListener(TweenEvent.ENDED, endFunc, false, 0, true);
				if($to.position > 0) {
					pt.starttime -= ($to.position*$to.duration)*1000;
					if(!isNaN(_newval)) {
						pt.startvalue = _startvalue;
						pt.difvalue = _difvalue;
					}
					Debug.output('motion', 40007, [$to.position]);
				}
				pt.addEventListener(TweenEvent.UPDATED, updateListener, false, 0, true);
				if($to.round) addEventListener(TweenEvent.UPDATED, roundTweenValue, false, 0, true);
				return pt.id;
			}
		}
		
		/**
		 *	@private
		 */
		protected override function endFunc($o:Object):void {
			if($o.data.primitiveTween.property != undefined){
				if($o.data.primitiveTween.target[$o.data.primitiveTween.property] == $o.data.primitiveTween.value){
					_completed = true;
				}
			}
			super.endFunc($o);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function clone():* {
			return new Tween(duplicateConfig());
		}
		
		/**
		 *	Resets the tween back to the beginning.
		 */
		public function reset():void {
			_pausepos = undefined;
			_newval = undefined;
			_difvalue = undefined;
			_startvalue = undefined;
			_completed = false;
			_tweenconfig.position = 0;
		}
		
		/**
		 *	Gets the current position 0-1 of the tween. Does not include delay.
		 */
		public function get position():Number {
			if(_tweenID != 0){
				var pt:PrimitiveTween = BasicTween._tweenholder[_tweenID];
				//var pos:Number = (pt.target[pt.property]-pt.startvalue)/(pt.value-pt.startvalue); //this is for ease pos
				var pos:Number = (getTimer()-pt.starttime)/pt.duration;
				return pos;
			} else if(_completed) return 1;
			else return 0;
		}
		
		/**
		 *	If the tween finished or not.
		 */
		public function get completed():Boolean{
			return _completed;
		}
		
		/**
		 *	@private
		 */
		protected function delayedTween($delay:int):void {
			Debug.output('motion', 40002, [$delay]);
			_delayTimer = new Timer($delay*1000);
			_delayTimer.addEventListener(TimerEvent.TIMER, dtFunc, false, 0, true);
			_delayTimer.start();
		}
		
		/**
		 *	@private
		 */
		protected function dtFunc($i:Object):void {
			_delayTimer.stop();
			_delayTimer = null;
			_tweenID = createTween(_tweenconfig);
		}
		
		/**
		 *	@private
		 */
		protected function updateListener($i:Object):void {
			dispatchEvent(new TweenEvent(TweenEvent.UPDATED, {tween:this, primitiveTween:BasicTween._tweenholder[_tweenID]}));
		}
		
		/**
		 *	@private
		 */
		protected function roundTweenValue($i:Object):void {
			var pt:Object = $i.data.primitiveTween;
			pt.target[pt.property] = int(pt.target[pt.property]);
			Debug.output('motion', 50003, [pt.id, pt.target[pt.property], int(pt.target[pt.property])]);
		}
		
		/**
		 *	@private
		 */
		protected function setPauses():void {
			_pausepos = position;
			_startvalue = BasicTween._tweenholder[_tweenID].startvalue;
			_difvalue = BasicTween._tweenholder[_tweenID].difvalue;
		}
	
	}

}
