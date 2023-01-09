<p align="center">
  <img width="460" height="300" src="./docs/images/logo.svg">
</p>
Pronounced mob-ject. The open source machine object oriented programming framework and guide.

## Important Information
This software is in ***Alpha***.  I have decided to make this a public repo so that people can see my work in progress.  Do not use this software in production as there will be breaking changes.  However, please feel free to contribute, copy and use code.  This is a project for my spare time so development time is not fast!

This framework has been created for TwinCAT.  Mobject uses reflection, TwinCAT Pragmas and libraries so porting to other controllers may not be possible. 

## Opening Statement
A sprinkling of OOP is usually enough to simplify and unclutter procedural code.  However, the more you apply OOP, the more you find the need to expand it's scope to accommodate functionality which is missing from the language.  For example, writing a simple flashing light class will require its instance to be cyclically called in order for it to update it's hardware output.  If you pass this light in to another object then the responsibility of who should cyclic call it becomes hard to reason about.  Hence, mobject was conceived.  It's a framework, library and mindset of how problems such as this can be resolved using both pre-written code and examples. 

mobject's goal is to be a lightweight solution to typical oop problems.  

## Documentation
The documentation for this project can be found [here](https://benhar-dev.github.io/mobject-io/). 

## Versions
* TcXaeShell 3.1.4024.29
