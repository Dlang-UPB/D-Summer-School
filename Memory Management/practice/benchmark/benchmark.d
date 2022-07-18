const int num_iterations = 2_000_000; // this will be the number of function calls
const int num_items = 100; // this will be the number of elements to append to the array

void array_declare() {
}

void array_new() {
}

void array_reserve() {
}

void main()
{
    import std.stdio : writeln, write;
    import std.datetime.stopwatch : benchmark;

    auto res = benchmark!(array_declare, array_new, array_reserve)(num_iterations);
    write("array_declare took "); writeln(res[0]);
    write("array_new took "); writeln(res[1]);
    write("array_reserve took "); writeln(res[2]);
}
