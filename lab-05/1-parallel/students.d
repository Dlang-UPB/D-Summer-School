import std.stdio;
import core.thread;
import std.parallelism;

struct Student
{
    int number;
    void aSlowOperation()
    {
        writefln("The work on student %s has begun", number);
        // Wait for a while to simulate a long-lasting operation
        Thread.sleep(1.seconds);
        writefln("The work on student %s has ended", number);
    }
}

void main()
{
    auto students = [ Student(1), Student(2), Student(3), Student(4) ];

    foreach (student; students)
    {
        auto theTask = task(&student.aSlowOperation);
        theTask.executeInNewThread();
    }
    writeln("main is done");
}
