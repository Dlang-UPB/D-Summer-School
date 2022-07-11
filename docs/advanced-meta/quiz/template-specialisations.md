---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
## Template Specialisations Quiz

  {% assign q1_text = "Why cannot we use a single template function with specialisations to aggregate all numeric types?" %}
  {% assign q1_choices = "Because floating point and integer types use different representations| Because these types do not inherit from a common type| Because the user could create their own numeric types that we couldn't account for| Because they use the C runtime, unlike `bool` and `string` which do not exist in C" | split: "| " %}
  {% assign q1_feedbacks = "Incorrect!| Correct!| Incorrect!| Incorrect!" | split: "| " %}
  {% assign q1_correct = 1 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}
