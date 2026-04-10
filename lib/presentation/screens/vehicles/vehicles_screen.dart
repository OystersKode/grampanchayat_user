import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/services/settings_service.dart';
import '../../../data/repositories/app_repository.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Error launching dialer: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SettingsService.instance,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFF8EF),
          appBar: AppBar(
            backgroundColor: const Color(0xFF5E0006),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'taluka_vehicles'.tr(context),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: FutureBuilder<List<Map<String, dynamic>>>(
            future: AppRepository.instance.getVehicles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF5E0006)));
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final vehiclesList = snapshot.data ?? [];

              if (vehiclesList.isEmpty) {
                return Center(child: Text('no_vehicles_found'.tr(context)));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: vehiclesList.length,
                itemBuilder: (context, index) {
                  final driver = vehiclesList[index];
                  
                  // Precise field mapping based on your Firestore structure
                  final name = driver['driver_name'] ?? driver['name'] ?? driver['owner_name'] ?? 'ID: ${driver['id']}';
                  final village = driver['area'] ?? driver['village'] ?? driver['village_name'] ?? '';
                  final mobile = driver['driver_phone'] ?? driver['mobile'] ?? driver['mobile_no'] ?? driver['phone'] ?? '';
                  final vehicleNo = driver['vehicle_number'] ?? driver['vehicle_no'] ?? driver['plate_no'] ?? '';
                  final vehicleModel = driver['vehicle_model'] ?? driver['model'] ?? driver['vehicle_name'] ?? '';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5E0006).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.directions_car,
                            color: Color(0xFF5E0006),
                            size: 20,
                          ),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF370002),
                          ),
                        ),
                        subtitle: Text(
                          village,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(height: 1),
                                const SizedBox(height: 16),
                                // Phone Number Section
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Phone Number',
                                            style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            mobile.isNotEmpty ? mobile : 'Not Provided',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF5E0006),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (mobile.isNotEmpty)
                                      IconButton(
                                        onPressed: () => _makeCall(mobile),
                                        icon: const Icon(Icons.call, color: Colors.green, size: 28),
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.green.withOpacity(0.1),
                                          padding: const EdgeInsets.all(12),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Vehicle Details Row
                                Row(
                                  children: [
                                    if (vehicleModel.isNotEmpty)
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Vehicle Model',
                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              vehicleModel.toString(),
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (vehicleNo.isNotEmpty)
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Vehicle No.',
                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              vehicleNo.toString(),
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
