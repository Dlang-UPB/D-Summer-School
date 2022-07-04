---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
## Struct vs Class Output quiz

  {% assign q1_text = "What is the cause of the difference between the outputs in the previous struct-class example?" %}
  {% assign q1_choices = "There is a bug in the struct implementation| Structs are passed to functions by value, classes are passed by reference| The struct was not correctly instantiated, so the default int value was printed| Classes don't have a deterministic behavior in the given example" | split: "| " %}
  {% assign q1_feedbacks = "This comes to the fundamenta difference between classes and structs. Structs are passed by value to functions, meaning that if we pass a struct to a function a copy of it will be created and used, and the actual struct will be unmodified| Correct| This comes to the fundamenta difference between classes and structs. Structs are passed by value to functions, meaning that if we pass a struct to a function a copy of it will be created and used, and the actual struct will be unmodified| This comes to the fundamenta difference between classes and structs. Structs are passed by value to functions, meaning that if we pass a struct to a function a copy of it will be created and used, and the actual struct will be unmodified" | split: "| " %}
  {% assign q1_correct = 1 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}

