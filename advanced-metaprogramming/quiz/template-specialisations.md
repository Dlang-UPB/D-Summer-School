## Question Text

Why cannot we use a single template function with specialisations to aggregate all numeric types?

## Question Answers

- Because floating point and integer types use different representations
+ Because these types do not inherit from a common type
- Because the user could create their own numeric types that we couldn't account for
- Because they use the C runtime, unlike `bool` and `string` which do not exist in C
