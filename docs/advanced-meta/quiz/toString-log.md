---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
## `toString` Log Quiz

  {% assign q1_text = "Why is the log output changed after adding the `toString` function?" %}
  {% assign q1_choices = "Because `__traits(allMembers)` also matches methods| Because `toString` is always called due to being `const`| Because `toString` is called when creating the `Boss` object" | split: "| " %}
  {% assign q1_feedbacks = "Correct!| As its name implies, `__traits(allMembers)` matches **all** members of a structure / class. This also includes methods, constructors, destructors etc. Follow the example in the [documentation](https://dlang.org/spec/traits.html#allMembers)| As its name implies, `__traits(allMembers)` matches **all** members of a structure / class. This also includes methods, constructors, destructors etc. Follow the example in the [documentation](https://dlang.org/spec/traits.html#allMembers)" | split: "| " %}
  {% assign q1_correct = 0 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}
