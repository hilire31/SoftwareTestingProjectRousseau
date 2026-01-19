package org.example.payment;

public class PayPalPayment implements PaymentStrategy {
    @Override
    public void pay(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Amount must be positive");
        }
        // Simulate PayPal payment processing
        System.out.println("Processing PayPal payment for $" + amount + "...");
        System.out.println("Paid $" + amount + " with PayPal.");
    }
}
