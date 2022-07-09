---
title: String Mixins 
parent: Improvements
nav_order: 2
---
# String Mixins

Up to now, you've probably used `__traits(getMember, obj, member)` or some other `__traits` for obtaining `obj.member`.
While this approach is definitely correct, it is not so expressive.
We can use CTFE once more to make our code even more readable while maintaining the same functionality.

In addition to CTFE, we need another D construct which is evaluated at compile time: [string mixins](https://dlang.org/articles/mixin.html).
In essence, they allow us to write strings which are then compiled into D code.
With string mixins, we can write code that writes itself.

Look at the code in `demo/string-mixins/string_mixins.d`.
As always, compile and run it.
This time, the `unittest` fails.
Understand the code and fix the `unittest`.

[Quiz](./quizzes/string-mixins.md)

For our use case with the logger, we need something simpler.
Simply rewrite `__traits(getMember, obj, member)` using a string mixin.
