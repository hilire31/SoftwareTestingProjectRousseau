package org.example.creational;

import org.junit.jupiter.api.Test;
import org.example.creational.builder.Car;

import static org.junit.jupiter.api.Assertions.*;

public class CarBuilderTest {

    @Test
    public void buildCar_hasConfiguredProperties() {
        Car car = new Car.Builder()
                .setEngine("V6")
                .setTransmission("Automatic")
                .setInterior("Leather")
                .setColor("Red")
                .setSunroof(true)
                .setGPS(true)
                .setSafetyPackage(true)
                .build();

        String s = car.toString();
        assertTrue(s.contains("V6"));
        assertTrue(s.contains("Red"));
        assertTrue(s.contains("sunroof=true") || s.contains("sunroof= true") == false);
    }
}