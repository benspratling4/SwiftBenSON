# SwiftBenSON

A strict super-set of JSON, which adds cross-platform types, and data literals.


Like JSON, values can be specified by objects, arrays, strings, etc...  But like XML, a "tag" introduces a type.

In addition, a new primitive is added, a data literal.

### Built for Human readability & diff

BenSON can be written both as human-readable, and machine-optimized formats.  Human-readable formats add new lines and tab indentations.  Data literals are printed in hexadecimal.  In this format, diff becomes efficient

The machine-optimized format eliminates syntactical whitespace, and all data literals become actual bytes in the file.

### Data literals

JSON introduces strings with a `"`, arrays with a `[` and objects with a `{`.
BenSON keeps these, and introduces data with a `#`.

`#x` Hexadecimal - in human-readable format, data literals begin with `#x` and continue with as many hex characters (and white space) as needed.   As contrasted with Base64, humans find hexadecimal easier to read and write.


`#12:`	Raw bytes  -  in machine-optimized format, data literals include a number of bytes in human readable ascii, followed by a ":" and then the raw bytes.  Depending on the optimizations of the parser, the bytes may not even be read at initial parse time, preferring instead to skip over them to be read at a later time.


### Type tags

Literals are free to literals, but often, type information is very useful.  In BenSON, type information 

	<pdf:.pdf, com.adobe.pdf, application/pdf>#...

In this example, the type is "pdf" (which is before the colon) which has mime types, file extensions and UTI included in a comma-separated list.  This enables arbitary data of any type to achieve 100% passthrough on any system.

A platform which knows how to represent a .pdf file can create one from the data.  While a platform which has no .pdf code available can simply re-write exactly the same tags when writing the data back to a file.

As an optimization, the type specifiers are not needed after their first appearance, and subsequent tags with the "pdf" type appear as just the tag name:

	<pdf>#...

Unlike XML, no "closing" tags exist.  Tags are followed by one of the literals, which use standard JSON delimiters for indicating their end.

#### Types on any literal

Data isn't the only literal to which tags can be prepended.  Any literal can have a tag prepended.

For instance, I could represent SVG as a string, which would itself be XML:

	<svg>"<svg>...</svg>"

Or as data

	<svg>#....

Or as objects

	<svg>{"canvas":{"width":...}}

How the type should best be represented is up to the format designer, but as you define how your own data types are to be represented, think about choosing different formats for human readable and machine-optimized.

Parsing code should be ready to expect either human-readable or machine-optimized at any point in the parsing processes.  Because platforms which don't know the types may be forced to retain the other format '







