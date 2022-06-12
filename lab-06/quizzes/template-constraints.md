## Question Text

When doesn't `returnIfPrimeParam(25)` compile?

## Question Answers

- Because 25 is not prime
+ Because the parameter value is not known at compile time
- Because `isPrime` is not a template function
- Because its template paremeter is not explicitly specified

## Feedback

While 25 is indeed not prime, this is not the reason the function coll does not compile.
`returnIfPrimeParam(17)` doesn't compile either and 17 is prime.
The reason is that because 25 is a parameter and not a template argument, its value isn't known at compile time.
