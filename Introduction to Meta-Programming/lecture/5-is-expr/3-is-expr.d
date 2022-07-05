module is_expr_3;
import std.stdio;

interface Clock
{
    void tellTime();
}

class AlarmClock : Clock
{
    override void tellTime()
    {
        writeln("10:00");
    }
}

void myFunction(T)(T parameter)
{
    static if (is (T : Clock))
    {
        // If we are here then T can be used as a Clock
        writeln("This is a Clock; we can tell the time");
        parameter.tellTime();
        // We can also define an alias to T
        // We can also check for a specific type, not an implicitly convertible one
    }
    else
    {
        writeln("This is not a Clock");
    }
}

void main()
{
    auto var = new AlarmClock;
    myFunction(var);
    myFunction(42);
}
