---
nav_exclude: true
---
## Question Text

For the previous example, why we weren't able to modify the length of the array but we could modify the content?

## Question Answers

- a was declared as a static array, hence it's length can't be modified
- When we tried to modify the length the array was passed by value, when we modified the actual data the array was passed by reference
- The data was not modified, a new array was allocated and the reference was changed.
+ The length was not modified because the array was passed by value, but the data can be modified because we don't change the reference to it.

## Feedback

a contains a length property - a number, and a pointer to data.
For both functions a copy of a was created and, at the end of each function, the actual length and pointer were not modified.
For the actual data, we are able to modify it as long as we have a reference to it.
