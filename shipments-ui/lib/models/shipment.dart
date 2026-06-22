enum ShipmentStatus {
  PENDING_RECEIVE_CLEARANCE,
  DELIVERY_IN_PROGRESS,
  DELIVERED,
  COMPLETED,
}

extension ShipmentStatusExt on ShipmentStatus {
  String get label {
    switch (this) {
      case ShipmentStatus.PENDING_RECEIVE_CLEARANCE: return 'Pending Receive Clearance';
      case ShipmentStatus.DELIVERY_IN_PROGRESS:      return 'Delivery In Progress';
      case ShipmentStatus.DELIVERED:                 return 'Delivered';
      case ShipmentStatus.COMPLETED:                 return 'Completed';
    }
  }

  String get actionLabel {
    switch (this) {
      case ShipmentStatus.PENDING_RECEIVE_CLEARANCE: return 'Start Delivery';
      case ShipmentStatus.DELIVERY_IN_PROGRESS:      return 'Mark as Delivered';
      case ShipmentStatus.DELIVERED:                 return 'Mark as Completed';
      case ShipmentStatus.COMPLETED:                 return '';
    }
  }

  String get emoji {
    switch (this) {
      case ShipmentStatus.PENDING_RECEIVE_CLEARANCE: return '🟡';
      case ShipmentStatus.DELIVERY_IN_PROGRESS:      return '🚚';
      case ShipmentStatus.DELIVERED:                 return '📦';
      case ShipmentStatus.COMPLETED:                 return '💰';
    }
  }

  static ShipmentStatus fromString(String s) =>
      ShipmentStatus.values.firstWhere((e) => e.name == s);
}

class Shipment {
  final int id;
  final String customerName;
  final String globalRefNumber;
  final String invoiceNumber;
  final String hawbNumber;
  final String? notes;
  final ShipmentStatus status;
  final DateTime createdAt;

  Shipment({
    required this.id,
    required this.customerName,
    required this.globalRefNumber,
    required this.invoiceNumber,
    required this.hawbNumber,
    this.notes,
    required this.status,
    required this.createdAt,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) => Shipment(
    id: json['id'],
    customerName: json['customerName'],
    globalRefNumber: json['globalRefNumber'],
    invoiceNumber: json['invoiceNumber'],
    hawbNumber: json['hawbNumber'],
    notes: json['notes'],
    status: ShipmentStatusExt.fromString(json['status']),
    createdAt: DateTime.parse(json['createdAt']),
  );
}