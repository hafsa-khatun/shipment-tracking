import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/shipment.dart';

class ShipmentApiService {

  static const String _base = 'http://10.0.2.2:8080/api/shipments';

  Future<List<Shipment>> fetchByStatus(ShipmentStatus status) async {
    final res = await http.get(Uri.parse('$_base?status=${status.name}'));
    _check(res);
    return (jsonDecode(res.body) as List).map((e) => Shipment.fromJson(e)).toList();
  }

  Future<Shipment> createShipment({
    required String customerName,
    required String globalRefNumber,
    required String hawbNumber,
    String? notes,
  }) async {
    final res = await http.post(
      Uri.parse(_base),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'customerName': customerName,
        'globalRefNumber': globalRefNumber,
        'hawbNumber': hawbNumber,
        'notes': notes,
      }),
    );
    _check(res);
    return Shipment.fromJson(jsonDecode(res.body));
  }

  Future<Shipment> advanceStatus(int id) async {
    final res = await http.patch(Uri.parse('$_base/$id/advance'));
    _check(res);
    return Shipment.fromJson(jsonDecode(res.body));
  }

  void _check(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      final body = jsonDecode(res.body);
      throw Exception(body['error'] ?? 'Something went wrong');
    }
  }
}