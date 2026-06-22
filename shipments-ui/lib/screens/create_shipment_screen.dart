import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shipment_provider.dart';

class CreateShipmentScreen extends StatefulWidget {
  const CreateShipmentScreen({super.key});

  @override
  State<CreateShipmentScreen> createState() => _CreateShipmentScreenState();
}

class _CreateShipmentScreenState extends State<CreateShipmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _refCtrl = TextEditingController();
  final _hawbCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _refCtrl.dispose();
    _hawbCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final ok = await context.read<ShipmentProvider>().createShipment(
      customerName: _nameCtrl.text.trim(),
      globalRefNumber: _refCtrl.text.trim(),
      hawbNumber: _hawbCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );

    setState(() => _loading = false);

    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(' Shipment created!'),
        backgroundColor: Color(0xFF059669),
      ));
      Navigator.pop(context);
    } else if (mounted) {
      final err = context.read<ShipmentProvider>().error ?? 'Failed';
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err), backgroundColor: Colors.red.shade700));
      context.read<ShipmentProvider>().clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('New Shipment',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field('Customer Name *', _nameCtrl, 'e.g. Ahmed Corporation',
                      (v) => v!.trim().isEmpty ? 'Required' : null),
              _field('Global Reference Number *', _refCtrl, 'e.g. GR-2024-010',
                      (v) => v!.trim().isEmpty ? 'Required' : null),
              _disabled('Invoice Number', 'Auto Generated'),
              _field('HAWB Number *', _hawbCtrl, 'e.g. HAWB-0012',
                      (v) => v!.trim().isEmpty ? 'Required' : null),
              _field('Notes (optional)', _notesCtrl, 'Additional notes...', null, maxLines: 3),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _loading
                      ? const SizedBox(height: 20, width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Create Shipment',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, String hint,
      String? Function(String?)? validator, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctrl,
            maxLines: maxLines,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _disabled(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              border: Border.all(color: const Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(value, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
          ),
        ],
      ),
    );
  }
}