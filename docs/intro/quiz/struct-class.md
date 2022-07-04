---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
## Struct vs Class quiz

  {% assign q1_text = "In the previous example, why the class executable is significantly faster?" %}
  {% assign q1_choices = "Classes in D are implemented more efficiently| Structs are stored on the stack data segment, which is slower| Structs are value types, every time we call `get_a0` a new struct with 1000 fields is created| Classes have faster acces to their data" | split: "| " %}
  {% assign q1_feedbacks = "When a variable is **pass by value**, we create a copy of the variable and it's content everytime we use it in a function. So, for structs we are creating a million copies, while for classes only one, hence the implementation with classes is faster.| When a variable is **pass by value**, we create a copy of the variable and it's content everytime we use it in a function. So, for structs we are creating a million copies, while for classes only one, hence the implementation with classes is faster.| Correct| When a variable is **pass by value**, we create a copy of the variable and it's content everytime we use it in a function. So, for structs we are creating a million copies, while for classes only one, hence the implementation with classes is faster." | split: "| " %}
  {% assign q1_correct = 2 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}

