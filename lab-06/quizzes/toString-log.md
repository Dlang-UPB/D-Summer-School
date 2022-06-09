## Question Text

Why is the log output changed after adding the `toString` function?

## Question Answers

+ because `__traits(allMembers)` also matches methods
- because `toString` is always called due to being `const`
- because `toString` is called when creating the `Boss` object

## Feedback

As its name implies, `__traits(allMembers)` matches **all** members of a structure / class.
This also includes methods, constructors, destructors etc.
Follow the example in the [documentation](https://dlang.org/spec/traits.html#allMembers).
