---
title: Structs
parent: Introduction to D
nav_order: 6
---

# Structs

In D, structs are simple aggregations of data and their associated operations on that data:

```d
struct Rectangle
{
    size_t length, width;
    int id;

    size_t area() { return length*width; }
    size_t perimeter() { return 2*(length + width); }
    size_t isSquare() { return length == width; }
    void setId(int id) { this.id = id; }
}
```
