---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
## Function Templates vs Regular Functions Quiz

  {% assign q1_text = "Why are there 3 `fooNonTemplate` functions and no `fooTemplate` in the executable?" %}
  {% assign q1_choices = "Because the `fooNonTemplate` is called 3 times, while `fooTemplate` is never called| Because the compiler instantiates all non-template functions, but only the used template functions| " | split: "| " %}
  {% assign q1_feedbacks = "The compiler only instantiates those templates that are actually used. It creates as many instances as there different argument types with a template function is called.| Correct!" | split: "| " %}
  {% assign q1_correct = 2 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}
