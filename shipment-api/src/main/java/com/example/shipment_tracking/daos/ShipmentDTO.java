package com.example.shipment_tracking.daos;

import com.example.shipment_tracking.models.ShipmentStatus;
import jakarta.validation.constraints.NotBlank;
import java.time.LocalDateTime;

public class ShipmentDTO {

    public static class CreateRequest {

        @NotBlank(message = "Customer name is required")
        private String customerName;

        @NotBlank(message = "Global reference number is required")
        private String globalRefNumber;

        @NotBlank(message = "HAWB number is required")
        private String hawbNumber;

        private String notes;

        public String getCustomerName() { return customerName; }
        public void setCustomerName(String v) { this.customerName = v; }
        public String getGlobalRefNumber() { return globalRefNumber; }
        public void setGlobalRefNumber(String v) { this.globalRefNumber = v; }
        public String getHawbNumber() { return hawbNumber; }
        public void setHawbNumber(String v) { this.hawbNumber = v; }
        public String getNotes() { return notes; }
        public void setNotes(String v) { this.notes = v; }
    }


    public static class UpdateRequest {

        @NotBlank(message = "Customer name is required")
        private String customerName;

        @NotBlank(message = "Global reference number is required")
        private String globalRefNumber;

        @NotBlank(message = "HAWB number is required")
        private String hawbNumber;

        private String notes;

        public String getCustomerName() { return customerName; }
        public void setCustomerName(String v) { this.customerName = v; }
        public String getGlobalRefNumber() { return globalRefNumber; }
        public void setGlobalRefNumber(String v) { this.globalRefNumber = v; }
        public String getHawbNumber() { return hawbNumber; }
        public void setHawbNumber(String v) { this.hawbNumber = v; }
        public String getNotes() { return notes; }
        public void setNotes(String v) { this.notes = v; }
    }

    public static class Response {
        private Long id;
        private String customerName;
        private String globalRefNumber;
        private String invoiceNumber;
        private String hawbNumber;
        private String notes;
        private ShipmentStatus status;
        private LocalDateTime createdAt;

        public Long getId() { return id; }
        public void setId(Long v) { this.id = v; }
        public String getCustomerName() { return customerName; }
        public void setCustomerName(String v) { this.customerName = v; }
        public String getGlobalRefNumber() { return globalRefNumber; }
        public void setGlobalRefNumber(String v) { this.globalRefNumber = v; }
        public String getInvoiceNumber() { return invoiceNumber; }
        public void setInvoiceNumber(String v) { this.invoiceNumber = v; }
        public String getHawbNumber() { return hawbNumber; }
        public void setHawbNumber(String v) { this.hawbNumber = v; }
        public String getNotes() { return notes; }
        public void setNotes(String v) { this.notes = v; }
        public ShipmentStatus getStatus() { return status; }
        public void setStatus(ShipmentStatus v) { this.status = v; }
        public LocalDateTime getCreatedAt() { return createdAt; }
        public void setCreatedAt(LocalDateTime v) { this.createdAt = v; }
    }
}