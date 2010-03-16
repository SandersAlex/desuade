/*

Desuade Motion Package (DMP) 1.1 MotionController Example
http://desuade.com/dmp

This .fla goes over how controllers work with the package.
Understanding of the tween, sequencing, and physics classes is highly recommended.

////Overview////

MotionControllers are basically pragmatic motion editors, like those found in Flash CS4 and After Effects.
They use 'keyframes' just like the timeline or motion editor to mark a position where there's a change of value.
(Note: they're not actual keyframes or use frame-based motion from the time line)

Controllers basically "take control" over a property and manage it's value over time. It 
acts a sequence that tweens properties to the value indicated by 'keyframes', from the 
'begin' keyframe to the 'end' keyframe, and any custom keyframes in between.

Each MotionController has a property called 'keyframes' which is a KeyframeContainer object. 
This object is what handles all the keyframes, and is used to add or remove any custom ones.

Each KeyframeContainer will always have 2 keyframes: begin & end. Setting an end value will 
create a tween, and adding any keyframes will essentially divide it at a specified position and create 2 tweens.

Each keyframe also has an ease property, which allows you to choose a custom ease for each tween in the controller.

The DMP was designed with Partigen in mind, so each keyframe offers a 'spread' property. 
This allows the value at each keyframe to become random, from a range starting at the 'value' to the 'spread'.


////Logical example:

target1.y = 0;
var myvc:MotionController = new MotionController(target1, 'y', 10); //this creates a MC for the y property and a duration of 10 seconds.
myvc.keyframes.add(new Keyframe(.2, 300, 'easeOutBounce')); //value of 300, no spread, position at 1/4 of the way, with a Bounce
myvc.keyframes.add(new Keyframe(.4, 150));

Visualize:

       v keyframe1          v end
+------+----+---------------+
^ begin     ^ keyframe2

Keyframe Positions:
begin: 0
keyframe1: 0.2
keyframe2: 0.4
end: 1

Values:

0------300---150-------------0

(because no start or end value was defined, the controller uses the original value)

Tweens(3):
0-300 (2 seconds)
300-150 (2 seconds)
150-0 (6 seconds)

If we made the duration 5, the tweens' lengths would be:
0-300 (1 second)
300-150 (1 second)
150-0 (3 seconds)

When the controller starts, it takes all keyframes in the KeyframeContainer and orders them 
according to the value of their 'position' property and creates a sequence. The length of 
each tween depends on the value of the next keyframe, and the MotionController's duration.

Reading the API documentation is highly recommended to get accustomed to properties and methods used with MotionControllers.


////Events////

Controllers have 3 events:
STARTED: when the controllers starts
ADVANCED: when a tween finishes and moves on to the next keyframe
ENDED: when the controller finishes and reaches the 'end' keyframe


////Variations////

There are 3 different types of controllers:
MotionController: this is the standard controller that works with regular values and tweens
MultiController: this manages multiple MotionControllers for a single target, with many helper methods
PhysicsMultiController: this is a MultiController which creates 3 MotionControllers to handle velocity, acceleration, and friction of a BasicPhysics object


////Usage////

new MotionController(target:Object, property:String, duration:Number, containerclass:Class = null, tweenclass:Class = null)

target: target object
property: the property to control the value of
duration: the entire length of the sequence
containerclass: the kind of KeyframeContainer to use
tweenclass: the class of tween engine to use for tweening

MotionControllers automatically create a KeyframeContainer, as: MotionController.keyframes
This keyframe object always has at least two keyframes:

keyframes.begin
keyframes.end

To add a keyframe, call the 'add()' method and define a Keyframe to add from the KeyframeContainer:

keyframes.add(new Keyframe(position:Number, value:Function, ease:Object = null, spread:* = null, extras:Object = null), label:String);

value: the value to tween to
spread: the end range to create a random value
position: what position of the sequence (0-1)
ease: what ease to use
extras: any extra params to pass to the tween
label: the name of keyframe (defaults to keyframe1, keyframe2, keyframe3, etc)

Like Tween classes, 'value' and 'spread' use Numbers for absolute, and Strings for 
relative. A relative spread will be added to the value.

Calling start() will start the controller. This internally creates a sequence of tweens, 
dynamically created on start from all the keyframes and the duration.

See the examples in this fla for variations on PhysicsMotionController and ColorMotionController.

For more information, consult the docs on properties and syntax guidelines: http://api.desuade.com/

*/

package {

	import flash.display.*;

	public class motion_controllers extends MovieClip {
	
		public function motion_controllers()
		{
			super();
			
			
			
			/////////////////////////////////////////////////
			//
			//
			//How to use: each block of code is a seperate example, with the start method commented out.
			//Uncommenting this will show the resulting example in the compiled SWF.
			//Go through each example and uncomment the lines, test the movie,
			//then recomment the line and continue to the next demo.
			//
			//Note: Everything here you can easily copy and run in an FLA
			//code was provided in this .as file for users without the Flash IDE.
			//
			//
			/////////////////////////////////////////////////
			
			
			
			//Fla setup
			stop();
			import flash.display.MovieClip;
			import flash.display.StageAlign;
			import flash.display.StageScaleMode;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			//create movieclip to tween
			var target1:Sprite = new Sprite();
			target1.graphics.beginFill(0xAADDF0);
			target1.graphics.drawRect(0, 0, 100, 100);
			target1.name = "target1";
			addChild(target1);
			target1.x = 150;
			target1.y = 150;

			//This is for all the debugging classes
			//Comment out or set Debug.enabled = false to disable debugging
			import com.desuade.debugging.*
			import com.desuade.motion.*
			Debug.load(new DebugCodesMotion());
			Debug.level = 60000;
			Debug.enabled = true;
			//Debug.onlyCodes = true;

			//import controllers, events and eases
			import com.desuade.motion.controllers.*;
			import com.desuade.motion.eases.*;
			import com.desuade.motion.events.*;

			
			
			
			////
			//basic tween with controller
			var vc1:MotionController = new MotionController(target1, 'y', 2);
			vc1.keyframes.end.value = 300;
			vc1.keyframes.end.ease = 'easeOutBounce';
			//vc1.start();
			
			
			
			//////
			//controller to set a random beginning and end value
			var vc2:MotionController = new MotionController(target1, 'y', 2);
			vc2.keyframes.end.value = 300;
			vc2.keyframes.end.spread = '-200';
			vc2.keyframes.end.ease = 'easeOutBounce';
			vc2.keyframes.begin.spread = 0;
			//vc2.start();
			
			
			
			//////
			//using controller to set a random value (re-export to see it different each time)
			var vc3:MotionController = new MotionController(target1, 'y', 2);
			vc3.keyframes.begin.value = 0;
			vc3.keyframes.begin.spread = 200;
			//vc3.setStartValue();

			
			
			//////
			//controller with custom keyframes and showing XML
			var vc4:MotionController = new MotionController(target1, 'x', 5);
			vc4.keyframes.end.value = 400;
			vc4.keyframes.end.ease = 'easeOutBounce';
			vc4.keyframes.add(new Keyframe(.3, 300), 'mynewkeyframe');
			vc4.keyframes.mynewkeyframe.ease = 'easeOutQuad';
			vc4.keyframes.add(new Keyframe(.7, 0, 'easeOutElastic', 50));
			var v4x:XML = vc4.toXML();
			//vc4.start();
			//trace(v4x);
			//var vc42:MotionController = new MotionController(target1).fromXML(v4x).start(); //this creates and starts a controller from XML
			
			
			
			//////
			//controller with event and start at different keyframe
			//v1.1 start at a given time
			var vc5:MotionController = new MotionController(target1, 'x', 5);
			vc5.keyframes.end.value = 400;
			vc5.keyframes.add(new Keyframe(.4, 200));
			vc5.keyframes.add(new Keyframe(.7, 300), 'myframe');
			vc5.keyframes.add(new Keyframe(.9, 350));
			vc5.addEventListener(ControllerEvent.ADVANCED, adv);
			function adv(o:Object){
				trace("advanced: " + o.data.controller.keyframes.getOrderedLabels()[o.data.position]);
			}
			//vc5.start(); //starts it normally
			//vc5.start('myframe'); //starts it at the given keyframe
			//vc5.start('begin', 2.3); //starts it 2.3 seconds into playing (overrides the keyframe param)
			
			
			
			//////
			//2 controllers with XML making random movement
			//vc7 uses the startTime (v1.1) param to start the controller as if it's in the middle of running
			var vc6:MotionController = new MotionController(target1, 'x', 10);
			vc6.keyframes.end.value = 400;
			vc6.keyframes.add(new Keyframe(.1, 0, 'easeOutQuad', 500));
			vc6.keyframes.add(new Keyframe(.2, 0, 'easeOutQuad', 500));
			vc6.keyframes.add(new Keyframe(.3, 0, 'easeOutQuad', 500));
			vc6.keyframes.add(new Keyframe(.4, 0, 'easeOutQuad', 500));
			vc6.keyframes.add(new Keyframe(.5, 0, 'easeOutQuad', 500));
			vc6.keyframes.add(new Keyframe(.6, 0, 'easeOutQuad', 500));
			vc6.keyframes.add(new Keyframe(.7, 0, 'easeOutQuad', 500));
			vc6.keyframes.add(new Keyframe(.8, 0, 'easeOutQuad', 500));
			vc6.keyframes.add(new Keyframe(.9, 0, 'easeOutQuad', 500));
			var vc7:MotionController = new MotionController(target1, 'y', 10);
			vc7.keyframes.fromXML(vc6.keyframes.toXML());
			//vc7.start('begin', 5.4);
			//vc6.start();
			
			
			
			//////
			//////color controllers
			var cvc:MotionController = new MotionController(target1, null, 3, ColorKeyframeContainer);
			cvc.keyframes.add(new Keyframe(.3, 'ff4444'));
			cvc.keyframes.add(new Keyframe(.5, null));
			cvc.keyframes.begin.value = '#333333';
			cvc.keyframes.end.extras.amount = .5;
			cvc.keyframes.end.value = 0xff4444;
			cvc.keyframes.begin.extras.type = 'tint';
			//cvc.start();



			///////physics
			//the physics controller is just a controller of MotionControllers - it actually creates 3 MotionControllers for the physics properties.
			//if the friction or accel controllers are not flat (they have a change in value), the velocity controller gets turned off since the velocity is now affected by acceleration and friction
			var pc:PhysicsMultiController = new PhysicsMultiController(target1, 'x', 3);
			pc.velocity.keyframes.end.value = -7;
			pc.velocity.keyframes.add(new Keyframe(.5, 5));
			pc.velocity.keyframes.end.ease = 'easeOutSine';
			pc.acceleration.keyframes.flatten(.3); //since we don't want a change in accel, we make all the keyframes the same value
			//pc.physics.start()
			//pc.start();
			
			
		}
	
	}

}

