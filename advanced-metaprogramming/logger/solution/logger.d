module logger;

import std.conv : to;
import std.traits : isNumeric, isArray;
import std.stdio : writeln;

enum LogLevel
{
    Debug = "debug",
    Info = "info",
    Warning = "warn",
    Error = "error"
}

private string makeHeader(LogLevel level, string file)
{
    return '[' ~ level ~ "] " ~ file ~ ": ";
}

string log(Data : string)(Data str, LogLevel level, string file = __FILE__)
{
    return makeHeader(level, file) ~ str;
}

string log(Data : bool)(Data boolean, LogLevel level, string file = __FILE__)
{
    return makeHeader(level, file) ~ (boolean ? "T" : "F");
}

string log(Data)(Data value, LogLevel level, string file = __FILE__)
if (isNumeric!Data)
{
    return makeHeader(level, file) ~ to!string(value);
}

string log(Data)(Data arr, LogLevel level, string file = __FILE__)
if (isArray!Data)
{
    import std.array : Appender;

    Appender!(char[]) output;
    size_t len = arr.length;

    output.put(makeHeader(level, file));
    output.put('[');
    foreach (i, ref value; arr)
    {
        output.put(value.to!string);
        if (i != len - 1)
            output.put(", ");
    }
    output.put(']');

    return output.data.idup();
}

string log(Data)(Data obj, LogLevel level, string file = __FILE__)
if (is(Data == struct) || is(Data == class))
{
    import std.array : Appender;
    import std.traits : isFunction;

    Appender!(char[]) output;

    output.put(makeHeader(level, file));

    static if (__traits(hasMember, Data, "toString") &&
        isFunction!(obj.toString))
    {
        output.put(obj.toString());
    }
    else
    {

        output.put(__traits(identifier, Data));
        output.put('(');
        static foreach (member; __traits(allMembers, Data))
            if (!isFunction!(mixin("obj." ~ member)))
            {
                auto memberValue = mixin("obj." ~ member);
                output.put(memberValue.to!string);
                output.put(", ");
            }
        output.put(')');
    }

    return output.data.idup();
}

void main()
{

}

unittest
{
    assert("[info] logger.d: Oceiros" == "Oceiros".log(LogLevel.Info));
    assert("[debug] logger.d: 69" == 69.log(LogLevel.Debug));
    assert("[warn] logger.d: T" == true.log(LogLevel.Warning));
    assert("[error] logger.d: F" == false.log(LogLevel.Error));
}

unittest
{
    assert("[info] logger.d: [1337, 1000100]" == [1337, 1_000_100].log(LogLevel.Info));
}

unittest
{
    struct Stats
    {
        long souls;
        bool optional;

        string toString() const
        {
            return "is " ~ (optional ? "" : "not ") ~ "optional, yields " ~
                souls.to!string ~ " souls";
        }
    }

    struct Boss
    {
        string name;
        int number;
        Stats stats;

        string toString() const
        {
            string position;
            
            switch(number)
            {
                case 1:
                    position = "1st";
                    break;
                case 2:
                    position = "2nd";
                    break;
                case 3:
                    position = "3rd";
                    break;
                default:
                    position = number.to!string ~ "th";
                    break;
            }

            return name ~ " is the " ~ position ~ " boss in Dark Souls III, " ~
                stats.to!string;
        }
    }

    Boss firstBoss = Boss("Iudex Gundyr", 1, Stats(3000, false));
    assert("[warn] logger.d: Iudex Gundyr is the 1st boss in Dark Souls III, is not optional, yields 3000 souls" ==
        firstBoss.log(LogLevel.Warning));
}
