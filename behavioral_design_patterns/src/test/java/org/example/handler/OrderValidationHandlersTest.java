package org.example.handler;

import org.example.Order;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class OrderValidationHandlersTest {

    @Test
    public void validateChain_passesForValidOrder() {
        InventoryCheckHandler inv = new InventoryCheckHandler();
        PaymentValidationHandler pay = new PaymentValidationHandler();
        inv.setNext(pay);

        Order order = new Order(1L, "Alice", "NEW", 100.0);
        assertDoesNotThrow(() -> inv.validate(order));
    }

    @Test
    public void validateChain_failsForInvalidPayment() {
        InventoryCheckHandler inv = new InventoryCheckHandler();
        PaymentValidationHandler pay = new PaymentValidationHandler();
        inv.setNext(pay);

        Order order = new Order(2L, "Bob", "NEW", 0.0);
        assertThrows(IllegalStateException.class, () -> inv.validate(order));
    }
}