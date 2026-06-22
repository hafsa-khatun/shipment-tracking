import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shipment.dart';
import '../providers/shipment_provider.dart';

class ShipmentCard extends StatelessWidget {
  final Shipment shipment;
  const ShipmentCard({super.key, required this.shipment});

  Color get _statusColor {
    switch (shipment.status) {
      case ShipmentStatus.PENDING_RECEIVE_CLEARANCE: return const Color(0xFFF59E0B);
      case ShipmentStatus.DELIVERY_IN_PROGRESS:      return const Color(0xFF3B82F6);
      case ShipmentStatus.DELIVERED:                 return const Color(0xFF10B981);
      case ShipmentStatus.COMPLETED:                 return const Color(0xFF7C3AED);
    }
  }

  Color get _actionColor {
    switch (shipment.status) {
      case ShipmentStatus.PENDING_RECEIVE_CLEARANCE: return const Color(0xFF2563EB);
      case ShipmentStatus.DELIVERY_IN_PROGRESS:      return const Color(0xFF059669);
      case ShipmentStatus.DELIVERED:                 return const Color(0xFF7C3AED);
      case ShipmentStatus.COMPLETED:                 return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = shipment.createdAt;
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final dateStr = '${d.day.toString().padLeft(2,'0')} ${months[d.month-1]} ${d.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(top: BorderSide(color: _statusColor, width: 3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shipment.customerName,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF1E293B))),
                      Text(dateStr, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _statusColor.withOpacity(0.4)),
                  ),
                  child: Text(
                    '${shipment.status.emoji} ${shipment.status.label}',
                    style: TextStyle(color: _statusColor, fontWeight: FontWeight.w700, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _Info(label: 'Invoice', value: shipment.invoiceNumber, mono: true)),
                Expanded(child: _Info(label: 'HAWB', value: shipment.hawbNumber, mono: true)),
              ],
            ),
            const SizedBox(height: 8),
            _Info(label: 'Global Ref', value: shipment.globalRefNumber, mono: true),
            if (shipment.notes != null && shipment.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _Info(label: 'Notes', value: shipment.notes!),
            ],
            const SizedBox(height: 16),
            if (shipment.status != ShipmentStatus.COMPLETED)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _confirm(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _actionColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('${shipment.status.actionLabel} →',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ),
              )
            else
              Center(
                child: Text(' Shipment completed',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }

  void _confirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Confirm Action', style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('${shipment.status.actionLabel} for ${shipment.invoiceNumber}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _actionColor, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(context);
              final ok = await context.read<ShipmentProvider>().advanceStatus(shipment.id);
              if (ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(' ${shipment.status.actionLabel} done!'),
                  backgroundColor: Colors.green.shade700,
                ));
              }
            },
            child: Text(shipment.status.actionLabel),
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String label, value;
  final bool mono;
  const _Info({required this.label, required this.value, this.mono = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600,
                color: Color(0xFF94A3B8), letterSpacing: 0.5)),
        Text(value,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                color: const Color(0xFF334155), fontFamily: mono ? 'monospace' : null)),
      ],
    );
  }
}