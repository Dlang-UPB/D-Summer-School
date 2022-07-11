---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
## Memory management

  {% assign q1_text = "Why isn't there a destructor defined for `LinkedListNode` objects?" %}
  {% assign q1_choices = "Because the node contains only 8 bytes and that size is not relevant | Because memory is freed anyway when a program ends | Because we are allocating heap memory with the garbage collector which is automatically freed when it is no longer used | Because we are allocating heap memory which is managed by the OS" | split: "| " %} 
  {% assign q1_feedbacks = "Even if 8 bytes is a small amount, if a lot of nodes are allocated, the used memory may amount to relevant proportions | You might run out of memory before that happens! | Correct! | Heap memory is not managed by the OS specifically; the program manages the allocations" | split: "| " %} 
  {% assign q1_correct = 2 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}
