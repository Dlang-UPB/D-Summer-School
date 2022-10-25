---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
## Slices quiz

  {% assign q1_text = "Why, for the previous example, the lengths of a and b are different?" %}
  {% assign q1_choices = "`a` and `b` have the same lengths | `b` refers the same data as `a`, but it has no length constraints so `5` is simply appended in place | `b` is allocated a new memory region when `5` is concatenated to it | operator `~` works for slices, but it has no impact on static arrays" | split: "| " %}
  {% assign q1_feedbacks = "`a` is a static array, so it's length is fixed, but appending data to it through `b` results in: allocating new memory for `b`, copying the contents of `a` to `b` and adding the new elements (`5` in this case) to the end of the array| `a` is a static array, so it's length is fixed, but appending data to it through `b` results in: allocating new memory for `b`, copying the contents of `a` to `b` and adding the new elements (`5` in this case) to the end of the array| Correct!| `a` is a static array, so it's length is fixed, but appending data to it through `b` results in: allocating new memory for `b`, copying the contents of `a` to `b` and adding new elements (`5` in this case) to the end of the array | split: "| " %}
  {% assign q1_correct = 2 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}
