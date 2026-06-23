package com.example.shipment_tracking.controllers;

import com.example.shipment_tracking.daos.ShipmentDTO;
import com.example.shipment_tracking.models.ShipmentStatus;
import com.example.shipment_tracking.services.ShipmentService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/shipments")
@CrossOrigin(origins = "*")
public class ShipmentController {

    private final ShipmentService service;

    public ShipmentController(ShipmentService service) {
        this.service = service;
    }

    // POST /api/shipments
    @PostMapping
    public ResponseEntity<ShipmentDTO.Response> create(
            @Valid @RequestBody ShipmentDTO.CreateRequest req) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(req));
    }

    // GET /api/shipments
    // GET /api/shipments?status=PENDING_RECEIVE_CLEARANCE
    @GetMapping
    public ResponseEntity<List<ShipmentDTO.Response>> getAll(
            @RequestParam(required = false) ShipmentStatus status) {
        return ResponseEntity.ok(status != null ? service.getByStatus(status) : service.getAll());
    }

    // GET /api/shipments/{id}
    @GetMapping("/{id}")
    public ResponseEntity<ShipmentDTO.Response> getById(@PathVariable Long id) {
        return ResponseEntity.ok(service.getById(id));
    }

    // PUT /api/shipments/{id}
    @PutMapping("/{id}")
    public ResponseEntity<ShipmentDTO.Response> update(
            @PathVariable Long id,
            @Valid @RequestBody ShipmentDTO.UpdateRequest req) {
        return ResponseEntity.ok(service.update(id, req));
    }

    // DELETE /api/shipments/{id}
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    // PATCH /api/shipments/{id}/advance
    @PatchMapping("/{id}/advance")
    public ResponseEntity<ShipmentDTO.Response> advance(@PathVariable Long id) {
        return ResponseEntity.ok(service.advanceStatus(id));
    }
}