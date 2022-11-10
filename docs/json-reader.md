# JsonReader

## Problem
Reading JSON is becoming a more common task inside the PLC.  You can either use the FB_JsonDomParser provided in TwinCAT which require multiple calls to navigate in to a JSON document, or you can use the FB_JsonReadWriteDataType to convert a JSON document directly to a known structure, but this is not practical if you have many different forms of JSON.

## Solution
mobject-json is equipped with a JsonReader class.  You can read in your JSON document via string, or HTTP request, and once done you can navigate it simply by using JSON path syntax.  Also, as an added bonus, the class will automatically check the destination symbol and shall provide you with a HRESULT based on its success at reading and converting the value.  

```example
jsonString := '{"factory":{"machines":[{"name":"module_1","running":true}]}}';
jsonReader.LoadFromString(jsonString);

jsonReader.ReadPath('.factory.machines[0].name',moduleName); // module_1
jsonReader.ReadPath('.factory.machines[0].running',isRunning); // true
```

### JSONPath Syntax

JSONPath is a query language for JSON, similar to XPath for XML. 

#### JSONPath notation
A JSONPath expression specifies a path to an element (or a set of elements) in a JSON structure. Paths can use the dot notation (easiest to write in ST):

```.store.book[0].title```

or the bracket notation:

```['store']['book'][0]['title']```

or a mix of dot and bracket notations:

```$['store'].book[0].title```

Note that dots are only used before property names not in brackets.

The leading $ represents the root object or array and can be omitted. For example, $.foo.bar and foo.bar are the same, and so are $[0].status and [0].status.  Just remember to escape the single quote and dollar sign using the $ escape character inside of a string literal.

## Examples

The examples below show the different types of path syntax in use, coupled with the expected hresult. 

```declaration
PROGRAM MAIN
VAR
	
	jsonReader : JsonReader;
	jsonString : T_MAXSTRING := '{"factory":{"machines":[{"name":"module 1","in-production":true,"speed":122.2,"produced":608},{"name":"module 2","in-production":false,"speed":543.2,"produced":24}]}}';

	machineName : STRING;
	inProduction : BOOL;
	speed : LREAL;
	produced : INT;
	myInt : INT;
	
	hresult : HRESULT;
	
END_VAR

```
```body
// setup the json reader with the supplied json

jsonReader.LoadFromString(jsonString);

// all paths are found and can be automatically converted to the supplied destination variables

hresult := jsonReader.ReadPath('factory.machines[0].name',machineName); // hresult = S_OK, machineName = 'module 1'
hresult := jsonReader.ReadPath('.factory.machines[0].in-production',inProduction); // hresult = S_OK, inProduction = true
hresult := jsonReader.ReadPath('$$factory.machines[1].speed',speed); // hresult = S_OK, speed = 543.2
hresult := jsonReader.ReadPath('$$.[$'factory$'].machines[1].produced',produced); // hresult = S_OK, produced = 24

// this will fail as 122.2 cannot be automatically converted to the type INT without data loss. 

hresult := jsonReader.ReadPath('.factory.machines[0].speed',myInt); // hresult = INCOMPATIBLE, myInt = no change

// this will fail as the property 'hello' cannot be found. 

hresult := jsonReader.ReadPath('.factory.machines[0].hello',myInt); // hresult = NOTFOUND, myInt = no change
```