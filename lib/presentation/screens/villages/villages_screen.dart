import 'package:flutter/material.dart';
import '../../widgets/translated_text.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/services/settings_service.dart';

class VillagesScreen extends StatelessWidget {
  const VillagesScreen({super.key});

  final List<Map<String, String>> villages = const [
    {'name': 'Ainapur', 'pincode': '591303'},
    {'name': 'Banajawad', 'pincode': '591303'},
    {'name': 'Basava Nagar Devaraddi Tot', 'pincode': '591303'},
    {'name': 'Jugul', 'pincode': '591242'},
    {'name': 'Kagwad', 'pincode': '591223'},
    {'name': 'Katral', 'pincode': '591303'},
    {'name': 'Kempwad', 'pincode': '591234'},
    {'name': 'Kidagedi', 'pincode': '591234'},
    {'name': 'Koulgudd', 'pincode': '591232'},
    {'name': 'Krishna Kittur', 'pincode': '591303'},
    {'name': 'Kusanal', 'pincode': '591316'},
    {'name': 'Lokur', 'pincode': '591234'},
    {'name': 'Mangavati', 'pincode': '591242'},
    {'name': 'Mangsuli', 'pincode': '591234'},
    {'name': 'Mole', 'pincode': '591303'},
    {'name': 'Molwad', 'pincode': '591316'},
    {'name': 'Navalihal', 'pincode': '591234'},
    {'name': 'Parameshwarwadi', 'pincode': '591316'},
    {'name': 'Shahapur', 'pincode': '591242'},
    {'name': 'Shedbal', 'pincode': '591315'},
    {'name': 'Shirguppi', 'pincode': '591242'},
    {'name': 'Siddarth Nagar', 'pincode': '591316'},
    {'name': 'Ugar Budruk', 'pincode': '591316'},
    {'name': 'Ugar KH', 'pincode': '591316'},
  ];

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
              'villages'.tr(context),
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
                  'kagwad_taluka_villages'.tr(context),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF370002),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(const Color(0xFF5E0006)),
                      columns: [
                        DataColumn(
                          label: Text(
                            'village_name'.tr(context),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'pincode'.tr(context),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: villages.map((village) {
                        return DataRow(
                          cells: [
                            DataCell(TranslatedText(village['name'] ?? '')),
                            DataCell(Text(village['pincode'] ?? '')),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
