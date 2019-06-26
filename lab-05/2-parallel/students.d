import std.stdio;
import core.thread;
import std.parallelism;
import std.algorithm.iteration;

struct Student
{
    int number;
    int[] grades;
    double average()
    {
        writefln("The work on student %s has begun", number);
        // Wait for a while to simulate a long-lasting operation
        int sum = reduce!((a, b) => a + b)(0, grades);
        Thread.sleep(1.seconds);
        writefln("The work on student %s has ended", number);
        return (sum * 1.0) / grades.length;
    }

}

void main()
{
    auto students = [ Student(1, [8, 8, 8]),
                      Student(2, [9, 9, 8]),
                      Student(3, [10, 9, 10]),
                      Student(4, [7, 9, 7]) ];

    foreach (student; parallel(students))
    {
        writefln("Student %s has avg %s\n", student.number, student.average());
    }
    writeln("main is done");
}
