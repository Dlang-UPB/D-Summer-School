module var1b;

import std.stdio;
import core.stdc.stdlib;
import core.lifetime : emplace;
import std.conv;

class Car
{
public:
    int id;
    //Car() {}
    this(int id) { this.id = id; }
    //virtual ~Car() {}
};

class Sedan: Car
{
public:
    //Sedan(int id) { super(id); }
    this(int id) { super(id); }
};

class Hatchback: Car
{
public:
    //Hatchback(int id) { super(id); }
    this(int id) { super(id); }
};

class Dealership
{
public:

    //Dealership(int parkingLot) {
    this(int parkingLot) {
        curr = 0;
        numCars = parkingLot;
        cars = new Car[numCars];
    }

    void receiveCar(Car car) {
        cars[curr++] = car;
    }

    Car sellCar() {
        Car car = cars[curr];
        cars[curr] = null;
        curr--;

        return car;
    }

    string testDrive(int idx) {
        //std::cout << "Testing car" << cars[idx]->id << "\n";
        //writeln("Testing car" ~ cars[idx]->id);
        return "Testing car " ~ cars[idx].id.to!string ~ " of type " ~ typeid(cars[idx]).toString;
    }

private:
    int numCars;
    int curr;
    Car[] cars;
};

void main(string[] args)
{
    enum numCars = 10;
    auto dealership = new Dealership(numCars);

    for (int i = 0; i < numCars; ++i)
    {
        Car car;
        if (i % 2 == 0) {
            car = new Sedan(i);
        } else {
            car = new Hatchback(i);
        }
        dealership.receiveCar(car);
    }

    enum expected = [
        "Testing car 0 of type var1b.Sedan",
        "Testing car 1 of type var1b.Hatchback",
        "Testing car 2 of type var1b.Sedan",
        "Testing car 3 of type var1b.Hatchback",
        "Testing car 4 of type var1b.Sedan",
        "Testing car 5 of type var1b.Hatchback",
        "Testing car 6 of type var1b.Sedan",
        "Testing car 7 of type var1b.Hatchback",
        "Testing car 8 of type var1b.Sedan",
        "Testing car 9 of type var1b.Hatchback"
    ];

    for (int i = 0; i < numCars; ++i)
        assert(dealership.testDrive(i) == expected[i], dealership.testDrive(i));
}
