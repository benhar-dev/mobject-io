# Cyclic Instance

## Problem

PLCs are cyclic as they need to communicate with the outside world.  As such, your objects may need to be cyclic too.  A flashing lamp object would need time to process its internal timers and update its output, which leads to us needing to explicitly call the object each PLC cycle.  To further complicate matters, if you make new objects at runtime who need to by cyclic called, then it becomes hard to handle who should be responsible for calling them. 

## Solution
The first core purpose for mobject-core is to provide you with a simple way to handle cyclic code.  This library allows you as the object programmer to mark your objects as a cyclic instance.  Doing so will allow your object to be called automatically.  

## Example
!> This example is **Cyclic**, and as such you must first follow the getting started guide found [here](./#getting-started).

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
FUNCTION_BLOCK FlashingLamp IMPLEMENTS I_CyclicCalled
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

## Best practice 
Currently there is no CLASS keyword in Structured Text.  As such you will be creating your classes from the POU type of FUNCTION_BLOCK.  Please have a look at the [Class section](/coding-guide?id=class) of the [Coding guide](/coding-guide) as there are a few other best practice steps which you should take which were not shown in this example.