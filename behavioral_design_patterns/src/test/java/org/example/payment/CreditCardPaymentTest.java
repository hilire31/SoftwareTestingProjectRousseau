package org.example.payment;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class CreditCardPaymentTest {

    @Test
    public void payPositiveAmount() {
        CreditCardPayment p = new CreditCardPayment();
        assertDoesNotThrow(() -> p.pay(10.0));
    }

    @Test
    public void payNegativeThrows() {
        CreditCardPayment p = new CreditCardPayment();
        assertThrows(IllegalArgumentException.class, () -> p.pay(0.0));
    }
}