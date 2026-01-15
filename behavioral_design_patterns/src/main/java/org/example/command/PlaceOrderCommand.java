
package org.example.command;

import org.example.Order;

public class PlaceOrderCommand implements OrderCommand {
    private final Order order;

    public PlaceOrderCommand(Order order) {
        this.order = order;
    }

    @Override
    public void execute() {
        // Update order status and perform placement logic
        order.updateStatus("PLACED");
        System.out.println("Order placed successfully: " + order.getId());
    }
}
