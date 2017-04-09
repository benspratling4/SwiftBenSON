# SwiftBenSON

A strict super-set of JSON, which adds cross-platform types, and data literals.


Like JSON, values can be specified by objects, arrays, strings, etc...  But like XML, a "tag" introduces a type.

In addition, a new primitive is added, a data literal.

### Type tags

Literals are free to literals, but often, type information is very useful.  In BenSON, type information 

<>


### Data literals

JSON introduces strings with a `"`, arrays with a `[` and objects with a `{`.
BenSON keeps these, and introduces data with a `#`.

`#x` Hexadecimal


`#12:`	Raw byets


### Built for Human readability & diff

BenSON can be written both as human-readable, and machine-optimized formats.  Human-readable formats add new lines and tab indentations.  Data literals are printed in hexadecimal.  In this format, diff becomes efficient

The machine-optimized format eliminates syntactical whitespace, and all data literals become actual bytes in the file.



