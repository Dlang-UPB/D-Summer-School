import std.algorithm.searching;
import std.conv;
import std.digest;
import std.digest.sha;
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
        // TODO
    }

    UserRet addUser(string email, string username, string password, string name = "", string desc = "")
    {
        // TODO
        return UserRet.NOT_IMPLEMENTED;
    }

    UserRet authUser(string email, string password)
    {
        // TODO
        return UserRet.NOT_IMPLEMENTED;
    }

    UserRet deleteUser(string email)
    {
        // TODO
        return UserRet.NOT_IMPLEMENTED;
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
        // TODO
        return FileRet.NOT_IMPLEMENTED;
    }

    File[] getFiles(string userId)
    {
        // TODO
        return [File()];
    }

    Nullable!File getFile(string digest)
    in(!digest.empty)
    do
    {
        // TODO
        Nullable!File file;
        return file;
    }

    void deleteFile(string digest)
    in(!digest.empty)
    do
    {
        // TODO
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
        // TODO
        return UrlRet.NOT_IMPLEMENTED;
    }

    Url[] getUrls(string userId)
    {
        // TODO
        return [Url()];
    }

    Nullable!Url getUrl(string urlAddress)
    in(!urlAddress.empty)
    do
    {
        // TODO
        Nullable!Url url;
        return url;
    }

    void deleteUrl(string urlAddress)
    in(!urlAddress.empty)
    do
    {
        // TODO
    }
}
