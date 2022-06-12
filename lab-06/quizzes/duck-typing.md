## Question Text

How many distinct `fight` functions does the compiler create?

## Question Answers

+ 3 because `fight` is called with 3 different types.
- 1 because all 3 types define the same method `defeat`.
- 3 because it instantiates `fight` with type available.
- 0 because there is no class or structure named `Boss`.

## Feedback

A template is instantiated separately for each different type with which it is used.
`fight` is called with 3 types: `GuardianApe`, `GreatShinobiOwl` and `IsshinTheSwordSaint`, so the compiler creates 3 instances.
