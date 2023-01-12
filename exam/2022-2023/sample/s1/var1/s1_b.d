struct Expr
{
    string op;
    Expr[] args;
}

int notOk;

Expr[] bar(Expr[] exprs)
{
    Expr[] result;
    foreach (expr; exprs)
    {
        if (expr.op in ["+": 0, "-": 0, "*": 0, "/": 0] && expr.args.length == 2)
        {
            result ~= expr;
        }
        else
        {
            notOk++;

            foreach (arg; expr.args)
            {
                result ~= bar([arg]);
            }
        }
    }
    return result;
}

unittest
{
    auto exprs = [Expr("+", [Expr("1"), Expr("2")]),
                  Expr("-", [Expr("3"), Expr("+", [Expr("4"), Expr("5")])]),
                  Expr("*", [Expr("5"), Expr("6")]),
                  Expr("/", [Expr("7"), Expr("8")])];

    // TODO: call `bar()` with the right argument.
    auto result = bar([]);

    // DO NOT modify these lines.
    assert(result == exprs);
    assert(notOk == 2);
}
