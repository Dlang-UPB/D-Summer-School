import std.algorithm.iteration;
import std.algorithm.searching;
import std.array;
import std.ascii;
import std.conv;
import std.digest;
import std.digest.sha;
import std.random;
import std.range;
import std.stdio;
import std.string;
import std.typecons;

import vibe.db.mongo.mongo : connectMongoDB, MongoClient, MongoCollection;
import vibe.data.bson;

import dauth : makeHash, toPassword, parseHash;

struct DBConnection
{
    enum UserRet
    {
        OK,
        ERR_NULL_PASS,
        ERR_USER_EXISTS,
        ERR_INVALID_EMAIL,
        ERR_WRONG_USER,
        ERR_WRONG_PASS,
        NOT_IMPLEMENTED
    }

    this(string dbUser, string dbPassword, string dbAddr, string dbPort, string dbName)
    {
        this.client = connectMongoDB("mongodb://" ~ dbUser ~ ":" ~ dbPassword ~ "@" ~ dbAddr ~ ":" ~ dbPort);
        this.dbName = dbName;
    }

    // Optional helper
    static bool isValidEmail(string email)
    {
        if (email.empty)
        {
            return false;
        }

        auto res = email.find("@");
        // Check that we have some text before @
        // Check that @ is followed . and at least 2 chars after .
        immutable int min_suffix_len = 2;
        if (!res.empty && (email.length != res.length) && (res.find(".").length > min_suffix_len))
        {
            return true;
        }
        return false;
    }

    unittest
    {
        assert(isValidEmail("a@gmail.co"));
        assert(!isValidEmail("@gmail.co"));
        assert(!isValidEmail("a@gmail.o"));
        assert(!isValidEmail("a@gmailo"));
        assert(!isValidEmail("agmailo"));
    }

    UserRet addUser(string email, string username, string password, string name = "", string desc = "")
    {
        if (password.length == 0)
        {
            return UserRet.ERR_NULL_PASS;
        }

        if (!isValidEmail(email))
        {
            return UserRet.ERR_INVALID_EMAIL;
        }

        string collectionName = "users";
        MongoCollection users = client.getCollection(dbName ~ "." ~ collectionName);

        auto res = users.findOne(["_id": email]);
        if (res != Bson(null))
        {
            return UserRet.ERR_USER_EXISTS;
        }

        // TODO: Hash and salt the password before inserting it into the database.
        users.insert(["_id": email,
                      "username": username,
                      "password": password,
                      "name": name,
                      "desc": desc]);

        // Query the database so that the above insertion propagates its effect.
        users.findOne(["_id": email]);

        return UserRet.OK;
    }

    auto getUserData(string email)
    {
        if (!isValidEmail(email))
        {
            return Bson(null);
        }

        string collectionName = "users";
        MongoCollection users = client.getCollection(dbName ~ "." ~ collectionName);

        return users.findOne(["_id": email]);
    }

    string generateUserAccessToken(string email)
    {
        string collectionName = "users";
        MongoCollection users = client.getCollection(dbName ~ "." ~ collectionName);

        auto user = users.findOne(["_id": email]);
        if (user == Bson(null))
        {
            // Return empty string if user does not exist
            return "";
        }

        string token;
        if (user.tryIndex("accessToken").isNull)
        {
            enum defaultPasswordChars = cast(immutable(ubyte)[]) (std.ascii.letters ~ std.ascii.digits);
            token = digest!SHA512(defaultPasswordChars.randomCover).toHexString().to!string();
            user["accessToken"] = token;
            users.update(["_id": email], user);
        }
        else
        {
            token = user["accessToken"].to!string.strip("\"");
        }
        return token;
    }

    string getUserAccessToken(string email)
    {
        string collectionName = "users";
        MongoCollection users = client.getCollection(dbName ~ "." ~ collectionName);

        auto user = users.findOne(["_id": email]);

        string token;
        if ((user != Bson(null)) && (!user.tryIndex("accessToken").isNull))
        {
            token = user["accessToken"].to!string.strip("\"");
        }
        return token;
    }

    UserRet authUser(string email, string password)
    {
        if (password.length == 0)
        {
            return UserRet.ERR_NULL_PASS;
        }

        if (!isValidEmail(email))
        {
            return UserRet.ERR_INVALID_EMAIL;
        }

        string collectionName = "users";
        MongoCollection users = client.getCollection(dbName ~ "." ~ collectionName);

        auto res = users.findOne(["_id": email]);
        if (res == Bson(null))
        {
            return UserRet.ERR_WRONG_USER;
        }

        // TODO: Verify the given password against the hashed password.
        if (res["password"].toString().strip("\"") != password)
        {
            return UserRet.ERR_WRONG_PASS;
        }

        return UserRet.OK;
    }

    UserRet deleteUser(string email)
    {
        if (!isValidEmail(email))
        {
            return UserRet.ERR_INVALID_EMAIL;
        }
        string collectionName = "users";
        MongoCollection users = client.getCollection(dbName ~ "." ~ collectionName);

        users.remove(["_id": email]);
        return UserRet.OK;
    }

    struct File
    {
        @name("_id") BsonObjectID id; // represented as _id in the db
        string userId;
        ubyte[] binData;
        string fileName;
        string digest;
        string securityLevel;
    }

    enum FileRet
    {
        OK,
        FILE_EXISTS,
        ERR_EMPTY_FILE,
        NOT_IMPLEMENTED
    }

    FileRet addFile(string userId, immutable ubyte[] binData, string fileName)
    {
        if (binData.empty)
        {
            return FileRet.ERR_EMPTY_FILE;
        }

        string collectionName = "files";
        MongoCollection files = client.getCollection(dbName ~ "." ~ collectionName);

        File file;
        file.id = BsonObjectID.generate();
        file.userId = userId;
        file.binData ~= binData;
        file.fileName = fileName;
        file.digest ~= digest!SHA512(file.binData).toHexString();

        Nullable!File fileExists = files.findOne!File(["digest": file.digest]);
        if (!fileExists.isNull)
        {
            return FileRet.FILE_EXISTS;
        }

        files.insert(file);
        return FileRet.OK;
    }

    File[] getFiles(string userId)
    {
        string collectionName = "files";
        MongoCollection files = client.getCollection(dbName ~ "." ~ collectionName);

        File[] userFiles;
        foreach(file; files.find!File(["userId": userId]))
        {
            userFiles ~= file;
        }
        return userFiles;
    }

    Nullable!File getFile(string digest)
    in(!digest.empty)
    do
    {
        string collectionName = "files";
        MongoCollection files = client.getCollection(dbName ~ "." ~ collectionName);

        Nullable!File file = files.findOne!File(["digest": digest]);
        return file;
    }

    void deleteFile(string email, string digest)
    in(!digest.empty)
    do
    {
        string collectionName = "files";
        MongoCollection files = client.getCollection(dbName ~ "." ~ collectionName);
        files.remove(["userId": email, "digest": digest]);
    }

    struct Url
    {
        @name("_id") BsonObjectID id; // represented as _id in the db
        string userId;
        string addr;
        string securityLevel;
        string[] aliases;
    }

    enum UrlRet
    {
        OK,
        URL_EXISTS,
        ERR_EMPTY_URL,
        NOT_IMPLEMENTED
    }

    UrlRet addUrl(string userId, string urlAddress)
    {
        if (urlAddress.empty)
        {
            return UrlRet.ERR_EMPTY_URL;
        }

        string collectionName = "urls";
        MongoCollection urls = client.getCollection(dbName ~ "." ~ collectionName);

        Nullable!Url urlExists = urls.findOne!Url(["addr": urlAddress]);
        if (!urlExists.isNull)
        {
            return UrlRet.URL_EXISTS;
        }

        Url url;
        url.id = BsonObjectID.generate();
        url.userId = userId;
        url.addr = urlAddress;

        urls.insert(url);
        return UrlRet.OK;
    }

    Url[] getUrls(string userId)
    {
        string collectionName = "urls";
        MongoCollection urls = client.getCollection(dbName ~ "." ~ collectionName);

        Url[] userUrls;
        foreach(url; urls.find!Url(["userId": userId]))
        {
            userUrls ~= url;
        }
        return userUrls;
    }

    Nullable!Url getUrl(string urlAddress)
    in(!urlAddress.empty)
    do
    {
        string collectionName = "urls";
        MongoCollection urls = client.getCollection(dbName ~ "." ~ collectionName);

        Nullable!Url url = urls.findOne!Url(["addr": urlAddress]);
        return url;
    }

    void deleteUrl(string email, string urlAddress)
    in(!urlAddress.empty)
    do
    {
        string collectionName = "urls";
        MongoCollection urls = client.getCollection(dbName ~ "." ~ collectionName);
        urls.remove(["userId": email, "addr": urlAddress]);
    }

private:
    MongoClient client;
    string dbName;
}
