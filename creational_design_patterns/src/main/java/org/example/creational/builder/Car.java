package org.example.creational.builder;

// Builder implementation for Car
public class Car {
    private String engine;
    private String transmission;
    private String interior;
    private String color;
    private boolean hasSunroof;
    private boolean hasGPS;
    private boolean hasSafetyPackage;

    private Car(Builder builder) {
        this.engine = builder.engine;
        this.transmission = builder.transmission;
        this.interior = builder.interior;
        this.color = builder.color;
        this.hasSunroof = builder.hasSunroof;
        this.hasGPS = builder.hasGPS;
        this.hasSafetyPackage = builder.hasSafetyPackage;
    }

    @Override
    public String toString() {
        return "Car{engine='" + engine + "', transmission='" + transmission + "', interior='" + interior + "', color='" + color + "', sunroof=" + hasSunroof + ", GPS=" + hasGPS + ", safetyPackage=" + hasSafetyPackage + "}";
    }

    public static class Builder {
        private String engine;
        private String transmission;
        private String interior;
        private String color;
        private boolean hasSunroof;
        private boolean hasGPS;
        private boolean hasSafetyPackage;

        public Builder setEngine(String engine) {
            this.engine = engine;
            return this;
        }

        public Builder setTransmission(String transmission) {
            this.transmission = transmission;
            return this;
        }

        public Builder setInterior(String interior) {
            this.interior = interior;
            return this;
        }

        public Builder setColor(String color) {
            this.color = color;
            return this;
        }

        public Builder setSunroof(boolean hasSunroof) {
            this.hasSunroof = hasSunroof;
            return this;
        }

        public Builder setGPS(boolean hasGPS) {
            this.hasGPS = hasGPS;
            return this;
        }

        public Builder setSafetyPackage(boolean hasSafetyPackage) {
            this.hasSafetyPackage = hasSafetyPackage;
            return this;
        }

        public Car build() {
            return new Car(this);
        }
    }
}
