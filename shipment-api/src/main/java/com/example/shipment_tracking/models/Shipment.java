package com.example.shipment_tracking.models;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "shipments")
public class Shipment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String customerName;

    @Column(nullable = false, unique = true)
    private String globalRefNumber;

    @Column(nullable = false, unique = true, updatable = false)
    private String invoiceNumber;

    @Column(nullable = false)
    private String hawbNumber;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ShipmentStatus status;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    public Shipment() {}

    public Shipment(String customerName, String globalRefNumber, String invoiceNumber,
                    String hawbNumber, String notes, ShipmentStatus status) {
        this.customerName = customerName;
        this.globalRefNumber = globalRefNumber;
        this.invoiceNumber = invoiceNumber;
        this.hawbNumber = hawbNumber;
        this.notes = notes;
        this.status = status;
    }

    public Long getId() { return id; }
    public String getCustomerName() { return customerName; }
    public String getGlobalRefNumber() { return globalRefNumber; }
    public String getInvoiceNumber() { return invoiceNumber; }
    public String getHawbNumber() { return hawbNumber; }
    public String getNotes() { return notes; }
    public ShipmentStatus getStatus() { return status; }
    public LocalDateTime getCreatedAt() { return createdAt; }

    public void setId(Long id) { this.id = id; }
    public void setCustomerName(String v) { this.customerName = v; }
    public void setGlobalRefNumber(String v) { this.globalRefNumber = v; }
    public void setInvoiceNumber(String v) { this.invoiceNumber = v; }
    public void setHawbNumber(String v) { this.hawbNumber = v; }
    public void setNotes(String v) { this.notes = v; }
    public void setStatus(ShipmentStatus v) { this.status = v; }
    public void setCreatedAt(LocalDateTime v) { this.createdAt = v; }
}


