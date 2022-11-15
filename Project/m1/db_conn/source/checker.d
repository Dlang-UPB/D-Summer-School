import std.conv;
import std.digest;
import std.digest.sha;
import std.range;
import std.stdio;

import app : DBConnection;

enum outputLength = 80;
enum maxPoints = 100;

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

private void testUserFunctions(ref DBConnection conn, ref uint points)
{
    writeln(repeat("=", outputLength).array.join());
    writeln("Testing user functions:");

    // Test `addUser()`
    auto userRes = conn.addUser("edigmail.com", "edi", "aaa");
    points += printTestResult("`addUser()` invalid email",
        userRes == DBConnection.UserRet.ERR_INVALID_EMAIL, 5);

    userRes = conn.addUser("edi@gmail.com", "edi", "");
    points += printTestResult("`addUser()` null password",
        userRes == DBConnection.UserRet.ERR_NULL_PASS, 4);

    userRes = conn.addUser("edi@gmail.com", "edi", "aaa");
    points += printTestResult("`addUser()` ok",
        userRes == DBConnection.UserRet.OK, 4);

    userRes = conn.addUser("edi@gmail.com", "edi", "aaa");
    points += printTestResult("`addUser()` user exists",
        userRes == DBConnection.UserRet.ERR_USER_EXISTS, 5);

    // Test `authUser()`
    userRes = conn.authUser("edigmail.com", "aaa");
    points += printTestResult("`authUser()` invalid email",
        userRes == DBConnection.UserRet.ERR_INVALID_EMAIL, 5);

    userRes = conn.authUser("edi@gmail.com", "");
    points += printTestResult("`authUser()` null password",
        userRes == DBConnection.UserRet.ERR_NULL_PASS, 5);

    userRes = conn.authUser("edi@gmail.com", "abc");
    points += printTestResult("`authUser()` wrong password",
        userRes == DBConnection.UserRet.ERR_WRONG_PASS, 5);

    userRes = conn.authUser("edi@gmail.com", "aaa");
    points += printTestResult("`authUser()` ok",
        userRes == DBConnection.UserRet.OK, 5);

    // Test `deleteUser()`
    userRes = conn.deleteUser("edi@gmail.com");
    points += printTestResult("`deleteUser()` ok",
        userRes == DBConnection.UserRet.OK, 3);
}

private void testFileFunctions(ref DBConnection conn, ref uint points)
{
    writeln(repeat("=", outputLength).array.join());
    writeln("Testing file functions:");

    auto fileRes = conn.addFile("edi@gmail.com", [], "test");
    points += printTestResult("`addFile()` empty file",
        fileRes == DBConnection.FileRet.ERR_EMPTY_FILE, 4);

    fileRes = conn.addFile("edi@gmail.com", [1, 2, 3, 4, 5], "test");
    points += printTestResult("`addFile()` ok",
        fileRes == DBConnection.FileRet.OK, 5);

    fileRes = conn.addFile("edi@gmail.com", [1, 2, 3, 4, 5], "test");
    points += printTestResult("`addFile()` existing file",
        fileRes == DBConnection.FileRet.FILE_EXISTS, 4);

    // Test `getFile()`
    ubyte[] data = [1, 2, 3, 4, 5];
    auto dataDigest = digest!SHA512(data).toHexString().to!string;
    auto fileExists = conn.getFile(dataDigest);
    points += printTestResult("`getFile()` existing file", !fileExists.isNull(),
        3);

    dataDigest = digest!SHA512(data[1..$]).toHexString().to!string;
    fileExists = conn.getFile(dataDigest);
    points += printTestResult("`getFile()` missing file", fileExists.isNull(),
        3);

    // Test `getFiles()`
    auto files = conn.getFiles("edi@gmail.com");
    points += printTestResult("`getFiles()` existing files", !files.empty(), 4);

    files = conn.getFiles("non-existent@gmail.com");
    points += printTestResult("`getFiles()` missing files", files.empty(), 4);

    // Test `deleteFile()`
    dataDigest = digest!SHA512(data).toHexString().to!string;
    conn.deleteFile(dataDigest);
    fileExists = conn.getFile(dataDigest);
    points += printTestResult("`deleteFile()` existing file",
        fileExists.isNull(), 3);
}

private void testUrlFunctions(ref DBConnection conn, ref uint points)
{
    writeln(repeat("=", outputLength).array.join());
    writeln("Testing url functions:");

    // Test `addUrl()`
    auto urlRes = conn.addUrl("edi@gmail.com", "");
    points += printTestResult("`addUrl()` empty url",
        urlRes == DBConnection.UrlRet.ERR_EMPTY_URL, 4);

    urlRes = conn.addUrl("edi@gmail.com", "123.net");
    points += printTestResult("`addUrl()` ok", urlRes == DBConnection.UrlRet.OK,
        4);

    urlRes = conn.addUrl("edi@gmail.com", "123.net");
    points += printTestResult("`addUrl()` existing url",
        urlRes == DBConnection.UrlRet.URL_EXISTS, 4);

    // Test `getUrl()`
    auto urlExists = conn.getUrl("123.net");
    points += printTestResult("`getUrl()` existing url", !urlExists.isNull(),
       3);

    urlExists = conn.getUrl("123et");
    points += printTestResult("`getUrl()` missing url", urlExists.isNull(), 3);

    // Test `getUrls()`
    auto urls = conn.getUrls("edi@gmail.com");
    points += printTestResult("`getUrls()` existing urls", !urls.empty(), 4);

    urls = conn.getUrls("non-existent@gmail.com");
    points += printTestResult("`getUrls()` missing urls", urls.empty(), 4);

    // Test `deleteUrl()`
    conn.deleteUrl("123.net");
    urlExists = conn.getUrl("123.net");
    points += printTestResult("`deleteUrl()` existing url", urlExists.isNull(),
        3);
}

void main()
{
    uint points;
    DBConnection conn = DBConnection("root", "example", "mongo", "27017",
        "testing");

    testUserFunctions(conn, points);
    testFileFunctions(conn, points);
    testUrlFunctions(conn, points);

    writeln(repeat("=", outputLength).array.join());
    string res = "Result";
    string pointsStr = points.to!string;
    string totalPoints = "/100 points";
    writeln(res ~
        repeat(".",
            outputLength - res.length - totalPoints.length - pointsStr.length)
            .array.join() ~
        pointsStr ~ totalPoints);
}
