

struct List3 {
    int a, b, c;
}

extern(C) int sumMembers(List3 list);

// TODO 5: Copy sumMembers implementation here
// Fails because of the syntax
// int sumMembers(struct List3 list) {
//     return list.a + list.b + list.c;
// }

int sumMembersRedesigned(List3 list) {
    int[] arr = [list.a, list.b, list.c];
    arr ~= 5;
    arr ~= 6;

    import std.algorithm: sum;
    return arr.sum;
}

int main() {
    import std.stdio;
    writeln(sumMembersRedesigned(List3(1, 2, 3)));
    return 0;
}
