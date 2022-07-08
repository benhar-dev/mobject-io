<p align="center">
  <img width="460" height="300" src="./images/logo.svg">
</p>

>A framework and guide for writing object oriented programs in structured text. 

## Opening Statement
A sprinkling of OOP is usually enough to simplify and unclutter procedural code.  However, the more you apply OOP, the more you find the need to expand it's scope to accommodate functionality which is missing from the language.  For example, writing a simple flashing light class will require its instance to be cyclically called in order for it to update it's hardware output.  If you pass this light in to another object then the responsibility of who should cyclic call it becomes hard to reason about.  Hence, mobject was conceived.  It a framework, library and mindset of how problems such as this can be resolved using both pre-written code and examples. 

mobjects' goal is to be a lightweight solution to typical oop problems.  Where possible it will allow for both inheritance and composition.  I would recommend for you to use inheritance when getting started with the framework, then as you become confident I would recommend that you create objects using composition as this will give you the best chance of code reuse going forwards. 

## Getting started

When using any of the code below, you must first prepare your project with 2 simple steps.  

1. Add the mobject-core library
2. In every Program POU which is called by a Task, you must make a variable of type Task and call this cyclically in the body.  

```declaration
PROGRAM Main
VAR
    task : Task; // This variable can be named as you wish
END_VAR
```
```body
task.CyclicCall(); // Call this once per cycle.  You can put your own code before or after this call.
```

Thats all! From this point on, all of the examples below will function as expected.

## Cyclic Instance

### The problem

PLCs are cyclic as they need to communicate with the outside world.  As such, your objects may need to be cyclic too.  A flashing lamp object would need time to process its internal timers and update its output, which leads to us needing to explicitly call the object each PLC cycle.  

To further complicate matters, if you make new objects at runtime who need to by cyclic called, then it becomes hard to handle who should be responsible for calling them. 

### The solution
The first core purpose for mobject-core is to provide you with a simple way to handle cyclic code.  

mobject-core helps out and allows you as the object programmer to mark your objects as a cyclic instance.  Doing so will allow you object to be automatically called when needed.  

### Example
In this example we will make a flashing lamp object.  
<!-- tabs:start -->

#### **Inheritance**

This example shows how to achieve this by inheriting from the CyclicInstance class.

1. Start by creating FlashingLamp Function Block with the following code.

```declaration
FUNCTION_BLOCK FlashingLamp EXTENDS CyclicInstance
VAR
    // these timers are required to implement the flashing lamp object
    tick : ton;
	tock : ton;
END_VAR
```
```body
//... no code should go here.
```

2. Next create a method called CyclicCall.  Any code placed in here will be automatically called each PLC cycle.  

```declaration
METHOD CyclicCall
VAR_INPUT
END_VAR
```
```body
tick(in:=NOT tock.Q,pt:=T#1S);
tock(in:=tick.Q,pt:=T#1S);
```

3. Now create a property called Output.  This is how we will read the state of our lamp.

```declaration
PROPERTY PUBLIC Output : BOOL
```
```body
Output := tick.Q;
```

#### **Composition**

This example shows how to achieve this by using composition.

1. Start by creating FlashingLamp Function Block. 

2. Our class will need to implement the I_CyclicCalled interface and declare a AutomaticCyclicCall variable as shown below.

```declaration
FUNCTION_BLOCK FlashingLamp Implements I_CyclicCalled
VAR
  cyclicCall : AutomaticCyclicCall(THIS^);
  // these timers are required to implement the flashing lamp object
  tick : ton;
	tock : ton;
END_VAR
```
```body
//... no code should go here.
```

?> The I_CyclicCalled tells the code that you have a .CyclicCalled method.

?> AutomaticCyclicCall will automatically register you (via This^) for cyclic calling.  Only classes who implement I_CyclicCalled can be passed in to AutomaticCyclicCall. 

3. Next create a method called CyclicCall.  Any code placed in here will be automatically called each PLC cycle.  

```declaration
METHOD CyclicCall
VAR_INPUT
END_VAR
```
```body
tick(in:=NOT tock.Q,pt:=T#1S);
tock(in:=tick.Q,pt:=T#1S);
```

4. Now create a property called Output.  This is how we will read the state of our lamp.

```declaration
PROPERTY PUBLIC Output : BOOL
```
```body
Output := tick.Q;
```

<!-- tabs:end -->

You are done! Add your new FlashingLamp to one of your programs and watch it automatically flash.
```declaration
PROGRAM Main
VAR
	task : Task;
	lamp : FlashingLamp;
	output : BOOL;
END_VAR
```
```body
task.CyclicCall();

output := lamp.Output;
```

