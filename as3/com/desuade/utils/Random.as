/*
This software is distributed under the MIT License.

Copyright (c) 2009-2010 Desuade (http://desuade.com/)

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

package com.desuade.utils {

	/**
	 *  The Random class offers an object or a static method to return a random value between 2 specified values, also allowing for decimal place precision.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  18.04.2009
	 */
	public class Random {
		
		/**
		 *	The Random object's minimum value for the random range.
		 */
		public var min:Number;
		
		/**
		 *	The Random object's maximum value for the random range.
		 */
		public var max:Number;
		
		/**
		 *	This is the amount of decimal places to keep when returning the value.
		 *	
		 *	For example, values such as alpha use a 0-1 scale, so a precision of 2 would be used 0.00
		 */
		public var precision:int;
		
		/**
		 *	This creates a Random object than can be used over again for creating new random values from the same range. Can be used with the Tween classes.
		 *	
		 *	@param	min	 The first value in the range
		 *	@param	max	 The second value in the range, up to but not including
		 *	@param	precision	 This determines how many decimal places the random value should be in
		 *	@see	#min
		 *	@see	#max
		 *	@see	#precision
		 */
		public function Random($min:Number, $max:Number, $precision:int = 0):void {
			min = $min;
			max = $max;
			precision = $precision;
		}
		
		/**
		 *	This property of a Random object returns a new random value within the range each time it's read.
		 */
		public function get randomValue():Number{
			return fromRange(min, max, precision);
		}
		
		/**
		 *	This static function is used to return a random value from a given range.
		 *	
		 *	@param	min	 The first value in the range
		 *	@param	max	 The second value in the range, up to but not including
		 *	@param	precision	 This determines how many decimal places the random value should be in
		 *	@see	#min
		 *	@see	#max
		 *	@see	#precision
		 */
		public static function fromRange($min:Number, $max:Number, $precision:int = 0):Number {
			if($min == $max) return $min;
			else {
				var dp:int = Math.pow(10, $precision);
				var rn:Number = ((int((($min + (Math.random() * ($max - $min))) * dp))) / dp);
				return rn;
			}
		}
	}
}