---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
## `if` vs `static if` Quiz

  {% assign q1_text = "Why is the message `20 is prime!... Wait, what?` also printed?" %}
  {% assign q1_choices = "Because it is printed inside a regular `if` body, which the compiler doesn't evaluate| Because the code in a `unittest` block is alwats generated| Because the `isPrime` function contains a bug" | split: "| " %}
  {% assign q1_feedbacks = "Correct!| The compiler only evaluates and generates code according to `static if`s, not regular `if`s. The bodies of regular `if`s are always generated| The compiler only evaluates and generates code according to `static if`s, not regular `if`s. The bodies of regular `if`s are always generated| The compiler only evaluates and generates code according to `static if`s, not regular `if`s. The bodies of regular `if`s are always generated" | split: "| " %}
  {% assign q1_correct = 0 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}
