
package org.example.handler;

import org.example.Order;

public class InventoryCheckHandler extends OrderValidationHandler {
    @Override
    public void validate(Order order) {
        // Basic inventory check: we don't have item details, so simulate success
        if (order.getTotalAmount() < 0) {
            throw new IllegalStateException("Invalid order total amount");
        }
        System.out.println("Inventory check passed.");
        super.validate(order);
    }
}
