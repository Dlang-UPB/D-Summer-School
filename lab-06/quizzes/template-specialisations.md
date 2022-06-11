## Question Text

Why cannot we use template specialisations to aggregate all numeric types?

## Question Answers

- because floating point and integer types use different representations
+ because these types do not inherit from a common type
- because there are too many numeric types and specialising for all of them does not scale well
- because they use the C runtime, unlike `bool` and `string` which do not exist in C
