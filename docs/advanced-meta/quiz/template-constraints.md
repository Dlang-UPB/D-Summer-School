---
nav_exclude: true
---
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

## Template Constraints Quiz

  {% assign q1_text = "When doesn't `returnIfPrimeParam(25)` compile?" %}
  {% assign q1_choices = "Because 25 is not prime| Because the parameter value is not known at compile time| Because `isPrime` is not a template function| Because its template paremeter is not explicitly specified" | split: "| " %}
  {% assign q1_feedbacks = "While 25 is indeed not prime, this is not the reason the function coll does not compile. `returnIfPrimeParam(17)` doesn't compile either and 17 is prime. The reason is that because 25 is a parameter and not a template argument, its value isn't known at compile time.| Correct!| While 25 is indeed not prime, this is not the reason the function coll does not compile. `returnIfPrimeParam(17)` doesn't compile either and 17 is prime. The reason is that because 25 is a parameter and not a template argument, its value isn't known at compile time.| While 25 is indeed not prime, this is not the reason the function coll does not compile. `returnIfPrimeParam(17)` doesn't compile either and 17 is prime. The reason is that because 25 is a parameter and not a template argument, its value isn't known at compile time." | split: "| " %}
  {% assign q1_correct = 0 %}
  {% include mc-quiz.html text=q1_text choices=q1_choices answer=q1_correct feedback=q1_feedbacks %}
