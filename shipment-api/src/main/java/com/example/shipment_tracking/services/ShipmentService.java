package com.example.shipment_tracking.services;

import com.example.shipment_tracking.daos.ShipmentDTO;
import com.example.shipment_tracking.models.Shipment;
import com.example.shipment_tracking.models.ShipmentStatus;
import com.example.shipment_tracking.repositories.ShipmentRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ShipmentService {

    private final ShipmentRepository repository;
    private final InvoiceSequenceService invoiceSequenceService;

    public ShipmentService(ShipmentRepository repository,
                           InvoiceSequenceService invoiceSequenceService) {
        this.repository = repository;
        this.invoiceSequenceService = invoiceSequenceService;
    }

    
    @Transactional
    public ShipmentDTO.Response create(ShipmentDTO.CreateRequest req) {
        if (repository.existsByGlobalRefNumber(req.getGlobalRefNumber()))
            throw new IllegalArgumentException("Global reference number already exists.");
        if (repository.existsByHawbNumber(req.getHawbNumber()))
            throw new IllegalArgumentException("HAWB number already exists.");

        Shipment shipment = new Shipment(
                req.getCustomerName(),
                req.getGlobalRefNumber(),
                invoiceSequenceService.nextInvoiceNumber(),
                req.getHawbNumber(),
                req.getNotes(),
                ShipmentStatus.PENDING_RECEIVE_CLEARANCE
        );
        return toResponse(repository.save(shipment));
    }

    
    public List<ShipmentDTO.Response> getAll() {
        return repository.findAllByOrderByIdAsc()
                .stream().map(this::toResponse).collect(Collectors.toList());
    }

    
    public List<ShipmentDTO.Response> getByStatus(ShipmentStatus status) {
        return repository.findByStatusOrderByIdAsc(status)
                .stream().map(this::toResponse).collect(Collectors.toList());
    }

    
    public ShipmentDTO.Response getById(Long id) {
        Shipment shipment = repository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Shipment not found."));
        return toResponse(shipment);
    }

    
    @Transactional
    public ShipmentDTO.Response update(Long id, ShipmentDTO.UpdateRequest req) {
        Shipment shipment = repository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Shipment not found."));

        if (shipment.getStatus() == ShipmentStatus.COMPLETED)
            throw new IllegalStateException("Completed shipment cannot be edited.");

        if (repository.existsByGlobalRefNumberAndIdNot(req.getGlobalRefNumber(), id))
            throw new IllegalArgumentException("Global reference number already exists.");
        if (repository.existsByHawbNumberAndIdNot(req.getHawbNumber(), id))
            throw new IllegalArgumentException("HAWB number already exists.");

        shipment.setCustomerName(req.getCustomerName());
        shipment.setGlobalRefNumber(req.getGlobalRefNumber());
        shipment.setHawbNumber(req.getHawbNumber());
        shipment.setNotes(req.getNotes());

        return toResponse(repository.save(shipment));
    }

    
    @Transactional
    public void delete(Long id) {
        Shipment shipment = repository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Shipment not found."));

        if (shipment.getStatus() == ShipmentStatus.COMPLETED)
            throw new IllegalStateException("Completed shipment cannot be deleted.");

        repository.delete(shipment);
    }

    
    @Transactional
    public ShipmentDTO.Response advanceStatus(Long id) {
        Shipment shipment = repository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Shipment not found."));

        ShipmentStatus next = switch (shipment.getStatus()) {
            case PENDING_RECEIVE_CLEARANCE -> ShipmentStatus.DELIVERY_IN_PROGRESS;
            case DELIVERY_IN_PROGRESS -> ShipmentStatus.DELIVERED;
            case DELIVERED -> ShipmentStatus.COMPLETED;
            case COMPLETED -> null;
        };

        if (next == null)
            throw new IllegalStateException("Shipment is already completed.");

        shipment.setStatus(next);
        return toResponse(repository.save(shipment));
    }

    
    private ShipmentDTO.Response toResponse(Shipment s) {
        ShipmentDTO.Response r = new ShipmentDTO.Response();
        r.setId(s.getId());
        r.setCustomerName(s.getCustomerName());
        r.setGlobalRefNumber(s.getGlobalRefNumber());
        r.setInvoiceNumber(s.getInvoiceNumber());
        r.setHawbNumber(s.getHawbNumber());
        r.setNotes(s.getNotes());
        r.setStatus(s.getStatus());
        r.setCreatedAt(s.getCreatedAt());
        return r;
    }
}
