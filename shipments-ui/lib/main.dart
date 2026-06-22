import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/shipment_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ShipTrackApp());
}

class ShipTrackApp extends StatelessWidget {
  const ShipTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShipmentProvider(),
      child: MaterialApp(
        title: 'ShipTrack Pro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}