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

    @PostMapping
    public ResponseEntity<ShipmentDTO.Response> create(
            @Valid @RequestBody ShipmentDTO.CreateRequest req) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(req));
    }

    @GetMapping
    public ResponseEntity<List<ShipmentDTO.Response>> getAll(
            @RequestParam(required = false) ShipmentStatus status) {
        return ResponseEntity.ok(status != null ? service.getByStatus(status) : service.getAll());
    }

    @PatchMapping("/{id}/advance")
    public ResponseEntity<ShipmentDTO.Response> advance(@PathVariable Long id) {
        return ResponseEntity.ok(service.advanceStatus(id));
    }
}
