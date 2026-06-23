package com.example.shipment_tracking.services;

import com.example.shipment_tracking.repositories.ShipmentRepository;
import org.springframework.stereotype.Service;

import java.util.concurrent.atomic.AtomicLong;

@Service
public class InvoiceSequenceService {

    private final AtomicLong counter;

    public InvoiceSequenceService(ShipmentRepository repository) {

        String lastInvoice = repository.findTopByOrderByIdDesc()
                .map(s -> s.getInvoiceNumber())
                .orElse("INV-000000");

        long lastNumber = Long.parseLong(lastInvoice.replace("INV-", ""));
        this.counter = new AtomicLong(lastNumber + 1);
    }

    public String nextInvoiceNumber() {
        return String.format("INV-%06d", counter.getAndIncrement());
    }
}