---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
## Ref vs Value quiz

  {% assign q1_text = "For the previous example, why we weren't able to modify the length of the array but we could modify the content?" %}
  {% assign q1_choices = "a was declared as a static array, hence it's length can't be modified| When we tried to modify the length the array was passed by value, when we modified the actual data the array was passed by reference| The data was not modified, a new array was allocated and the reference was changed.| The length was not modified because the array was passed by value, but the data can be modified because we don't change the reference to it." | split: "| " %}
  {% assign q1_feedbacks = "a contains a length property - a number, and a pointer to data. For both functions a copy of a was created and, at the end of each function, the actual length and pointer were not modified. For the actual data, we are able to modify it as long as we have a reference to it.| a contains a length property - a number, and a pointer to data. For both functions a copy of a was created and, at the end of each function, the actual length and pointer were not modified. For the actual data, we are able to modify it as long as we have a reference to it.| a contains a length property - a number, and a pointer to data. For both functions a copy of a was created and, at the end of each function, the actual length and pointer were not modified. For the actual data, we are able to modify it as long as we have a reference to it| Correct!" | split: "| " %}
  {% assign q1_correct = 3 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}

