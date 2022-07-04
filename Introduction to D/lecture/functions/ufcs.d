void main()
{
    import std.algorithm : group;
    import std.range : chain, dropOne, front, retro;

    //retro(chain([1, 2], [3, 4]));
    //front(dropOne(group([1, 1, 2, 2, 2])));

    [1, 2].chain([3, 4]).retro; // 4, 3, 2, 1
    [1, 1, 2, 2, 2].group.dropOne.front; // (2, 3)

}
