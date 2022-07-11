import std.stdio;
import std.exception;

// Let's modify RailwayVehicle.
// In addition to reporting the distance that it advances, let's have it also make sounds.
// To keep the output short, let's print the sounds per 100 kilometers:
class RailwayVehicle
{
    void advance(size_t kilometers)
    {
        writefln("The vehicle is advancing %s kilometers",
                 kilometers);

        foreach (i; 0 .. kilometers / 100)
        {
            writefln("  %s", makeSound());
        }
    }

    /**
    However, makeSound() cannot be defined by RailwayVehicle because vehicles may have different sounds:

    "choo choo" for Locomotive
    "clack clack" for RailwayCar
    **/
    // Because it must be overridden, makeSound() must be declared as abstract by the superclass:
    abstract string makeSound();
}


// TODO Implement makeSound() for the subclasses and try the code with the following main():
void main()
{
    auto railwayCar1 = new PassengerCar;
    railwayCar1.advance(100);

    auto railwayCar2 = new FreightCar;
    railwayCar2.advance(200);

    auto locomotive = new Locomotive;
    locomotive.advance(300);
}

/**
  Make the program produce the following output:

    The vehicle is advancing 100 kilometers
      clack clack
    The vehicle is advancing 200 kilometers
      clack clack
      clack clack
    The vehicle is advancing 300 kilometers
      choo choo
      choo choo
      choo choo
**/

