package com.example.shipment_tracking.repositories;

import com.example.shipment_tracking.models.Shipment;
import com.example.shipment_tracking.models.ShipmentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public interface ShipmentRepository extends JpaRepository<Shipment, Long> {
    List<Shipment> findByStatusOrderByCreatedAtDesc(ShipmentStatus status);
    boolean existsByGlobalRefNumber(String globalRefNumber);
    boolean existsByHawbNumber(String hawbNumber);
}
