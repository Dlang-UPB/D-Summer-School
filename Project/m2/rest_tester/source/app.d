import std.algorithm.mutation;
import std.conv;
import std.digest;
import std.digest.sha;
import std.json;
import std.range;
import std.stdio;

import dauth : makeHash, toPassword, parseHash;
import vibe.d : serializeToJsonString, parseJsonString, HTTPStatus;
import vibe.d : connectMongoDB, MongoClient, MongoCollection, serializeToJsonString, parseJsonString, deserializeJson;
import vibe.data.bson;
import requests;

enum outputLength = 80;
enum maxPoints = 100;
string userAccessToken;

enum virusTotalEndpoint = "http://rest_api:8080/api/v1";

enum signupEndpoint = virusTotalEndpoint ~ "/signup";
enum loginEndpoint = virusTotalEndpoint ~ "/login";
enum deleteUserEndpoint = virusTotalEndpoint ~ "/delete_user";

enum addUrlEndpoint = virusTotalEndpoint ~ "/add_url";
enum urlInfoEndpoint = virusTotalEndpoint ~ "/url_info";
enum userUrlsEndpoint = virusTotalEndpoint ~ "/user_urls";
enum deleteUrlEndpoint = virusTotalEndpoint ~ "/delete_url";

enum addFileEndpoint = virusTotalEndpoint ~ "/add_file";
enum fileInfoEndpoint = virusTotalEndpoint ~ "/file_info";
enum userFilesEndpoint = virusTotalEndpoint ~ "/user_files";
enum deleteFileEndpoint = virusTotalEndpoint ~ "/delete_file";

enum dbName = "testing";

bool signupIsImplemented;

private int printTestResult(string test, bool result, int points,
    int length = outputLength)
{
    string output = "Test " ~ test;
    string pointsStr = points.to!string();
    string resultStr = (result ? "PASSED [" ~ pointsStr  : "FAILED [0") ~ '/' ~
        pointsStr ~ " points]";

    writeln(output ~
        repeat(".", length - output.length - resultStr.length).array.join() ~
        resultStr);

    return result ? points : 0;
}

private void printTestSuiteHeader(string testSuite)
{
    writeln(repeat("=", outputLength).array.join());
    writeln("Testing ", testSuite, " functions:");
}

private void initTestSuite(string testSuite)
{
    printTestSuiteHeader(testSuite);

    postContent(signupEndpoint,
        `{"userEmail": "edi@gmail.com", "username": "edi", "password": "aaa"}`,
        "application/json");
    auto rs = Request().post(loginEndpoint,
        `{"userEmail": "edi@gmail.com", "password": "aaa"}`,
        "application/json");
    auto jsonContent = rs.responseBody.toString().parseJsonString();
    userAccessToken = jsonContent["AccessToken"].to!string();
}

private void endTestSuite()
{
    auto rq = Request();
    rq.addHeaders(["AccessToken": userAccessToken]);
    rq.post(deleteUserEndpoint,
        `{"userEmail": "edi@gmail.com"}`, "application/json");
}

private bool isPasswordHashed(string email, string password)
{
    enum collectionName = "users";

    auto client = connectMongoDB("mongodb://root:example@mongo:27017");
    MongoCollection users = client.getCollection(dbName ~ "." ~ collectionName);

    auto res = users.findOne(["_id": email]);

    if (res == Bson(null))
    {
        return false;
    }

    auto dbPass = res["password"].toString().strip('\"');
    auto userSalt = parseHash(dbPass).salt;
    auto inputPassHash = makeHash(toPassword(password.dup), userSalt);

    return dbPass == inputPassHash.toString();
}

private void testUserFunctions(ref uint points)
{
    printTestSuiteHeader("user");

    auto rq = Request();

    // Test `/signup`
    auto rs = rq.post(signupEndpoint,
        `{"userEmail": "edigmail.com", "username": "edi", "password": "aaa"}`,
        "application/json");
    points += printTestResult("`/signup` invalid email",
        rs.code == HTTPStatus.badRequest, 3);

    rs = rq.post(signupEndpoint,
        `{"userEmail": "edi@gmail.com", "username": "edi", "password": ""}`,
        "application/json");
    points += printTestResult("`/signup` null password",
        rs.code == HTTPStatus.badRequest, 3);

    rs = rq.post(signupEndpoint,
        `{"userEmail": "edi@gmail.com", "username": "edi", "password": "aaa"}`,
        "application/json");
    points += printTestResult("`/signup` ok", rs.code == HTTPStatus.ok, 3);

    bool passwordIsHashed = isPasswordHashed("edi@gmail.com", "aaa");
    points += printTestResult("`/signup` password hashed", passwordIsHashed, 5);

    signupIsImplemented = rs.code == HTTPStatus.ok && passwordIsHashed;

    // If the password is not hashed, the rest of the tests are failed automatically.
    rs = rq.post(signupEndpoint,
        `{"userEmail": "edi@gmail.com", "username": "edi", "password": "aaa"}`,
        "application/json");
    points += printTestResult("`/signup` existing user",
        rs.code == HTTPStatus.unauthorized && signupIsImplemented, 3);

    // Test `/login`
    rs = rq.post(loginEndpoint,
        `{"userEmail": "edigmail.com", "password": "aaa"}`, "application/json");
    points += printTestResult("`/login` invalid email",
        rs.code == HTTPStatus.badRequest, 3);

    rs = rq.post(loginEndpoint,
        `{"userEmail": "edi@gmail.com", "password": ""}`, "application/json");
    points += printTestResult("`/login` null password",
        rs.code == HTTPStatus.badRequest, 3);

    rs = rq.post(loginEndpoint,
        `{"userEmail": "edi@gmail.com", "password": "abc"}`,
        "application/json");
    auto jsonContent = rs.responseBody.toString().parseJsonString();
    points += printTestResult("`/login` wrong password",
        rs.code == HTTPStatus.unauthorized && signupIsImplemented, 3);

    rs = rq.post(loginEndpoint,
        `{"userEmail": "edi@gmail.com", "password": "aaa"}`,
        "application/json");
    jsonContent = rs.responseBody.toString().parseJsonString();
    points += printTestResult("`/login` ok",
        rs.code == HTTPStatus.ok, 4);

    // Test `/delete_user`
    userAccessToken = jsonContent["AccessToken"].to!string();
    rq.addHeaders(["AccessToken": userAccessToken]);

    rs = rq.post(deleteUserEndpoint, `{"userEmail": "edigmail.com"}`,
        "application/json");
    points += printTestResult("`/delete_user` unauthorized email",
        rs.code == HTTPStatus.unauthorized && signupIsImplemented, 3);

    rs = rq.post(deleteUserEndpoint, `{"userEmail": "edi@gmail.com"}`,
        "application/json");
    points += printTestResult("`/delete_user` ok", rs.code == HTTPStatus.ok, 3);

    rs = rq.post(loginEndpoint,
        `{"userEmail": "edi@gmail.com", "password": "aaa"}`,
        "application/json");
    points += printTestResult("`/login` deleted user",
        rs.code == HTTPStatus.unauthorized && signupIsImplemented, 4);
}

private void testUrlFunctions(ref uint points)
{
    initTestSuite("url");

    auto rq = Request();

    // Test `add_url`
    auto rs = rq.post(addUrlEndpoint,
        `{"userEmail": "edi@gmail.com", "urlAddress": "123.net"}`,
        "application/json");
    points += printTestResult("`/add_url` no access token",
        rs.code == HTTPStatus.unauthorized && signupIsImplemented, 3);

    // AccessToken required for post actions
    rq.addHeaders(["AccessToken": userAccessToken]);
    rs = rq.post(addUrlEndpoint,
        `{"userEmail": "edi@gmail.com", "urlAddress": "123.net"}`,
        "application/json");
    points += printTestResult("`/add_url` ok", rs.code == HTTPStatus.ok, 3);

    rs = rq.post(addUrlEndpoint,
        `{"userEmail": "edi@gmail.com", "urlAddress": ""}`, "application/json");
    points += printTestResult("`/add_url` empty url",
        rs.code == HTTPStatus.badRequest, 3);

    rs = rq.post(addUrlEndpoint,
        `{"userEmail": "edi@gmail.com", "urlAddress": "123.net"}`,
        "application/json");
    // Uploading an existing URL will still return OK
    points += printTestResult("`/add_url` duplicate url",
        rs.code == HTTPStatus.ok, 3);

    // Test `url_info`
    rs = rq.get(urlInfoEndpoint, ["urlAddress": "123.net"]);
    auto json = rs.responseBody.toString().parseJsonString();
    points += printTestResult("`/url_info` existing url",
        rs.code == HTTPStatus.ok && json["addr"] == "123.net" &&
        json["aliases"].deserializeJson!(int[])() == [] &&
        json["userId"] == "edi@gmail.com", 3);

    rs = rq.get(urlInfoEndpoint, ["urlAddress": "nonexistent123.net"]);
    points += printTestResult("`/url_info` nonexistent url",
        rs.code == HTTPStatus.notFound, 3);

    rs = rq.get(userUrlsEndpoint, ["userEmail": "edi@gmail.com"]);
    if (rs.code == HTTPStatus.ok)
    {
        json = rs.responseBody.toString().parseJsonString()[0];
        points += printTestResult("`/user_urls` existing email",
            json["addr"] == "123.net" &&
            json["aliases"].deserializeJson!(int[])() == [] &&
            json["userId"] == "edi@gmail.com", 3);
    }
    else
        points += printTestResult("`/user_urls` existing email", false, 3);

    rs = rq.get(userUrlsEndpoint, ["userEmail": ""]);
    points += printTestResult("`/user_urls` empty email",
        rs.code == HTTPStatus.ok && rs.responseBody.toString() == `[]`, 3);

    rs = rq.post(deleteUrlEndpoint,
        `{"userEmail": "edi@gmail.com", "urlAddress": "123.net"}`,
        "application/json");
    points += printTestResult("`/delete_url` existing url",
        rs.code == HTTPStatus.ok, 3);

    rs = rq.get(urlInfoEndpoint, ["urlAddress": "123.net"]);
    points += printTestResult("`/url_info` deleted url",
        rs.code == HTTPStatus.notFound, 3);

    endTestSuite();
}

private void testFileFunctions(ref uint points)
{
    initTestSuite("files");

    auto rq = Request();

    // Test `/add_file`
    auto rs = rq.post(addFileEndpoint,
        `{"userEmail": "edi@gmail.com", "binData": [1, 2, 3, 4, 6, 7], "fileName": "abc.txt"}`,
        "application/json");
    points += printTestResult("`/add_file` no access token",
        rs.code == HTTPStatus.unauthorized && signupIsImplemented, 3);

    // AccessToken required for post actions
    rq.addHeaders(["AccessToken": userAccessToken]);
    rs = rq.post(addFileEndpoint,
        `{"userEmail": "edi@gmail.com", "binData": [1, 2, 3, 4, 6, 7], "fileName": "abc.txt"}`,
        "application/json");
    points += printTestResult("`/add_file` ok", rs.code == HTTPStatus.ok, 3);

    rs = rq.post(addFileEndpoint,
        `{"userEmail": "edi@gmail.com", "binData": [1, 2, 3, 4, 6, 7], "fileName": "abc.txt"}`,
        "application/json");
    // Uploading an existing file will still return OK
    points += printTestResult("`/add_file` duplicate file",
        rs.code == HTTPStatus.ok, 3);

    rs = rq.post(addFileEndpoint,
        `{"userEmail": "edi@gmail.com", "binData": [], "fileName": "abc.txt"}`,
        "application/json");
    points += printTestResult("`/add_file` empty file",
        rs.code == HTTPStatus.badRequest, 3);

    // Test `/file_info`
    ubyte[] binData = [1, 2, 3, 4, 6, 7];
    auto dataDigest = digest!SHA512(binData).toHexString().to!string;
    rs = rq.get(fileInfoEndpoint, ["fileSHA512Digest": dataDigest]);
    Json json;
    if (rs.code == HTTPStatus.ok)
    {
        json = rs.responseBody.toString().parseJsonString();
        points += printTestResult("`/file_info` existing email",
            json["fileName"] == "abc.txt" &&
            json["userId"] == "edi@gmail.com" &&
            json["binData"].deserializeJson!(ubyte[])() == binData, 3);
    }
    else
        points += printTestResult("`/file_info` existing email", false, 3);

    rs = rq.get(fileInfoEndpoint, ["fileSHA512Digest": dataDigest ~ "invalid"]);
    points += printTestResult("`/file_info` invalid digest",
        rs.code == HTTPStatus.notFound, 3);

    // Test `/user_files`
    rs = rq.get(userFilesEndpoint, ["userEmail": "edi@gmail.com"]);
    if (rs.code == HTTPStatus.ok)
    {
        json = rs.responseBody.toString().parseJsonString()[0];
        points += printTestResult("`/user_files` ok",
            rs.code == HTTPStatus.ok && json["fileName"] == "abc.txt" &&
            json["userId"] == "edi@gmail.com" &&
            json["binData"].deserializeJson!(ubyte[])() == binData, 3);
    }
    else
        points += printTestResult("`/user_files` ok", false, 3);

    rs = rq.get(userFilesEndpoint, ["userEmail": "edigmail.com"]);
    // Requesting the files of a nonexistent user should return OK and an empty list
    points += printTestResult("`/user_files` nonexistent user",
        rs.code == HTTPStatus.ok && rs.responseBody == `[]`, 3);

    // Test `/delete_file`
    rs = rq.post(deleteFileEndpoint,
        ["userEmail": "edi@gmail.com", "fileSHA512Digest": dataDigest]
            .serializeToJsonString(),
        "application/json");
    points += printTestResult("`/delete_file` ok", rs.code == HTTPStatus.ok, 3);

    rs = rq.get(fileInfoEndpoint, ["fileSHA512Digest": dataDigest]);
    points += printTestResult("`/file_info` deleted file",
        rs.code == HTTPStatus.notFound, 3);

    endTestSuite();
}

void main()
{
    string[] collectionNames = ["users", "files", "urls"];
    auto client = connectMongoDB("mongodb://root:example@mongo:27017");

    foreach (ref collectionName; collectionNames)
    {
        auto collection = client.getCollection(dbName ~ "." ~ collectionName);
        collection.remove();
    }

    uint points;

    testUserFunctions(points);
    testUrlFunctions(points);
    testFileFunctions(points);

    writeln(repeat("=", outputLength).array.join());
    string res = "Total";
    string pointsStr = points.to!string;
    string totalPoints = "/100 points";
    writeln(res ~
        repeat(".",
            outputLength - res.length - totalPoints.length - pointsStr.length)
            .array.join() ~
        pointsStr ~ totalPoints);
}
