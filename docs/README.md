<p align="center">
  <img width="460" height="300" src="./images/logo.svg">
</p>

>A framework and guide for writing object oriented programs in structured text. 

## Opening Statement
A sprinkling of OOP is usually enough to simplify and unclutter procedural code.  However, the more you apply OOP, the more you find the need to expand it's scope to accommodate functionality which is missing from the language.  For example, writing a simple flashing light class will require its instance to be cyclically called in order for it to update it's hardware output.  If you pass this light in to another object then the responsibility of who should cyclic call it becomes hard to reason about.  Hence, mobject was conceived.  It a framework, library and mindset of how problems such as this can be resolved using both pre-written code and examples. 

mobjects' goal is to be a lightweight solution to typical oop problems.  Where possible it will allow for both inheritance and composition.  I would recommend for you to use inheritance when getting started with the framework, then as you become confident I would recommend that you create objects using composition as this will give you the best chance of code reuse going forwards. 

## Getting started

When using any of the examples, you must first prepare your project with 2 simple steps.  

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
