---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
## Compile-Ttime Reflection Quiz

  {% assign q1_text = "What is inefficient about the `foreach` loop you've just written?" %}
  {% assign q1_choices = "Using an `Appender` is inefficient compared to appending to a simple string| We use `string`s instead of the lower-level `char*`, which are faster due to being simple pointers| The names of each field is available at compile time, but we extract them at runtime| The loop iterates through the members at runtime when it can do so at compile time" | split: "| " %}
  {% assign q1_feedbacks = "All `__traits` are available at compile time. In our case, the `foreach` loop iterates the members of the structure / class at runtime. However, the compiler has all information to iterate `__traits(allMembers)` itself. Therefore, we can **unroll** this loop and have the compiler iterate the members.| All `__traits` are available at compile time. In our case, the `foreach` loop iterates the members of the structure / class at runtime. However, the compiler has all information to iterate `__traits(allMembers)` itself. Therefore, we can **unroll** this loop and have the compiler iterate the members.| All `__traits` are available at compile time. In our case, the `foreach` loop iterates the members of the structure / class at runtime. However, the compiler has all information to iterate `__traits(allMembers)` itself. Therefore, we can **unroll** this loop and have the compiler iterate the members.| Correct!" | split: "| " %}
  {% assign q1_correct = 3 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}
