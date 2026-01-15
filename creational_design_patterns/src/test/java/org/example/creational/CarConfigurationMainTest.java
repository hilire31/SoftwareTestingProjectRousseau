package org.example.creational;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;

public class CarConfigurationMainTest {

    @Test
    public void mainRunsWithoutException() {
        assertDoesNotThrow(() -> CarConfiguration.main(new String[0]));
    }
}
