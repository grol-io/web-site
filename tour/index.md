---
Title: A tour of Grol
redirect_from:
    - /Tour
---
## A Tour of Grol

Welcome to Grol! This guide provides a tour of the Grol language, covering its core features and syntax with examples.

> This was mostly generated and may not be 100% accurate, please report any issue - it's also a snapshot as of grol 0.80.3 and earlier

### 1. Introduction

Grol is a functional scripting language featuring integers, floats, strings, booleans, arrays, and ordered maps. It supports functions, lambdas, closures, and macros. Grol includes features like automatic memoization, easy extensibility with Go functions, and a `wasm` version for running in the browser.

You can try Grol online here or install it locally via Go, Docker, or Brew.

### 2. The Basics

#### 2.1. REPL

Running `grol` without arguments starts the interactive Read-Eval-Print Loop (REPL).

* It has command history (arrow keys) and tab completion for identifiers and keywords.
* State is auto-saved/loaded from `.gr` in the current directory (use `-no-auto` to disable).
* Use `help` for basic commands.

```bash
$ grol -parse # -parse optional for extra information/this example
```
```go
16:53:12.099 [INF] grol 0.80.3 h1:zJkh1KqpnuHFGNO2KdXkXnWiyopY/cBl/XCYVvMiEvw= go1.24.2 arm64 darwin - welcome!
$ x = 10
== Parse ==> x = 10
== Eval  ==> 10
$ y = x * 2 + 5
== Parse ==> y = x * 2 + 5
== Eval  ==> 25
$ println("Hello, Grol!") // Print to stdout
== Parse ==> println("Hello, Grol!")
Hello, Grol!
== Eval  ==> nil
```

#### 2.2. Comments

Grol supports single-line comments starting with `//` and block comments `/* ... */`.

```go
// This is a single-line comment
x = 10 // Assign 10 to x

/*
This is a
multi-line block comment.
*/
y = 20
```

#### 2.3. Data Types & Variables

* **Numbers:** Integers and Floats. Basic arithmetic operators (`+`, `-`, `*`, `/`) work as expected as well as bit operators (or `|`, and `&` and xor `^`) and the compound versions (e.g. `+=` ...).
* **Booleans:** `true` and `false`. Comparison operators (`<=`, `>=`, `==`, `!=`, `>`, `<`) are available.
* **Strings:** Defined with double quotes (`"`). Concatenated with `+`. String indexing accesses bytes, while iteration accesses runes.
* **Assignment:** Use the `=` operator. The `let` keyword is optional.

Note that `*` `+` etc work on strings, arrays and maps to replicate values or concatenate/append/merge respectively.

```go
n = 720            // Integer
pi_approx = 3.14   // Float
is_active = true   // Boolean
message = "Hello" + " " + "Grol" // String concatenation
greeting = "Hello"
println(greeting[0]) // Outputs byte value (e.g., 72 for 'H')
"ABC" * 2 // "ABCABC"
```

#### 2.4. Arrays

Ordered collections of items of potentially different types. Defined with `[]`. Concatenated with `+`.

```go
a = [1, "two", true, 3.14] // Mixed types
b = [5, 6]
c = a + b // c is [1, "two", true, 3.14, 5, 6]
println(a[1]) // Access element by index (0-based) -> "two"
```

#### 2.5. Maps

Ordered key-value stores. Keys and values can be any type, including arrays, maps, or functions. Defined with `{}`. Merged with `+`. Access values using `["key"]` or dot notation `.key` for string keys.

```go
m = {"name": "Grol", "version": 0.29, 7: "lucky"} // Mixed key/value types
println(m["name"])  // -> "Grol"
println(m.version) // -> 0.29 (shorthand for string keys)
println(m[7])       // -> "lucky"

m2 = {"stable": true}
m3 = m + m2 // Merges maps
```

#### 2.6. Trying it

Take any fragment from this page and try it by clicking "Run" below:

{% include /grol_wasm.html %}

### 3. Control Flow

#### 3.1. Conditionals (`if`/`else`)

Standard `if`/`else` structure. The last expression in a block is its result.

```go
fact = func(n) {
    if (n <= 1) { // Condition
        return 1  // Return value if true
    } else {
        n * self(n - 1) // Return value if false (recursion using self)
    }
}
println(fact(5)) // -> 120
```

#### 3.2. Loops (`for`)

Grol provides several `for` loop forms:

* **Condition Loop (like `while`):**
  ```go
  i = 0
  for i < 3 { // Loops while i < 3
      println(i)
      i++ // Increment i
  }
  // Output: 0, 1, 2
  ```
* **Fixed Iterations:**
  ```go
  for 3 { println("Hello") } // Prints "Hello" 3 times
  ```
* **Integer Range:**
  ```go
  for i = 1:4 { println(i) } // Prints 1, 2, 3 (inclusive start, exclusive end)
  ```
  Note that `-3:7` generates the following array even outside of for context: `[-3,-2,-1,0,1,2,3,4,5,6]`

* **Iterable Loop (Arrays, Maps, Strings):**
  ```go
  // Array
  for v = [10, 20, 30] { println(v) } // Prints 10, 20, 30

  // Map (iterates key-value pairs)
  for kv = {"a": 1, "b": 2} { //
      println("Key:", kv.key, "Value:", kv.value) // Access key/value via .key/.value
  }
  // Output: Key: a Value: 1, Key: b Value: 2 (order is preserved)

  // String (iterates runes)
  for c = "Hi😀" { println(c) } // Prints H, i, 😀
  ```
* **`break`** and **`continue`**: Supported within loops.

### 4. Functions

#### 4.1. Defining Functions

Use the `func` keyword. The last evaluated expression is implicitly returned. Explicit `return` is also available.

```go
// Standard definition
func add(x, y) {
    x + y // Implicit return
}

// Assigned to variable
multiply = func(x, y) {
    return x * y // Explicit return
}

println(add(5, 3))      // -> 8
println(multiply(5, 3)) // -> 15
```

#### 4.2. Lambdas (Anonymous Functions)

Functions can be defined anonymously and assigned or called immediately (IIFE). A shorter `=>` syntax is available.

```go
// Assigned lambda
doubler = x => 2 * x  // Short lambda syntax
println(doubler(5)) // -> 10

// Immediately Invoked Function Expression (IIFE)
result = func(n) {
    if n <= 1 { return 1 }
    n * self(n - 1) // Recursion via self()
}(6) // Call immediately with 6
println(result) // -> 720
```

#### 4.3. Closures

Functions capture the environment they are defined in.

```go
func counter(start) {
    state = start
    // Return a lambda that increments the captured 'state'
    () => {
        state = state + 1 // Modify captured variable
        state // Return updated state
    }
}

c1 = counter(10)
println(c1()) // -> 11
println(c1()) // -> 12

c2 = counter(0)
println(c2()) // -> 1 (independent state)
```

#### 4.4. Recursion (`self`)

Functions can call themselves recursively. Anonymous functions use `self` for recursion. Named functions can use their name or `self`.

```go
// Named function recursion
func factorial(n) {
    if (n <= 1) { 1 } else { n * factorial(n - 1) } // or n * self(n-1)
}

// Anonymous function recursion using self
fact_anon = func(n) { if (n <= 1) { 1 } else { n * self(n - 1) } }

println(factorial(5)) // -> 120
println(fact_anon(5)) // -> 120
```

#### 4.5. Variadic Functions

Functions can accept a variable number of arguments using `..`.

```go
func sum_all(..) { // Accept variable arguments
    total = 0
    args = .. // Access arguments as an array
    for i = 0:len(args) {
        total = total + args[i]
    }
    total
}

println(sum_all(1, 2, 3, 4)) // -> 10
```

### 5. Built-ins and `info`

Grol provides built-in functions and keywords. Use the `info` object to inspect the environment.

```go
println(len("hello")) // -> 5 (length of string/array/map)
println(first([10, 20])) // -> 10 (first element of array/string)
println(rest([10, 20, 30])) // -> [20, 30] (rest of array/string)

// Inspect available identifiers, keywords, etc.
println(info.globals)   // List all global IDs
println(info.gofuncs)    // List built-in Go functions
println(info["tokens"])  // Another way to access info map
```

Common built-ins include `print`, `println`, `log`, `len`, `first`, `rest`, `str`, `int`, math functions (`sqrt`, `sin`, `cos`, etc.), `time.now()`, `json`/`unjson`, image manipulation functions (`image.*`), and more. See the Appendix for a more complete list generated from the interpreter itself.

### 6. Macros

Macros allow code generation at parse time using `quote` and `unquote`.

```go
// Example: 'unless' macro
unless = macro(condition, if_false, if_true) {
    quote( // Start quoting - generate code
        if (!(unquote(condition))) { // Unquote condition to evaluate it
            unquote(if_false)       // Unquote block to insert it
        } else {
            unquote(if_true)        // Unquote block to insert it
        }
    ) // End quoting
}

unless(10 > 5, println("Condition is false"), println("Condition is true"))
// Expands to: if (!(10 > 5)) { println("Condition is false") } else { println("Condition is true") }
// Output: Condition is true
```

### 7. File I/O and State

* Run scripts: `grol your_script.gr another.gr`.
* Load/Save state: `load("filename.state")` and `save("filename.state")` manually save/load the interpreter state. REPL auto-saves to `./.gr`.
* There is also a shebang mode to run grol scripts with arguments (`#! /usr/bin/env grol -s` at the top)

### 8. Advanced Features

* **Extensibility:** Add custom Go functions easily.
* **Memoization:** Function calls are automatically memoized where possible.
* **Formatting:** `grol -format your_script.gr` reformats code.
* **Image Library:** Built-in functions for creating and manipulating images (`image.*`).

#### 8.1 Error Handling

Grol reports runtime errors with a message and, if applicable, a stack trace.

```go
// Example causing an error
func level1(){ 1 + "x" } // Type mismatch
func level2(){ level1() }
func level3(){ level2() }
level3()

// Output might look like:
// <err: no PLUS on left=1 right="x", stack below:>
// func level1(){1+"x"}
// func level2(){level1()}
// func level3(){level2()}
```

You can gracefully handle potential errors using the `catch()` function. It evaluates a string containing Grol code and returns a map indicating success or failure.

* If the code runs without error, the map is `{"err": false, "value": <result>}`.
* If the code causes an error, the map is `{"err": true, "value": "<error message>"}`.

```go
// Catching an error
result1 = catch(1 + not_a_variable)
println(result1)
// Output: {"err":true,"value":"identifier not found: not_a_variable"}
println(result1.err)   // -> true
println(result1.value) // -> "identifier not found: not_a_variable"

// Successful execution
result2 = catch(1 + 2)
println(result2)
// Output: {"err":false,"value":3}
println(result2.err)   // -> false
println(result2.value) // -> 3
```

The `error(...)` function can also be used to explicitly trigger an error.

### 9. Examples

The [`examples/`](https://github.com/grol-io/grol/tree/main/examples) directory contains numerous scripts showcasing various features:

* Factorial, Fibonacci (recursive, lambda)
* Array/Map manipulation (`apply`, `keys`)
* Loops (`for`, recursive equivalents)
* Closures/State (`lambda_state`)
* Macros (`sample.gr`)
* Image generation (`image.gr`, `mandelbrot.gr`, `circle.gr`, `bezier_plot.gr`, `vector_graphic_*.gr`)
* Text formatting (`boxed_text.gr`)
* Prime number generation (`prime_*.gr`)

You can run them individually (`grol examples/fib.gr`) or together (`grol examples/*.gr`).

## Built-in (Go implemented) Extensions (`info.gofuncs`)

It's easy to add more (for instance fortio adds `curl` and `fortio.load`, the discord bot messaging related, etc...) but here is
the list included by default (unless some are disabled like IOs for security)

| IO functions | |
|--------------|-|
| `eof` | eof() : returns true if a previous read hit the end of file for stdin
| `exec` | exec(string, ..) : executes a command and returns its stdout, stderr and any error
| `flush` | flush() : flushes output and disable caching/memoization
| `load` | load([string]) : filename (.gr)
| `read` | read([integer, [boolean]]) : reads one line from stdin or just n characters if a number is provided, non blocking if boolean is true
| `run` | run(string, ..) : runs a command interactively
| `save` | save([string]) : filename (.gr)
| `term.size` | term.size() : Returns the size of the terminal

| Image functions | |
|--------------|-|
| `image.add` | image.add(string, string) : merges the 2nd image into the first one, additively with white clipping
| `image.close_path` | image.close_path(string) : close the current path
| `image.cube_to` | image.cube_to(string, float, float, float, float, float, float) : adds a cubic bezier segment
| `image.delete` | image.delete(string) : deletes the named image
| `image.draw` | image.draw(string, array) : draw the path in the color is an array of 3 or 4 elements 0-255
| `image.draw_hsl` | image.draw_hsl(string, array) : draw vector path, color in an array [Hue (0-1), Sat (0-1), Light (0-1)]
| `image.draw_ycbcr` | image.draw_ycbcr(string, array) : draw vector path, color Y'CbCr in an array of 3 elements 0-255
| `image.line_to` | image.line_to(string, float, float) : adds a line segment
| `image.move_to` | image.move_to(string, float, float) : starts a new path and moves the pen to coords
| `image.new` | image.new(string, integer, integer) : create a new image of the name and size, image starts entirely transparent
| `image.png` | image.png(string) : returns the png data of the named image, suitable for base64
| `image.quad_to` | image.quad_to(string, float, float, float, float) : adds a quadratic bezier segment
| `image.save` | image.save(string) : save the named image grol.png
| `image.set` | image.set(string, integer, integer, array) : img, x, y, color: set a pixel in the named image, color is an array of 3 or 4 elements 0-255
| `image.set_hsl` | image.set_hsl(string, integer, integer, array) : img, x, y, color: set a pixel in the named image, color in an array [Hue (0-1), Sat (0-1), Light (0-1)]
| `image.set_ycbcr` | image.set_ycbcr(string, integer, integer, array) : img, x, y, color: set a pixel in the named image, color Y'CbCr in an array of 3 elements 0-255
| `image.size` | image.size(string) : returns a map of image info (also checks for existence, returns nil if not found)
| `image.text` | image.text(string, float, float, float, string, arg6..arg7) : draw text on the image at x,y with size, optional color array [R,G,B] or [R,G,B,A], and optional font variant (regular, bold, italic)
| `image.text_size` | image.text_size(string, float, [string]) : returns width, height and horizontal offset and descent for the given text with size and optional font variant (regular, bold, italic)

| Introspection functions | |
|--------------|-|
| `defun` | defun(string, array, array) : defines a function from name (empty for lambda), arguments, statements (as returned by first/rest)
| `eval` | eval(string) : evaluates a string as grol code
| `format` | format(func) : returns a string, pretty printed function object
| `json` | json(any) : converts an object to a JSON string
| `json_go` | json_go(any, [string]) : optional indent e.g json_go(m, "  ")
| `type` | type(any) : returns the type of an object as a string
| `unjson` | unjson(string) : evaluates a JSON string as grol code

| Math functions | |
|--------------|-|
| `acos` | acos(float) : returns the arccosine of x in radians
| `asin` | asin(float) : returns the arcsine of x in radians
| `atan` | atan(float) : returns the arctangent of x in radians
| `atan2` | atan2(float, float) : returns the arctangent of y/x in radians
| `ceil` | ceil(float) : returns the least integer value greater than or equal to x
| `cos` | cos(float) : returns the cosine of x in radians
| `exp` | exp(float) : returns e raised to the power of x
| `floor` | floor(float) : returns the greatest integer value less than or equal to x
| `int` | int(any) : converts a value to an integer
| `ln` | ln(float) : returns the natural logarithm of x
| `log10` | log10(float) : returns the base-10 logarithm of x
| `max` | max(any, ..) : returns the maximum value among the arguments
| `min` | min(any, ..) : returns the minimum value among the arguments
| `pow` | pow(float, float) : returns base raised to the power of exp
| `rand` | rand([integer]) : returns a random number between 0 and 1, or between 0 and n-1 if n is provided
| `round` | round(float) : returns the nearest integer to x
| `shuffle` | shuffle(array) : randomly reorders elements in an array
| `sin` | sin(float) : returns the sine of x in radians
| `sort` | sort(array) : sorts an array
| `sqrt` | sqrt(float) : returns the square root of x
| `tan` | tan(float) : returns the tangent of x in radians
| `trunc` | trunc(float) : returns the integer value of x

| String functions | |
|--------------|-|
| `base64` | base64(any) : encodes a string to base64
| `bytes` | bytes(string) : returns an array of the utf8 bytes forming the string
| `join` | join(array, [string]) : joins an array of string with the optional separator
| `regexp` | regexp(string, string, [boolean]) : returns true if regular expression (first arg) matches the string (2nd arg), optionally returns an array of matches
| `regsub` | regsub(string, string, [string]) : regexp, input, subst
| `rune_len` | rune_len(string) : returns the number of runes in a string
| `runes` | runes(string, [boolean]) : optionally as array of integers
| `split` | split(string, [string]) : optional separator
| `sprintf` | sprintf(string, ..) : formats a string using the given format and arguments
| `trim` | trim(string, [string]) : trims leading and trailing spaces or characters
| `trim_left` | trim_left(string, [string]) : trims leading spaces or characters
| `trim_right` | trim_right(string, [string]) : trims trailing spaces or characters
| `utf8` | utf8(array, [boolean]) : returns a string from an array of bytes, optionally validating utf8
| `width` | width(string) : returns the display width of a string (accounting for full-width characters)

| Time functions | |
|--------------|-|
| `sleep` | sleep(float) : sleeps for the specified number of seconds
| `time.info` | time.info(float, [string]) : returns detailed information about a time value in seconds since epoch
| `time.now` | time.now() : returns the current time in seconds since epoch
| `time.parse` | time.parse(string, [string]) : parses a time string and returns seconds since epoch

The above tables are automatically produced by [examples/functions_list.gr](https://github.com/grol-io/grol/tree/main/examples/functions_list.gr)

This concludes the basic tour of Grol. Explore the examples and the `info` object in the REPL to learn more!
