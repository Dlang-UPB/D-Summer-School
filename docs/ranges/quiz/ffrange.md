---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
## Forward Range

  {% assign q1_text = "In the `report` function, the `range.take(5)` expression consumes 5 elements. Why isn't this visibible in the second invokation of `report` in the main function? Hint: take a look at the signature of [take](https://dlang.org/phobos/std_range.html#take)" %}
  {% assign q1_choices = "`range` is a struct and is therefore passed by copy to `take` | Since `save` is defined on `FibonacciSeries`, it is automaticallly called whenever an argument is passed | `range` is `const` so modifications on it are discarded | `report` receives a copy of `range`" | split: "| " %} 
  {% assign q1_feedbacks = "Correct! | `save` is never called automatically | Modifications of `const` objects is signaled at compile time. Since the program compiles succesfully, `const` is not the problem. | `report` specifically receives a reference to `range`" | split: "| " %} 
  {% assign q1_correct = 0 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}
