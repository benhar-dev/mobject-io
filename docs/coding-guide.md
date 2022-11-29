# Coding Guide
>Clean code is simple and direct. Clean code reads like well-written prose. Clean code never obscures the designer’s intent but rather is full of crisp abstractions and straightforward lines of control. - Grady Booch author of Object Oriented Analysis and Design with Applications

## Opening Statement
This coding guide has been created to help keep our code base clean and tidy.  It will act as a base for those of you who have not settled on a standard, and will impose rules on those of you who wish to contribute.  

## Symbol Naming

### Intent
Use names which both reveal your intent and removes the need for supplementing your code with comments.  

```example
// Put the UPS in to full capacity mode if the Power Supply 10 is in fault
IF SUP_10.flt THEN 
	UPS.smode := 1;
END_IF
```
The example above has been renamed and refactored to remove the comment.  This allows us to read the code without placing any mental obstacles in the way of our understanding.  
```example
IF powerSupply10.HasFault THEN 
	UPS.mode := FULL_CAPACITY_MODE;
END_IF
```

### Avoid abbreviations
Where possible, do not abbreviate.  This forces us to think, decode and remember a term.  Every time we give our brain something to do it forces it to work harder.  Instead favour whole words and phrases so that our mind can stay on auto-pilot when reading our code.  

```example
   VAR strBtn : BOOL;
```
It may seem only a small step, but the brain power that we have saved not decoding an abbreviation can be used for other more creative or fault finding tasks. 
```example
   VAR startButton : BOOL;
```

### Prefix and Suffix
There is only one instance in which a prefix is allowed and this is on a symbol for a pointer as it will visually remind you to dereference the pointer before use.
```example
   VAR pMessage : POINTER TO Message;
```
The p prefix will alert the programmer to correctly dereference the pointer using ^.
```example
   pMessage^.DoSomething(); // the symbol ^ is the dereference operator
```
!> Prefix and Suffix are visual obstacles and as such they impair our natural ability to read.  Hungarian notation will only obscure your code with no benefit to the reader so you should look to remove this at all times.  

## Comments
Ask yourself 'why do I need a comment?' 

If you need them to convey your code's true meaning then you should refactor and rename your variables to make your [Intent](?id=intent) clear.  

Do not use them for auditing, changes, author.  This adds extra work to the coders following you and they will be missed and become out of date.  Favour source control instead.   

**Comments must not be used to,**
* explain how your code works (Rename / Refactor)
* comment out old code (Delete it and use Source Control)
* add author information (use Source Control)

**Comments may be use**
* as place holders or for general information.    

```example
IF PowerSupply10.HasFault THEN 
	// Custom fault reaction code may go here...
END_IF
```

Remember, no comments are the best form of comments!

## Enumeration

### Global Enumeration
Global Enumeration should be kept to a minimum as this will cause tight coupling between objects which use them.  Tight coupling is a bad thing.  Try instead to replace global enumeration with other objects which can be passed around.

### Local Enumeration
Enumeration inside of a class is good and will make CASE statements easier to use and extend.  Use inline enumeration as shown below.  This keeps internal state locked away inside a class and prevents us needing to manage this enumeration in a second file.   

Enumeration must be ALL_CAPITALS with underscore word separation.

```declaration
FUNCTION_BLOCK Cylinder 
VAR
	state : (RETRACTED, EXTENDING, EXTENDED, RETRACTING, JAMMED_EXTENDING, JAMMED_RETRACTING);
END_VAR
```
```body
CASE state OF
	RETRACTED: 
		// 
	EXTENDING: 
		// 
//...
END_CASE
```

## Constants
Constants must be ALL_CAPITALS with underscore word separation.

Replace "Magic numbers" with constants to assist with readability and understanding.  
```example
VAR CONSTANT

	MAXIMUM_BUFFER_SIZE_IN_BYTES : UDINT := 200;

END_VAR
```


## Class
In the IEC standard there is no keyword for Class, instead you must use a Function Block with the attributes shown below.  
You should decorate your classes with the no_explicit_call attribute to prevent if from being used as a standard IEC Function Block. 
```example
{attribute 'linkalways'} 
{attribute 'no_explicit_call' := 'This FB is a CLASS and must be accessed using methods or properties'}
{attribute 'enable_dynamic_creation'}
```
!>You must not place code in the FUNCTION_BLOCK body.  Use a public method instead, such as .CyclicCall();

!>You must not allow VAR_INPUT, VAR_OUTPUT and VAR_IN_OUT to exist in a class declaration. 

### Naming
Always use **PascalCase** for class names.  You should use noun or noun phrase for class names.  Do not use prefixes.  An underscore may be used if the class is typed and it assists with overall the readability.
```example
FUNCTION_BLOCK AnalogValue_LREAL EXTENDS AnalogValue
// VAR_INPUT, VAR_OUTPUT and VAR_IN_OUT is not permitted here.
VAR
	
END_VAR
```

### Private Variables
Private variables must be **camelCase**.

Private variables which share the same name as a Property must be prefixed with an underscore.  Try to avoid this type of name clash where possible.   

### Example
```declaration
{attribute 'no_explicit_call' := 'This FB is a CLASS and must be accessed using methods or properties'} 
FUNCTION_BLOCK Cylinder EXTENDS ComponentBase IMPLEMENTS I_Move
VAR
	_isBusy : BOOL; // underscore required if there is an IsBusy property
    state : (RETRACTED, EXTENDING, EXTENDED, RETRACTING, JAMMED_EXTENDING, JAMMED_RETRACTING);
	retractedSensor : I_Sensor;
	extendedSensor : I_Sensor;
END_VAR
```

```body
// The body of a class must not be used for code.  
// Cyclic code should be called from a method if needed. 
```
## Methods
Classes may use methods.  Methods in a Function Block or Program should be avoided at all costs. 

Methods, like classes should have one reason to exist.  They  should do one job and do it well.    

### Naming
Always use **PascalCase** for method names.  You should use verb or verb phrase for method names.  Do not use prefixes. 
```example
cylinder.Retract();
persistentData.Save();
```
!>Methods should not have the word 'and' in them as this is a sure sign that they are doing more than one job.

### Arguments
Methods should have as few arguments as possible.  Zero arguments is best.  One argument is ok.  Two arguments is almost too many.  Try to pass objects in to methods in order to reduce argument count.  Avoid Boolean arguments as this is typically a sign that a method is dual purpose. 

```example
// example of a bad method
csvReader.LoadFileAndParseResultsToArrayIfLoggingIsEnabled('file.csv',resultsArray,Logging.IsEnabled);
```
The example above has been refactored to divide the method in to smaller methods with smaller number of arguments.
```example
IF logging.IsEnabled THEN
	csvReader.LoadFile('file.csv');
	csvReader.ParseToArray(resultsArray);
END_IF
```