---
title: 'Milestone 1 - Implementing the backend'
parent: 'Project: Website for security analysis'
nav_order: 2
---

## Milestone 1 - Implementing the backend

The backend implements a database where all of the information is stored.
We want to track down information about users, files and URLs.
As a consequence, we will be using a database where we will define 3 collections:

1. The users collection which stores the following fields:
    - an email address - a string that represents the unique identifier of user
    - a username - a string that represents the actual name that is publicly posted for a user
    - a password - a string that represents the encrypted password for a user
    - a name - an optional string field that represents the real name of the user
    - a description - an optional string field that represents the description of the user (hobbies, passions etc.)

1. The files collection which stores the following fields:
    - a file id - a number that represents the unique identifier for an entry in this collection
    - a user id - a string that contains the email address of the user that added this file
    - the file contents - a `ubyte[]` that stores the bytes of the file
    - a hash of the file - a string that contains the result of applying a [hash function](https://en.wikipedia.org/wiki/Hash_function) to the file contents
    - threat level - a number representing the degree of maliciousness of the file

1. The URLs collection which stores the following fields:
    - a URL id - a string that represents the unique identifier for an entry in this collection
    - a user id - a string that contains the email address of the user that added this URL
    - an address - a string that contains the actual URL (e.g. "www.google.com")
    - a security level - a number representing the degree ofm maliciousness of the URL
    - a list of aliases - a `string[]` that contains different aliases for this website

The database is implemented using [mongo-db](https://en.wikipedia.org/wiki/MongoDB).
On top of mongo-db we will be using the [vibe-d](https://github.com/vibe-d/vibe.d) framework, which is a a high-performance asynchronous I/O, concurrency and web application toolkit written in D.
By using vibe-d we will be able to both implement the database and create the server (for milestone 2).

### Setup

The initial step is to install [docker](https://docs.docker.com/engine/install/).
We use docker to host the database.

On a Debian system we install docker by running the following command:

```bash
curl -fsSL test.docker.com -o get-docker.sh && sh get-docker.sh
sudo apt-get install -y docker-compose
```

You can add your user to the `docker` group in order to avoid having to use `sudo` when running docker commands:
```bash
sudo usermod -aG docker $USER
```
You need to log out and log back in so that your group membership is re-evaluated.
If you’re running Linux in a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.
More details about this on the official [page](https://docs.docker.com/engine/install/linux-postinstall/).

After you have installed a working version of docker on your system, you will need to run the provided makefile to set up the database.

```bash
cd docker && docker-compose up -d mongo
```

The assignment skeleton contains 2 directories:

- `docker`: which contains the necessary files to configure the mondo database
- `db-conn`: which contains the starting point for this milestone

You will implement this milestone in the `db-conn/source/app.d` file.


To be able to access `mongo` from D we use the `mongodb` library from the `vibe-d` framework.

You need to install `libevent-dev libssl-dev` as the `vibe-d` framework depends on them.
There is no need to install anything else after this, as the rest of the packages are taken care of by the D package manager: `dub`.

To compile and run the application we need to navigate to the `db-conn/` directory and run:

```bash
dub run
```

Do not mind the deprecation messages issued by `dub` when running the command above with the skeleton.
They come from the `vibe-d` library and there's nothing you can do about them.

#### Simplified checker

You can use docker to get all your development environment setup.
Navigate in the `docker` directory and run `make start`:

```bash
cd docker && make start
```

This will start a mongo container and a container that will build your project and run the checker against the mongo container.

You can use the makefile from the `db_conn` directory to achieve the same thing:
```bash
cd db_conn && make start
```

### Working with mongo-db from D

To be able to interact with the database, we need to create a `MongoClient ` object that will represent the connection to the database:

```d
MongoClient client = connectMongoDB("mongodb://root:example@127.0.0.1:27017/");
```

The `connectMongoDB` function expects an URL, in the form of a string, and it establishes a connection that it.
In our case, we use the localhost instance that was set up by docker using the credentials in the `docker/docker-compose.yml`: user - root; pass - example.

Now that we have a `MongoClient` instance we can use it to issue queries to the database.
For example, we can get all of the entries for a particular collection:

```d
MongoCollection users = client.getCollection("testing.users");
```

We can now use the `users` object to alter our collection:

```d
users.insert(["_id": "unique_id", "key1": "demo", "key2": "test"]);
```

Mongo uses [JSON](https://en.wikipedia.org/wiki/JSON#Syntax) to represent objects. In short: a glorified version of a key-value dictionary.
The internal representation of a JSON in Mongo is called a [BSON (Binary JSON)](https://www.mongodb.com/basics/bson) type.
The `mongodb` library automatically converts D associative arrays into [BSONs](https://vibed.org/api/vibe.data.bson/).

Coming back to the above example: it will insert in the users collection a document that consists of 3 key-value pairs.

Note that each mongo document **must** contain an `_id` field, otherwise mongo will automatically generate one.

To query the database for a single result we use the `find` function:

```d
// "non-existent" does no exist in the database so a null Bson is returned
auto oneResult = users.findOne(["key1": "demo", "key2": "non-existent"]);
assert(oneResult == Bson(null));

// will return the first object that has key="key1" and value="demo"
auto oneResult = users.findOne(["key1": "demo"]);
assert(oneResult != Bson(null));
```

A more complex version of querying that returns all the results that match the query constraint is:

```d
auto result = users.find(["key1": "demo", "key2": "test"]);

// find returns a MongoCursor, which is a range
assert(!result.empty);
foreach(r; result)
{
    writeln(r);
}

// foreach will consume the range by calling the popFront method, so now result will be an empty array []
writeln(result);
```

Find returns all of the entries that contain the provided key-value pairings.
The result may be iterated over with a foreach range.
**Be careful! Iterating over the result consumes the data!**
Similarly, you can use the `remove` and `update` functions:

```d
// removes entry that has the key-value pairing provided
users.remove(["_id": "unique_id"]);

users.update(["_id" : "unique_id"],                                               // search criteria
             ["_id": "unique_id", "key1": "demo", "key2": "this_is_not_a_test"]); // updated entry
```

### Tasks

You will have to implement the functions marked with `TODO` in `Project/m1/db_conn/app.d`:

* `addUser` - receives a users credentials and adds them to the user database
* `authUser` - receives a user name and password and returns whether the login is successful or not
* `deleteUser` - receives an email and deletes the user from the user database and updates the files and URLs databases so that the userId is "Deleted_User"
* `addFile` - adds a file to the files database - you must generate a unique identifier
* `getFiles` - receives a userId (an email) and returns all the file entries that belong to the user
* `getFile` - given a file hash, the function will return the first file that it finds in the files database that matches the given hash
* `deleteFile` - given a file hash, removes all of the entries in the files database that match the hash file
* Similarly, for the URL functions.
