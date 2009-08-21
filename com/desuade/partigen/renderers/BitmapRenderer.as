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

package com.desuade.partigen.renderers {
	
	import flash.display.*;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.utils.ByteArray;
	
	import com.desuade.partigen.particles.BasicParticle;
	import com.desuade.debugging.*;
	import com.desuade.motion.bases.*;
	import com.desuade.motion.events.*;
	
	/**
	 *  This uses BitmapData to display particles.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  04.08.2009
	 */
	public class BitmapRenderer extends StandardRenderer {
		
		/**
		 *	The BitmapData to render to.
		 */
		public var bitmapdata:BitmapData;
		
		/**
		 *	What function to run on the bitmap
		 *	
		 *	@param	bitmap	 The bitmapdata is passed to the function
		 */
		public var renderfunc:Function = nullfunc;
		
		/**
		 *	@private
		 */
		protected var _offbitmap:BitmapData;
		
		/**
		 *	@private
		 */
		protected var _zeroPoint:Point;
		
		/**
		 *	@private
		 */
		protected var _fadeCT:ColorTransform = new ColorTransform (1, 1, 1, 0, 0, 0, 0, 0);
		
		/**
		 *	@private
		 */
		public var _blur:BlurFilter = new BlurFilter(0,0,1);
		
		/**
		 *	Creates a new BitmapRenderer. This will use BitmapData to render particles.
		 *	
		 *	@param	bitmapdata	 The BitmapData object to render to.
		 *	@param	order	 The visual order of a new particle to be created - either 'top' or 'bottom'.
		 */
		public function BitmapRenderer($bitmapdata:BitmapData, $order:String = 'top') {
			super(new Sprite(), $order);
			bitmapdata = $bitmapdata;
			_zeroPoint = new Point(0, 0);
		}
		
		/**
		 *	Starts the renderer writing to the BitmapData.
		 */
		public override function start():void {
			_offbitmap = new BitmapData(bitmapdata.width, bitmapdata.height, true, 0);
			_offbitmap.copyPixels(bitmapdata, bitmapdata.rect, _zeroPoint);
			BaseTicker.addEventListener(MotionEvent.UPDATED, render);
		}
		
		/**
		 *	Stops the renderer from writing to the BitmapData.
		 */
		public override function stop():void {
			_offbitmap.dispose();
			BaseTicker.removeEventListener(MotionEvent.UPDATED, render);
		}
		
		/**
		 *	@private
		 */
		protected function nullfunc($bitmap:BitmapData):void {
			//
		}
		
		/**
		 *	<p>The amount of fade to perform on the BitmapData.</p>
		 *	<p>A value of 0 will instantly fade the BitmapData, leaving no trail.</p>
		 *	<p>A value of 1 will not fade the BitmapData, "painting" the screen.</p>
		 *	<p>Any value in between will fade the BitmapData, like a motion trail.</p>
		 */
		public function set fade($value:Number):void {
			_fadeCT.alphaMultiplier = $value;
		}
		
		/**
		 *	@private
		 */
		public function get fade():Number{
			return _fadeCT.alphaMultiplier;
		}
		
		/**
		 *	The amount of blur to perform on the fade.
		 */
		public function get fadeBlur():Number{
			return _blur.blurX;
		}
		
		/**
		 *	@private
		 */
		public function set fadeBlur($value:Number):void {
			_blur.blurX = _blur.blurY = $value;
		}
		
		/**
		 *	@private
		 */
		protected function render($e:Object):void {
			if(_fadeCT.alphaMultiplier != 0){
				_offbitmap.colorTransform(_offbitmap.rect, _fadeCT);
			} else {
				_offbitmap.fillRect(bitmapdata.rect, 0x00000000);
			}
			if(fadeBlur != 0) _offbitmap.applyFilter(_offbitmap, _offbitmap.rect, _zeroPoint, _blur);
			_offbitmap.draw(target);
			renderfunc(_offbitmap);
			//var pixels:ByteArray = _offbitmap.getPixels(_offbitmap.rect);
			//pixels.position = 0;
			//bitmapdata.setPixels(_offbitmap.rect, pixels);
			bitmapdata.copyPixels(_offbitmap, _offbitmap.rect, _zeroPoint);
		}
	
	}

}
