---
nav_order: 1
title: Advanced Meta-Programming
has_children: true
---
# Advanced Meta-Programming

> Inspired by [Bradley Chatha's](https://github.com/BradleyChatha) talk at [DConf 2021](https://www.youtube.com/watch?v=0lo-FOeWecA&list=PLIldXzSkPUXXA0Ephsge-DJEY8o7aZMsR&index=9).

In [session 2](../meta-intro/intro-to-meta.md) we introduced the concept of meta-programming and explained its cornerstones: CTFE and templates.
While CTFE and templates are also found in other languages, such as C++, today we will dive deeper into meta-programming and discover more powerful features that are unique to D.

Meta-programming means that a program is able to treat its own code as data.
This means that our code will analyse its data types and change its behaviour accordingly.
We will also write code that will then write itself.
