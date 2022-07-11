import std;

// rdmd -unittest -main cpy.d

struct Student
{
    int number;
    int[] grades;

    this(ref const(Student) that)
    {
        // do stuff
    }
}


unittest
{
    auto student1 = Student(1, [ 70, 90, 85 ]);
    auto student2 = student1;

    student2.number = 2;
    student1.grades[0] += 5;

    assert(student2.grades[0] == 70);
}
