---
title: 'Milestone 2 - Implementing the web API'
parent: 'Project: Website for security analysis'
nav_order: 3
---

## Milestone 2 - Implementing the web API

Now that our database is up and runnnig, we need to create the code that connects the user facing interface with the backend.
This means that we need to have a server running that accepts requests from the user interface, it forwards them to the backend and then delivers back a response.
Most of the time, the middleware extracts the user input and creates the appropriate query that is passed to the backend.
However, there are situations where some actions need to be taken on the middleware side.

### Setup

The skeleton for this assignment can be found [here](https://github.com/Dlang-UPB/PCLP4/tree/master/Project/m2).
The skeleton contains:

- the Makefile that is identical to the one used in M1
- the docker-compose.yml that contains the setup for the docker instance (same as M1)
- the `rest_tester` directory that contains the checker.
Feel free to explore the tester to better understand how the entire infrastructure works/
- the `rest_api` directory: this is where you will do the work.

To run the tester:

```bash
make start
```

The `rest_api/source` directory contains the following files:

- `app.d` - contains the main function of your application which simply creates a connection to the database, starts the middleware server (which you must implement) and waits for requests.
You do not have to modify this file.

- `db_conn.d` - this contains the reference implementation of M1. You can use this implementation or your own.
**However, the checker assumes that a collection called `testing.users` with the fields `_id` and `password` exists.**
**If you are not using the reference implementation, make sure that this table exists and that the email is the unique identifier and the password field is called `password`.**

- `virus_total.d` - this file contains the implementation of the middle ware server.
This is where you must do all your hard work.

### What you need to know to solve this assignment

#### HTTP response codes

We highly recommend that [you read this](https://developer.mozilla.org/en-US/docs/learn/common_questions/what_is_a_web_server.) before moving forward.

Our middleware server receives and serves HTTP queries.
For each query we need to perform one or multiple actions and return a response.
This response contains 2 parts:

- a json object that represents the content requested by the query
- a number that represents a response code, which represents the status of the query (whether the query was incorrect, or the query was serviced, or the query was partially serviced etc.).
`vibe.d` encapsulates a response code in a [HTTPStatus](https://vibed.org/api/vibe.http.status/HTTPStatus) object.

#### Hashing passwords

Passwords cannot be stored in plain text for [obvious reasons](https://www.passcamp.com/blog/dangers-of-storing-and-sharing-passwords-in-plaintext/).
As a consequence, our service needs to hash passwords before saving them in the database. To better understand how the salting process works, [read this article](https://www.okta.com/blog/2019/03/what-are-salted-passwords-and-password-hashing/).

#### Access tokens

Traditionally, HTTP requests are stateless, which means that 2 queries cannot be correlated.
However, this makes it difficult for systems with authentication (like, literally, any system that requires an account) to operate, you cannot know if the query comes from an authenticated user or not.
To fix this issue, once a user has been logged in, an access token is generated for him/her/them.
The token is then handed over to the user via the response code.
The user needs to provide the token for each of his/her/their request.
This access token is then included in each HTTP query.

The generation and storing of the access token is already implemented in our reference implementation of M1.
**IF YOU USE YOUR OWN IMPLEMENTATION, YOU WILL NEED TO USE THE [generateUserAccessToken](https://github.com/Dlang-UPB/PCLP4/blob/master/Project/m2/rest_api/source/db_conn.d#L113) and [getUserAccessToken](https://github.com/Dlang-UPB/PCLP4/blob/master/Project/m2/rest_api/source/db_conn.d#L140) functions.**

### TODOs

You will need to implement the following functions:

#### addUser

Forwards the request to the backend and, depending on the response, creates the JSON object and the reponse code.
For a successful query you need to return a [JSON](https://vibed.org/api/vibe.data.json/) object that contains an informative text of your choosing.
To pack any kind of data into a JSON object, simply use the [serializeToJson](https://vibed.org/api/vibe.data.json/serializeToJson) function.
For situations where the query has failed you must throw an [HTTPStatusException](https://vibed.org/api-0.7.31/vibe.http.common/HTTPStatusException.this).
The situations where an `addUser` query may fail are:

- invalid email: `HTTPStatus.badRequest` is returned
- null password: `HTTPStatus.badRequest` is returned
- user exists: `HTTPStatus.unauthorized` is returned
- any other exception: `HTTPStatus.internalServerError` is returned

The error message may be any of your choosing, but please keep it informative.

#### authUser

Same as above, except that in case of success, it needs to generate and return the user access token. In case of successful authentication, a JSON that contains `["AccessToken" : actualToken]` is returned.

Situations where `authUser` may fail:

- invalid email: `HTTPStatus.badRequest` is returned
- null password: `HTTPStatus.badRequest` is returned
- 
