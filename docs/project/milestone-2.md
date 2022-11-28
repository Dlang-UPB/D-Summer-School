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
As a consequence, our service needs to hash passwords before saving them in the database.
To better understand how the salting process works, [read this article](https://www.okta.com/blog/2019/03/what-are-salted-passwords-and-password-hashing/).

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

You will need to implement the following functions.
Each of them will forward the request to the backend and, depending on the response, creates the JSON object and the response code.
If the request is successful, the web API function should return a JSON object, as described below.
Unless otherwise stated, for a successful query you need to return a [JSON](https://vibed.org/api/vibe.data.json/) object that contains an informative text of your choosing.
To pack any kind of data into a JSON object, simply use the [serializeToJson](https://vibed.org/api/vibe.data.json/serializeToJson) function.
For situations where the query has failed you must throw an [HTTPStatusException](https://vibed.org/api-0.7.31/vibe.http.common/HTTPStatusException.this).
For any of the methods, you can throw an `HTTPStatus.internalServerError` `HTTPStatusException` in any scenario not described below.

All methods that you'll have to implement can be grouped into 2 categories: those that require authentication and those that don't.
In the [VirusTotalAPIRoot interface](https://github.com/Dlang-UPB/PCLP4-internal/blob/main/m2/rest_api/source/virus_total.d#L19), you'll see that the former methods have an `@anyAuth` tag (also called a [user-defined attribute (UDA)](https://dlang.org/spec/attribute.html#UserDefinedAttribute)), while the latter have a `@noAuth` UDA.
The `@noAuth` methods can be queried without being logged in.
The `@anyAuth` ones, however, require a valid user to be logged in before the method can be executed.
**If the user is not logged in, each `@anyAuth` will return `HTTPStatus.unauthorized` by default.**
The login mechanism was described in the ["Access tokens"](#access-tokens) section.
The checker already takes care of this by adding the required access token whenever it's needed. 

#### addUser

Situations where `addUser` may fail:

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
- wrong user/password: `HTTPStatus.unauthorized` is returned

#### deleteUser

`deleteUser` may fail when an invalid email is given.
In this case, `HTTPStatus.badRequest` is returned

#### addUrl

Situations to consider:

- URL exists: `HTTPStatus.ok` is returned.
Adding an existing URL is not considered an error
- empty url: `HTTPStatus.badRequest` is returned

#### deleteUrl

If the URL address is empty, you should return an `HTTPStatus.badRequest` message.

#### getUrlInfo

If the URL returned by the DB client is `null`, you should return an `HTTPStatus.notFound` message.
Otherwise, you should serialise this returned URL to a JSON object.

#### getUserUrls

This method cannot fail.
In case no URL exist for the currently logged user, a JSON object comprised of an empty list is returned.

#### addFile

Situations to consider:

- the file is empty: `HTTPStatus.badRequest` is returned
- the file exists: `HTTPStatus.ok` is returned.
Similarly to URLs, adding an existing file is not considered an error

#### getFileInfo

If the file returned by the Mongo client is `null`, you should return an `HTTPStatus.notFound` response.
Otherwise, you should serialise this returned file to a JSON object.

#### getUserFiles

This method cannot file, similarly to `getUserUrls`.
In the same fashion, you should return a JSON-serialised empty list in case the user has no files.

#### deleteFile

If the digest of the file is an empty string, `HTTPStatus.badRequest` is returned.

#### Password hashing

The [db_conn.d](https://github.com/Dlang-UPB/PCLP4/blob/master/Project/m2/rest_api/source/db_conn.d) file already contains the methods `addUser` and `authUser` methods.
However, the implementations are unsafe since they don't hash the password before inserting it into the database.
You need to add this logic using the functions exposed by the [dauth](https://code.dlang.org/packages/dauth) library.
Specifically, you can use the following functions:

- `toPassword`: converts a string to a `Password` object used by dauth, without encrypting it
- `makeHash`: hashes and salts the password.
Takes a `Password` object as input
- `parseHash`: converts a hashed and salted password string to a `Password` object

