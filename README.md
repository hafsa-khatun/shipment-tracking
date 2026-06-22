# 🚚 Real-Time Shipment Tracking System

A comprehensive Full-Stack Shipment Tracking and Management System featuring an administrative dashboard with precise workflow transitions, data integrity enforcement, and a gorgeous, responsive mobile user interface.

---

## 🛠️ Tech Stack & Architecture

This repository follows a clean, decoupled architecture containing both the backend service and the client-side mobile application.

### 💻 Backend Layer (`shipment-api`)
* **Framework:** Spring Boot (Java)
* **Database:** PostgreSQL (with transaction management)
* **Architecture:** DAO / DTO Pattern with clean separation of concerns
* **Error Handling:** Global interceptor using `@RestControllerAdvice` for uniform REST API error responses

### 📱 Client Layer (`shipments-ui`)
* **Framework:** Flutter (Dart)
* **State Management:** Provider Architecture with strict data encapsulation
* **UI/UX:** Modern, highly scannable layouts with corporate slate & vibrant accent color palettes

---

## 🧭 Workflow & Business Logic

The shipment entities navigate through a strict multi-state progression guard:
1. `🟡 Pending Receive Clearance` ➔ Trigger: **Start Delivery**
2. `🚚 Delivery In Progress` ➔ Trigger: **Mark as Delivered**
3. `📦 Delivered` ➔ Trigger: **Mark as Completed**
4. `💰 Completed` ➔ *Final state (Actions restricted)*

### 🔒 Key Engineering Controls Implemented:
* **Unique Constraints:** Duplicate `globalRefNumber` and `hawbNumber` requests are blocked at the database and application levels before execution.
* **Auto-Generation:** Custom sequences safely auto-generate sequential invoice numbers upon creation.
* **State Guard:** Completed shipments cannot be modified, preventing stale data updates.
