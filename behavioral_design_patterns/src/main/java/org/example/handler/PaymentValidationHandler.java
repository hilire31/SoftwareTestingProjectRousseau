
package org.example.handler;

import org.example.Order;

public class PaymentValidationHandler extends OrderValidationHandler {
    @Override
    public void validate(Order order) {
        // Basic payment validation: amount must be positive
        if (order.getTotalAmount() <= 0) {
            throw new IllegalStateException("Invalid payment amount: " + order.getTotalAmount());
        }
        System.out.println("Payment validation passed.");
        super.validate(order);
    }
}
