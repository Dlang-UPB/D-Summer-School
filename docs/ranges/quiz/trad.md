---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
## Tradition Implementations of Algorithms Quiz

  {% assign q1_text = "What is the shortcoming of the traditional way of implementing data structures/algorithms" %}
  {% assign q1_choices = "It is not optimal from a performance stand point because extra work needs to be done when the data structure is iterated | Algorithms are tied to data structures because the algorithm needs to know the internal interface of the data structure | The code for the data structure is verbose | The data structure is not sufficiently encapsulated" | split: "| " %} 
  {% assign q1_feedbacks = "Performance is an orthogonal topic in this situation | Correct! | The data structure simply contains the fields, so there is no verbosity | The data structure is sufficiently encapsulated since it does not store any fields outside of its instance " | split: "| " %} 
  {% assign q1_correct = 1 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}
