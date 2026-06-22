import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shipment.dart';
import '../providers/shipment_provider.dart';
import '../widgets/shipment_card.dart';
import 'create_shipment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _tabs = ShipmentStatus.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<ShipmentProvider>().setActiveStatus(_tabs[_tabController.index]);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShipmentProvider>().fetchShipments();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Row(
          children: [
            Text('🛳️', style: TextStyle(fontSize: 22)),
            SizedBox(width: 10),
            Text('ShipTrack Pro',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: const Color(0xFF2563EB),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          tabs: _tabs
              .map((s) => Tab(text: '${s.emoji} ${s.label}'))
              .toList(),
        ),
        actions: [
          IconButton(
            onPressed: () => context.read<ShipmentProvider>().fetchShipments(),
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateShipmentScreen()),
        ),
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Shipment',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: Consumer<ShipmentProvider>(
        builder: (context, provider, _) {
          if (provider.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(provider.error!),
                backgroundColor: Colors.red.shade700,
              ));
              provider.clearError();
            });
          }
          return TabBarView(
            controller: _tabController,
            children: _tabs.map((status) => _TabBody(status: status)).toList(),
          );
        },
      ),
    );
  }
}

class _TabBody extends StatelessWidget {
  final ShipmentStatus status;
  const _TabBody({required this.status});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShipmentProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
        }
        final list = provider.activeStatus == status ? provider.shipments : <Shipment>[];
        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('📭', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 12),
                Text('No shipments here',
                    style: TextStyle(fontSize: 16, color: Colors.grey[500], fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  status == ShipmentStatus.PENDING_RECEIVE_CLEARANCE
                      ? 'Tap + to create a new shipment'
                      : 'Shipments will appear when they reach this stage',
                  style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: provider.fetchShipments,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (_, i) => ShipmentCard(shipment: list[i]),
          ),
        );
      },
    );
  }
}