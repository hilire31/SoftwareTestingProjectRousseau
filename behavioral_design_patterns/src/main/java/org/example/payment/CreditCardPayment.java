
package org.example.payment;

public class CreditCardPayment implements PaymentStrategy {
    @Override
    public void pay(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Amount must be positive");
        }
        // Simulate payment processing
        System.out.println("Processing credit card payment for $" + amount + "...");
        System.out.println("Paid $" + amount + " with Credit Card.");
    }
}
