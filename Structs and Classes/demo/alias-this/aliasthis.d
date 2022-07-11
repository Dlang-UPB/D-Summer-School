// rdmd -unittest -main aliasthis.d
import std.stdio;

struct Fraction
{
    long numerator;
    long denominator;

    // TODO alias this
}

double calculate(double lhs, double rhs) {
    return 2 * lhs + rhs;
}

void main() {
    auto fraction = Fraction(1, 4);    // meaning 1/4
    assert(calculate(fraction, 0.75) == 1.25);
}
