import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/services/settings_service.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  final List<Map<String, String>> vehicles = const [
    {'name': 'Sumit parit', 'mobile': '9916939388', 'village': 'Kagwad'},
    {'name': 'Anil Kallole', 'mobile': '9620068200', 'village': 'Kagawd'},
    {'name': 'Salim mahat', 'mobile': '9886271072', 'village': 'Kagwad'},
    {'name': 'Shankar Nayak', 'mobile': '9449151431', 'village': 'Kagwad'},
    {'name': 'Dhanaraj Karav', 'mobile': '9019962686', 'village': 'Kagwad'},
    {'name': 'Mahesh Patil', 'mobile': '9986878184', 'village': 'Kagwad'},
    {'name': 'Imran Makandar', 'mobile': '9742552264', 'village': 'Kagwad'},
    {'name': 'Sunil magadum', 'mobile': '7411808567', 'village': 'Kagwad'},
    {'name': 'Ravi mali', 'mobile': '9686302577', 'village': 'Kagwad'},
    {'name': 'Raju Hulyal', 'mobile': '8971222927', 'village': 'Shedbal'},
    {'name': 'Shivaprasad ganiga', 'mobile': '7996654944', 'village': 'Kagwad'},
    {'name': 'Pintu bhajantri', 'mobile': '9380468354', 'village': 'Kagwad'},
    {'name': 'Prashant khot', 'mobile': '9844917177', 'village': 'Kagwad'},
    {'name': 'Mahavir khsirasagar', 'mobile': '9986415872', 'village': 'Kagwad'},
    {'name': 'Suresh pujari', 'mobile': '8722508290', 'village': 'Kagwad'},
    {'name': 'Swayam Patil', 'mobile': '6363788985', 'village': 'Kagwad'},
    {'name': 'Ramesh Hulyal', 'mobile': '7349398672', 'village': 'Shedbal'},
    {'name': 'Kiran shintre', 'mobile': '8123480143', 'village': 'Ugar khurd'},
    {'name': 'Krishna Kamble', 'mobile': '9035204522', 'village': 'Ugar khurd'},
    {'name': 'Pravin Kamble', 'mobile': '7026492432', 'village': 'kagwad'},
    {'name': 'Kalappa sutar', 'mobile': '8861298911', 'village': 'Mole'},
    {'name': 'Uttam mali', 'mobile': '9620011470', 'village': 'Kagwad'},
    {'name': 'Adinath kerur', 'mobile': '8088646969', 'village': 'UGAR khurd'},
    {'name': 'Shashikant Ghatage', 'mobile': '7090014949', 'village': 'Jugul'},
    {'name': 'AKASH Ghorade', 'mobile': '7676769090', 'village': 'Kagwad'},
  ];

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
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'taluka_vehicles'.tr(context),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF370002),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'taluka_vehicles_desc'.tr(context),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF653D1E),
                  ),
                ),
                const SizedBox(height: 24),
                ...vehicles.map((driver) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
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
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5E0006).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.directions_car,
                            color: Color(0xFF5E0006),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driver['name'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF370002),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    driver['mobile'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF5E0006),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    driver['village'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _makeCall(driver['mobile'] ?? ''),
                          icon: const Icon(Icons.call, color: Colors.green),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.green.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
