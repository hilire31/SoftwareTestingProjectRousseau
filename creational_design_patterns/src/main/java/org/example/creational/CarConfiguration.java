package org.example.creational;

import org.example.creational.builder.Car;

public class CarConfiguration {

    public static void main(String[] args) {
        // Create and configure different cars using the Builder pattern
        Car car1 = new Car.Builder()
                .setEngine("V6")
                .setTransmission("Automatic")
                .setInterior("Leather")
                .setColor("Red")
                .setSunroof(true)
                .setGPS(true)
                .setSafetyPackage(true)
                .build();

        Car car2 = new Car.Builder()
                .setEngine("V8")
                .setTransmission("Manual")
                .setInterior("Standard")
                .setColor("Black")
                .setSunroof(false)
                .setGPS(false)
                .setSafetyPackage(true)
                .build();

        System.out.println(car1);
        System.out.println(car2);
    }
}
