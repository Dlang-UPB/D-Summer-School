---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
## Duck Typing Quiz

  {% assign q1_text = "How many distinct `fight` functions does the compiler create?" %}
  {% assign q1_choices = "3 because `fight` is called with 3 different types| 1 because all 3 types define the same method `defeat`| 3 because it instantiates `fight` with type available| 0 because there is no class or structure named `Boss`" | split: "| " %}
  {% assign q1_feedbacks = "Correct!| A template is instantiated separately for each different type with which it is used. `fight` is called with 3 types: `GuardianApe`, `GreatShinobiOwl` and `IsshinTheSwordSaint`, so the compiler creates 3 instances.| A template is instantiated separately for each different type with which it is used. `fight` is called with 3 types: `GuardianApe`, `GreatShinobiOwl` and `IsshinTheSwordSaint`, so the compiler creates 3 instances.| A template is instantiated separately for each different type with which it is used. `fight` is called with 3 types: `GuardianApe`, `GreatShinobiOwl` and `IsshinTheSwordSaint`, so the compiler creates 3 instances." | split: "| " %}
  {% assign q1_correct = 1 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}
