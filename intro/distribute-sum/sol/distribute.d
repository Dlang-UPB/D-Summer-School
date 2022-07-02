/* Distributes the sum between two variables.
 *
 * Distributes to the first variable first, but never gives
 * more than 7 to it. The rest of the sum is distributed to
 * the second variable. */
void distribute(int sum, out int first, out int second)
in {
    assert(sum >= 0, "sum cannot be negative");

} out {
    assert(sum == (first + second), "first + second != sum");

} do {
    first = (sum >= 7) ? 7 : sum;
    second = sum - first;
}

unittest {
    import std.exception : assertThrown;
    int first;
    int second;

    // Both must be 0 if the sum is 0
    distribute(0, first, second);
    assert(first == 0);
    assert(second == 0);

    // If the sum is less than 7, then all of it must be given
    // to first
    distribute(3, first, second);
    assert(first == 3);
    assert(second == 0);

    // Testing a boundary condition
    distribute(7, first, second);
    assert(first == 7);
    assert(second == 0);

    // If the sum is more than 7, then the first must get 7
    // and the rest must be given to second
    distribute(8, first, second);
    assert(first == 7);
    assert(second == 1);

    // A random large value
    distribute(1_000_007, first, second);
    assert(first == 7);
    assert(second == 1_000_000);
}
