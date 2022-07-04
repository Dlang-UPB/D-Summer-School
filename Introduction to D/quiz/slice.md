## Question Text

Why, for the previous example, the lengths of a and b are different?

## Question Answers

- `a` and `b` have the same lengths
+ `b` refers the same data as `a`, but it has no length constraints 
- a copy of `a` was saved into `b`, a dynamic array, and then the value 5 was appended to the dynamic array
- operator `~` works for slices, but it has no impact on static arrays

## Feedback

`a` is a static array, so it's length is fixed, but we can still append data in that particular memory zone through a different reference