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

package com.desuade.partigen.emitters {
	
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import com.desuade.partigen.renderers.*;
	import com.desuade.motion.events.*;
	import com.desuade.utils.Drawing;
	import com.desuade.motion.bases.BaseTicker;
	
	/**
	 *  This is the class used for Partigen Emitter components for the Flash IDE.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  20.08.2009
	 */
	public dynamic class IDEEmitter extends Emitter {
		
		/**
		 *	@private
		 */
		protected var _autoStart:Boolean = false;
		
		/**
		 *	@private
		 */
		protected var _followMouse:Boolean = false;
		
		/**
		 *	@private
		 */
		protected var _renderToParent:Boolean = true;
		
		/**
		 *	@private
		 */
		protected var _oldang:Array = ['n', 'n'];
		
		/**
		 *	@private
		 */
		public var indicator:MovieClip;
		
		/**
		 *	Creates a new IDEEmitter (usually from a component)
		 */
		public function IDEEmitter() {
			super();
			BaseTicker.start();
			BaseTicker.addEventListener(MotionEvent.UPDATED, updateAngleSlice);
		}
		
		/**
		 *	Getter/setter that uses XML methods to return (as XML) or set the configuration of the emitter from String/XML.
		 */
		[Inspectable(name = "Config XML", defaultValue = '<Emitter particle="DefaultParticle" eps="10" burst="1" life="1" lifeSpread="*0" angle="0" angleSpread="*0">  <Controllers>    <EmitterController/>    <ParticleController/>  </Controllers></Emitter>', variable = "config", type = "String")]
		public function get config():XML{
			return toXML();
		}
		
		/**
		 *	@private
		 */
		public function set config($value:*):void {
			if($value != "") fromXML((typeof $value == 'string') ? new XML($value) : $value);
		}
		
		/**
		 *	Start the emitter automatically.
		 */
		[Inspectable(name = "Start Automatically", defaultValue = false, variable = "autoStart", type = "Boolean")]
		public function get autoStart():Boolean{
			return _autoStart;
		}
		
		/**
		 *	@private
		 */
		public function set autoStart($value:Boolean):void {
			_autoStart = $value;
			if($value) start();
		}
		
		/**
		 *	If the emitter follows the mouse.
		 */
		[Inspectable(name = "Follow Mouse", defaultValue = false, variable = "followMouse", type = "Boolean")]
		public function get followMouse():Boolean{
			return _followMouse;
		}
		
		/**
		 *	If the emitter indicator should be shown, marking it's position on the stage.
		 */
		[Inspectable(name = "Show Indicator", defaultValue = true, variable = "showIndicator", type = "Boolean")]
		public function get showIndicator():Boolean{
			return indicator.visible;
		}
		
		/**
		 *	@private
		 */
		public function set showIcon($value:Boolean):void {
			indicator.visible = $value;
		}
		
		/**
		 *	@private
		 */
		public function set followMouse($value:Boolean):void {
			_followMouse = $value;
			if(_followMouse){
				stage.addEventListener(MouseEvent.MOUSE_MOVE, fmouse);
			} else {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, fmouse);
			}
		}
		
		/**
		 *	This automatically creates a StandardRenderer targeting the emitter's parent.
		 */
		[Inspectable(name = "Render to Parent", defaultValue = true, variable = "renderToParent", type = "Boolean")]
		public function get renderToParent():Boolean{
			return _renderToParent;
		}
		
		/**
		 *	@private
		 */
		public function set renderToParent($value:Boolean):void {
			_renderToParent = $value;
			if(_renderToParent){
				renderer = new StandardRenderer(this.parent);
			}
		}
		
		/**
		 *	@private
		 */
		protected function fmouse($o:Object):void {
			x = root.stage.mouseX;
			y = root.stage.mouseY;
		}
		
		/**
		 *	@private
		 */
		public function updateAngleSlice($e:Object):void {
			if(indicator.visible){
				if(_oldang[0] != angle || _oldang[1] != angleSpread){
					_oldang[0] = angle;
					_oldang[1] = angleSpread;
					indicator.graphics.clear();
					var ags:Number = (typeof angleSpread == 'string') ? angle + Number(angleSpread) : angleSpread;
					Drawing.drawSlice(indicator, angle, ((angle-ags) == 0) ? angle+1 : ags, 9, '#cccccc', 0, 0, 10);
				}
			}
		}
	
	}

}
