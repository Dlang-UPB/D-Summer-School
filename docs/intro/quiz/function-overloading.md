---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
## Function overloading quiz

What is the output of the following code?
```d
import std.uni : toLower;

int fun(string s)
in (s == s.toLower())
{
    return -42;
}

string fun(int x)
out (; x >= 0)
{
    x *= -42;
    return "Hello World!";
}

void main()
{
    import std.stdio : writeln;

    writeln(fun("hello world!"));
    writeln(fun(-42));
}
```

  {% assign q1_text = "What is the output for the snippet above?" %}
  {% assign q1_choices = "Runtime error at 1st call of fun()| Runtime error at 2nd call of fun()| hello world!| 42| 42 Hello World!" | split: "| " %}
  {% assign q1_feedbacks = "The call `fun('hello world!')` will trigger our first function(that takes as input a string). It respects the `in` contract so it will just  return -42. The second call `fun(-42)` will trigger the second function. At the end of the function the value of `x` will be **-42 * -42**, it respects the `out` contract, so it will return 'Hello World!'| The call `fun('hello world!')` will trigger our first function(that takes as input a string). It respects the `in` contract so it will just  return -42. The second call `fun(-42)` will trigger the second function. At the end of the function the value of `x` will be **-42 * -42**, it respects the `out` contract, so it will return 'Hello World!'| The call `fun('hello world!')` will trigger our first function(that takes as input a string). It respects the `in` contract so it will just  return -42. The second call `fun(-42)` will trigger the second function. At the end of the function the value of `x` will be **-42 * -42**, it respects the `out` contract, so it will return 'Hello World!'| The call `fun('hello world!')` will trigger our first function(that takes as input a string). It respects the `in` contract so it will just  return -42. The second call `fun(-42)` will trigger the second function. At the end of the function the value of `x` will be **-42 * -42**, it respects the `out` contract, so it will return 'Hello World!'| Correct!" | split: "| " %}
  {% assign q1_correct = 4 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}
