import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/translated_text.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/services/settings_service.dart';
import '../../../data/repositories/app_repository.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'search_vehicles_hint'.tr(context),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF5E0006)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF5E0006), width: 1),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: AppRepository.instance.getVehicles(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF5E0006)));
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final vehiclesList = snapshot.data ?? [];

                    // Define the desired sequence of driver names
                    final List<String> sequence = [
                      "Sumit parit",
                      "Anil Kallole",
                      "Salim mahat",
                      "Shankar Nayak",
                      "Dhanaraj Karav",
                      "Mahesh Patil",
                      "Imran Makandar",
                      "Sunil magadum",
                      "Ravi mali",
                      "Raju Hulyal",
                      "Shivaprasad ganiga",
                      "Pintu bhajantri",
                      "Prashant khot",
                      "Mahavir khsirasagar",
                      "Suresh pujari",
                      "Swayam Patil",
                      "Ramesh Hulyal",
                      "Kiran shintre",
                      "Krishna Kamble",
                      "Pravin Kamble",
                      "Kalappa sutar",
                      "Uttam mali",
                      "Adinath kerur",
                      "Shashikant Ghatage",
                      "AKASH Ghorade",
                    ];

                    // Sort the list based on the predefined sequence
                    vehiclesList.sort((a, b) {
                      final nameA = (a['driver_name'] ?? a['name'] ?? a['owner_name'] ?? '').toString().toLowerCase().trim();
                      final nameB = (b['driver_name'] ?? b['name'] ?? b['owner_name'] ?? '').toString().toLowerCase().trim();

                      final indexA = sequence.indexWhere((s) => s.toLowerCase().trim() == nameA);
                      final indexB = sequence.indexWhere((s) => s.toLowerCase().trim() == nameB);

                      // If both names are in the sequence, sort by their position in the sequence
                      if (indexA != -1 && indexB != -1) {
                        return indexA.compareTo(indexB);
                      }
                      // If only nameA is in the sequence, it comes before nameB
                      if (indexA != -1) return -1;
                      // If only nameB is in the sequence, it comes before nameA
                      if (indexB != -1) return 1;

                      // If neither is in the sequence (newly added by admin), sort by creation time (newest at bottom)
                      // Assuming 'created_at' exists, otherwise they stay in their relative order at the end
                      final timeA = a['created_at'] as Timestamp?;
                      final timeB = b['created_at'] as Timestamp?;

                      if (timeA != null && timeB != null) {
                        return timeA.compareTo(timeB); // Ascending: older first, newer at the bottom
                      }

                      return 0;
                    });

                    final filteredList = vehiclesList.where((driver) {
                      final name = (driver['driver_name'] ?? driver['name'] ?? driver['owner_name'] ?? '').toString().toLowerCase();
                      final village = (driver['area'] ?? driver['village'] ?? driver['village_name'] ?? '').toString().toLowerCase();
                      final mobile = (driver['driver_phone'] ?? driver['mobile'] ?? driver['mobile_no'] ?? driver['phone'] ?? '').toString().toLowerCase();
                      final vehicleNo = (driver['vehicle_number'] ?? driver['vehicle_no'] ?? driver['plate_no'] ?? '').toString().toLowerCase();
                      final vehicleModel = (driver['vehicle_model'] ?? driver['model'] ?? driver['vehicle_name'] ?? '').toString().toLowerCase();

                      return name.contains(_searchQuery) ||
                             village.contains(_searchQuery) ||
                             mobile.contains(_searchQuery) ||
                             vehicleNo.contains(_searchQuery) ||
                             vehicleModel.contains(_searchQuery);
                    }).toList();

                    if (filteredList.isEmpty) {
                      return Center(child: Text('no_vehicles_found'.tr(context)));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final driver = filteredList[index];
                        
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
                              title: TranslatedText(
                                name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF370002),
                                ),
                              ),
                              subtitle: TranslatedText(
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
                                                Text(
                                                  'phone_number_label'.tr(context),
                                                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  mobile.isNotEmpty ? mobile : 'not_provided'.tr(context),
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
                                                  Text(
                                                    'vehicle_model_label'.tr(context),
                                                    style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  TranslatedText(
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
                                                  Text(
                                                    'vehicle_no_label'.tr(context),
                                                    style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
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
              ),
            ],
          ),
        );
      },
    );
  }
}
