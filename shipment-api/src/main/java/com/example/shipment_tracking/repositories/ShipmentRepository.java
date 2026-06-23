package com.example.shipment_tracking.repositories;

import com.example.shipment_tracking.models.Shipment;
import com.example.shipment_tracking.models.ShipmentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ShipmentRepository extends JpaRepository<Shipment, Long> {

    List<Shipment> findByStatusOrderByIdAsc(ShipmentStatus status);
    List<Shipment> findAllByOrderByIdAsc();


    Optional<Shipment> findTopByOrderByIdDesc();

    boolean existsByGlobalRefNumber(String globalRefNumber);
    boolean existsByGlobalRefNumberAndIdNot(String globalRefNumber, Long id);
    boolean existsByHawbNumber(String hawbNumber);
    boolean existsByHawbNumberAndIdNot(String hawbNumber, Long id);
}