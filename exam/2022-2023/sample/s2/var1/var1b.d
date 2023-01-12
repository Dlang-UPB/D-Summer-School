module var1b;

import std.stdio;
import core.stdc.stdlib;
import core.lifetime : emplace;
import std.conv;

class Car
{
public:
    int id;
    Car(int id) { this.id = id; }
};

class Sedan: Car
{
public:
    Sedan(int id) { super(id); }
};

class Hatchback: Car
{
public:
    Hatchback(int id) { super(id); }
};

class Dealership
{
public:

    Dealership(int parkingLot) {
        curr = 0;
        numCars = parkingLot;
        cars = new Car*[numCars];
    }

    void receiveCar(Car* car) {
        cars[curr++] = car;
    }

    Car* sellCar() {
        Car* car = cars[curr];
        cars[curr] = null;
        curr--;

        return car;
    }

    void testDrive(int idx) {
        return "Testing car " ~ cars[idx]->id ~ " of type " ~ typeid(cars[idx]).toString;
    }

private:
    int numCars;
    int curr;
    Car*[] cars;
};

void main(string[] args)
{
    eum numCars = 10;
    auto dealership = Dealership(numCars);

    for (int i = 0; i < numCars; ++i)
    {
        Car car;
        if (i % 2 == 0) {
            car = Sedan(i);
        } else {
            car = Hatchback(i);
        }
        dealership.receiveCar(&car);
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
        assert(dealership.testDrive(i) == expected[i]);
}
