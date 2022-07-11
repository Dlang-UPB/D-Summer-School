module logger;

enum LogLevel
{
    Debug = "debug",
    Info = "info",
    Warning = "warn",
    Error = "error"
}

string log(string str, LogLevel level, string file)
{
    return str;
}

unittest
{
    // TODO: Add unittests for basic types: stirngs, ints, bools, floats
	assert("[info] logger.d: Oceiros" == "Oceiros".log());
}
