README
================

## IceCream – Never use print() to debug again

This package is an implementation of the
[icecream](https://github.com/gruns/icecream) package for `R`. A great
part of this document is also adapted.

Do you ever use `print()` to debug your code? Of course you do.
IceCream, or `ic` for short, makes print debugging a little sweeter.

`ic()` is like `print()`, but better:

1.  It prints both expressions/variable names and their values.
2.  It’s 40% faster to type.
3.  Data structures are pretty printed.\*
4.  Output is syntax highlighted.\*
5.  It optionally includes program context: filename, line number, and
    parent function.

Points marked with ’\*’ are yet to come. We’ve just begun!

### Inspect Variables

Have you ever printed variables or expressions to debug your program? If
you’ve ever typed something like

``` r
print(foo("123"))
```

or the more thorough

``` r
print('foo("123")', foo("123"))
```

then `ic()` is here to help. With arguments, `ic()` inspects itself and
prints both its own arguments and the values of those arguments.

``` r
library(icecream)

foo <- function(i) i + 333

ic(foo(123))
## ic | foo(123): [1] 456
```

Similarly,

``` r
d <- list(key = list("one"))
ic(d$key[[1]])
## ic | d$key[[1]]: [1] "one"

klass <- structure(list(attr = "yep"))
ic(klass$attr)
## ic | klass$attr: [1] "yep"
```

Just give `ic()` a variable or expression and you’re done. Easy.

### Inspect Execution

Have you ever used `print()` to determine which parts of your program
are executed, and in which order they’re executed? For example, if
you’ve ever added print statements to debug code like

``` r
foo <- function() {
  print(0)
  first()

  if (something) {
    print(1)
    second()
  } else {
    print(2)
    third()
  }
}
    
```

then `ic()` helps here, too. Without arguments, `ic()` inspects itself
and prints the calling filename, line number, and parent function.

``` r
# example.R
library(icecream)

foo <- function() {
  ic()
  2 + 5

  if (3 < 0) {
    ic()
    7 * 8
  } else {
    ic()
    9^0
  }
}

foo()
## ic| example.R at global::foo 
## ic| example.R at global::foo
```

Just call `ic()` and you’re done. Simple.

### Return Value

`ic()` returns its argument(s), so `ic()` can easily be inserted into
pre-existing code.

``` r
a <- 6
half <- function(i) i / 2
b <- half(ic(a))
## ic | a: [1] 6
ic(b)
## ic | b: [1] 3
```
