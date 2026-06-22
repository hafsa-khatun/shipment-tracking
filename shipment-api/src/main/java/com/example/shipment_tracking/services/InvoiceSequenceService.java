package com.example.shipment_tracking.services;

import org.springframework.stereotype.Service;

import java.util.concurrent.atomic.AtomicLong;
@Service
public class InvoiceSequenceService {
    private final AtomicLong counter = new AtomicLong(1);

    public String nextInvoiceNumber() {
        return String.format("INV-%06d", counter.getAndIncrement());
    }
}
