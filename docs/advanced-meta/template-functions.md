---
title: Template Functions
parent: Advanced Meta-Programming
nav_order: 4
---
# Template Functions

In [session 2](../meta-intro/templates.md) we learned about templates.
They allow us to write more flexible functions (and not only functions) that may receive arguments of different types without requiring us to specify those types.
In order to fit this, the compiler generates a different instance of the template function for each different tuple of types with which it is called.
This sounds complicated, but it's not.

## Demo

Look at the code in `demo/template-functions/template_functions.d` and do not modify it yet.
Use the script `get_foo_symbols.sh` simply `nm` to count the `foo` functions.

[Quiz](./quiz/template-vs-regular-functions.md)

There are many interesting things to note here:
1. Templates allow us to merge multiple similar functions into the same implementation.
1. Both `fooNonTemplate` and `fooTemplate` appear with different names in the executable file.
This is called name mangling and its purpose is to differentiate between **function overloads** (functions with the same name and return types, but different parameters).
If not for name mangling, we couldn't define 3 `fooNonTemplate` functions that take 3 arguments different, nor could we instantiate `fooTemplate` with different argument types.
1. No matter how many times one calls a regular non-template function, the executable file will always contain **one** instance of that function.
In contrast, the executable will contain as many **template instances** as there are different argument types with which that template is used.

## Practice

Uncomment the lines specified in `demo/template-functions/template_functions.d` and recount the number of `foo*` symbols.
Notice that now there are 3 more `foo*` functions.
```
_D18template_functions14fooNonTemplateFAyaZv
_D18template_functions14fooNonTemplateFdZv
_D18template_functions14fooNonTemplateFiZv
_D18template_functions__T11fooTemplateTAyaZQsFNfQjZv
_D18template_functions__T11fooTemplateTdZQqFNfdZv
_D18template_functions__T11fooTemplateTiZQqFNfiZv
```
As you can see, their mangled names are different because they are created based on argument types.

## Logger

Up to now, our logger contains lots of functions: one for each type of data that we've logged so far.
On its own, this is not necessarily a bad thing.
A function should _do one thing and do it well_.
And our `log` functions abide by this rule.

However, this rule does not imply duplicate code.
Probably each `log` function that logs numerical data looks something like this:
```d
string log(<type> value, LogLevel level, string file = __FILE__)
{
    return makeHeader(level, file) ~ value.to!string;
}
```
Notice that the body of all these functions is identical.
As we discussed above, this is the ideal scenario in which to use templates.
Do so and "merge" these functions into a single one that handles all numeric types.