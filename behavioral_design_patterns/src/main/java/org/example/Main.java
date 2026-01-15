package org.example;

import org.example.command.PlaceOrderCommand;
import org.example.handler.InventoryCheckHandler;
import org.example.handler.PaymentValidationHandler;
import org.example.notification.NotificationService;
import org.example.payment.CreditCardPayment;
import org.example.payment.PaymentStrategy;

public class Main {
    public static void main(String[] args) {
        System.out.println("=== Behavioral Patterns Demo ===");

        // Création d'une commande
        Order order = new Order(1L, "Alice", "NEW", 100.0);

        // Chain of Responsibility: enchaîner des validateurs (Inventory -> Payment)
        InventoryCheckHandler inventory = new InventoryCheckHandler(); // Pattern: Chain of Responsibility
        PaymentValidationHandler paymentValidation = new PaymentValidationHandler(); // Pattern: Chain of Responsibility
        inventory.setNext(paymentValidation);
        inventory.validate(order); // lance la chaîne de validation

        // Command: encapsuler l'action de passer la commande
        PlaceOrderCommand placeCmd = new PlaceOrderCommand(order); // Pattern: Command
        placeCmd.execute(); // exécute la commande

        // Strategy: choisir une stratégie de paiement à l'exécution
        PaymentStrategy paymentStrategy = new CreditCardPayment(); // Pattern: Strategy
        paymentStrategy.pay(order.getTotalAmount()); // paye avec la stratégie choisie

        // Observer: notifier plusieurs observateurs après traitement
        NotificationService notificationService = new NotificationService(); // Pattern: Observer
        notificationService.addObserver(message -> System.out.println("Observer1 received: " + message));
        notificationService.addObserver(message -> System.out.println("Observer2 received: " + message));
        notificationService.notifyObservers("Order " + order.getId() + " processed");

        System.out.println("=== Demo finished ===");
    }
}