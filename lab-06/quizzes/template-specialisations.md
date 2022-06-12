## Question Text

Why cannot we use template specialisations to aggregate all numeric types?

## Question Answers

- Because floating point and integer types use different representations
+ Because these types do not inherit from a common type
- Because there are too many numeric types and specialising for all of them does not scale well
- Because they use the C runtime, unlike `bool` and `string` which do not exist in C
