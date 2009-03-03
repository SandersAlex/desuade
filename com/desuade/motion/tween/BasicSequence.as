package com.desuade.motion.tween {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import com.desuade.debugging.*
	import com.desuade.motion.events.*

	public dynamic class BasicSequence extends Array implements IEventDispatcher {
		
		protected var _position:int = 0;
		protected var _active:Boolean = false;
		protected var _tween:BasicTween;
		protected var _dispatcher = new EventDispatcher();
	
		public function BasicSequence(... args) {
			super();
			for (var i:int = 0; i < args.length; i++) {
				push(args[i]);
			}
			Debug.output('motion', 40003);
		}
		
		public function get position():int{
			return _position;
		}
		public function get active():Boolean{
			return _active;
		}
		
		public function start($position:int = 0, $simulate:Boolean = false):void {
			_active = true;
			_dispatcher.dispatchEvent(new SequenceEvent(SequenceEvent.STARTED, {basicSequence:this}));
			if($position > 0 && $simulate){
				Debug.output('motion', 40006, [$position]);
				for (var i:int = 0; i < $position; i++) {
					var t:Object = this[i];
					t.target[t.prop] = t.value;
				}
			}
			play($position);
		}
		
		public function stop():void {
			_tween.removeEventListener(TweenEvent.ENDED, advance);
			_tween.stop();
			end();
		}
		
		protected function play($position:int):void {
			Debug.output('motion', 40004, [$position]);
			_position = $position;
			_tween = new BasicTween(this[_position]);
			_tween.addEventListener(TweenEvent.ENDED, advance);
			_tween.start();
		}
		
		protected function end():void {
			_tween = null;
			_active = false;
			_dispatcher.dispatchEvent(new SequenceEvent(SequenceEvent.ENDED, {basicSequence:this}));
			Debug.output('motion', 40005);
		}
		
		protected function advance($i:Object):void {
			if(_position < length-1){
				play(++_position);
				_dispatcher.dispatchEvent(new SequenceEvent(SequenceEvent.ADVANCED, {position:_position, basicSequence:this}));
			} else {
				_tween.removeEventListener(TweenEvent.ENDED, advance);
				end();
			}
		}
		
		//for event-dispatching
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			_dispatcher.addEventListener(type, listener, useCapture, priority);
		}

		public function dispatchEvent(evt:Event):Boolean{
			return _dispatcher.dispatchEvent(evt);
		}

		public function hasEventListener(type:String):Boolean{
			return _dispatcher.hasEventListener(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger(type:String):Boolean {
			return _dispatcher.willTrigger(type);
		}
		
	}

}
