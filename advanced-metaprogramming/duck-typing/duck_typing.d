module duck_typing;

int skillExperience;

class GuardianApe
{
    void defeat() { skillExperience += 4000; }
}

class GreatShinobiOwl
{
    void defeat() { skillExperience += 6000; }
}

class IsshinTheSwordSaint
{
    void defaet() { skillExperience += 20_000; }
}

void fight(Boss)(Boss boss)
{
    boss.defeat();
}

unittest
{
    static assert(__traits(compiles, { fight(new GuardianApe()); }));
    fight(new GuardianApe());
    assert(skillExperience == 4000);

    static assert(__traits(compiles, { fight(new GreatShinobiOwl()); }));
    fight(new GreatShinobiOwl());
    assert(skillExperience == 10_000);

    // TODO: Make this `assert` pass.
    static assert(__traits(compiles, { fight(new IsshinTheSwordSaint()); }));
    fight(new IsshinTheSwordSaint());
    assert(skillExperience == 20_000);
}

void main() { }
