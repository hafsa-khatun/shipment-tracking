import 'package:flutter/material.dart';
import '../models/shipment.dart';
import '../services/shipment_api_service.dart';

class ShipmentProvider extends ChangeNotifier {
  final ShipmentApiService _api = ShipmentApiService();

  List<Shipment> _shipments = [];
  bool _isLoading = false;
  String? _error;
  ShipmentStatus _activeStatus = ShipmentStatus.PENDING_RECEIVE_CLEARANCE;

  List<Shipment> get shipments => _shipments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ShipmentStatus get activeStatus => _activeStatus;

  void setActiveStatus(ShipmentStatus status) {
    _activeStatus = status;
    fetchShipments();
  }

  Future<void> fetchShipments() async {
    _isLoading = true;
    notifyListeners();
    try {
      _shipments = await _api.fetchByStatus(_activeStatus);
      _error = null;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createShipment({
    required String customerName,
    required String globalRefNumber,
    required String hawbNumber,
    String? notes,
  }) async {
    try {
      await _api.createShipment(
        customerName: customerName,
        globalRefNumber: globalRefNumber,
        hawbNumber: hawbNumber,
        notes: notes,
      );
      if (_activeStatus == ShipmentStatus.PENDING_RECEIVE_CLEARANCE) {
        await fetchShipments();
      }
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> advanceStatus(int id) async {
    try {
      await _api.advanceStatus(id);
      await fetchShipments();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}