---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
## String Mixins Quiz

  {% assign q1_text = "Why does the `static foreach` in `string_mixins.d` compile just fine despite it not being part of a function?" %}
  {% assign q1_choices = "Because `sizes` and `lengths` are `enum`s and thus only available at compile time| Because they define structures, which must be available at compile time| Because the loop and the `mixin` are evaluated at compile time, regardless of where they are placed| Because code defined inside the global scope is always executed" | split: "| " %}
  {% assign q1_feedbacks = "All `__traits` are available at compile time. In our case, the `foreach` loop iterates the members of the structure / class at runtime. However, the compiler has all information to iterate `__traits(allMembers)` itself. Therefore, we can **unroll** this loop and have the compiler iterate the members.| All `__traits` are available at compile time. In our case, the `foreach` loop iterates the members of the structure / class at runtime. However, the compiler has all information to iterate `__traits(allMembers)` itself. Therefore, we can **unroll** this loop and have the compiler iterate the members.| Correct!| All `__traits` are available at compile time. In our case, the `foreach` loop iterates the members of the structure / class at runtime. However, the compiler has all information to iterate `__traits(allMembers)` itself. Therefore, we can **unroll** this loop and have the compiler iterate the members." | split: "| " %}
  {% assign q1_correct = 2 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}
