import 'package:flutter/material.dart';
import '../../widgets/announcement_card.dart';
import '../../widgets/sidebar.dart';
import '../../../routes/app_routes.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E0006),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Kagwad Panchayat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: const Text(
                'EN/KN',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppSidebar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          const Text(
            'OFFICIAL UPDATES',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF653D1E),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Latest Village\nAnnouncements',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Color(0xFF370002),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 4,
            width: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFBC0006),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          AnnouncementCard(
            category: 'INFRASTRUCTURE',
            title: 'New Water Supply Scheme Launched in Village',
            kannadaTitle: 'ಗ್ರಾಮದಲ್ಲಿ ಹೊಸ ಕುಡಿಯುವ ನೀರಿನ ಯೋಜನೆ ಚಾಲನೆ',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD3Ssp976vTaxFXk7l1ccimhnvrRrPTZw4QyaMY-AJfD08RcOj6DO4x8kdKcAuKf9-8-40ymcsHSAo5dkXniljpHrlzWRo9viVEyB75xTBRLGstNv7sXzSGxw9DStKTTT9LDCZUM0cLsiV3Q2TbeUwyUZG1vf0iSpUT606BPD7Qd9XJmLt-IN2_ZWaHhZBwh3Ajlr4Rih6_uEHV0_wFsvqgLNKsud70DtcbBA42wPLl2I3r4PZK-5YQZThPW9puDaj9LYkufn5iSsY',
            likes: '248',
            onTap: () => Navigator.pushNamed(context, AppRoutes.newsDetails),
          ),
          AnnouncementCard(
            category: 'HEALTH',
            categoryColor: const Color(0xFF370002),
            title: 'Free Health Camp on Sunday at Panchayat Office',
            kannadaTitle: 'ಭಾನುವಾರ ಪಂಚಾಯತ್ ಕಚೇರಿಯಲ್ಲಿ ಉಚಿತ ಆರೋಗ್ಯ ಶಿಬಿರ',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDdi3swwZeB2Ij1Snpe26ojXqPz19W63DkLgq-M_Nkc1hm_a1KzLtoXtUY0b9S4j5LpRuDlAeVYwfeHkY89CoNTWC5_CQ6gWyX6JcA-nUeSzxSJV83Bnu-sqNgpmRdBeFuJvpBe-EH4RYzjHpRMFY8YtDrWCJt7z8KS6as6cHQkKBm5DGkHtmWcA7QGM1ZIG9jl3KWIChpQcH2E6PE1um2aJBc5x537spjrZFlvpEl40JrIWlT_IjWZLVIDaRu8boQRDNOyPCO5A4Q',
            likes: '1.2k',
            onTap: () => Navigator.pushNamed(context, AppRoutes.newsDetails),
          ),
          AnnouncementCard(
            category: 'AGRICULTURE',
            categoryColor: const Color(0xFF442205),
            title: 'Farmer Subsidy Registration Deadline Extended',
            kannadaTitle: 'ರೈತ ಸಹಾಯಧನ ನೋಂದಣಿ ದಿನಾಂಕ ವಿಸ್ತರಣೆ',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDS7dJvSTVgSGqX1wC7_Cev6qKA5OzFa6gzI2GZI8s-pUObQ9O6RX8hbQJLi_e0nXAohm7AP8RA6iqN_qfKZreUKMg4T6Oy02DM6Z_BYafV2YH98l90ZB17vBOAYd89K18ZoVOqNu_AVfU_QV_n1gMS-Ns4EUZ3s5ZJTXqiFYjqUw6S-cJZHQrraTtsOvmiUmjSKiKbSb5qT2i4-uyPjeZYaq0siZTLQyQFyvVaN-xN79-knaATebHurfzENSI4sfGZZNy_-8yVjO4',
            likes: '892',
            onTap: () => Navigator.pushNamed(context, AppRoutes.newsDetails),
          ),
          AnnouncementCard(
            category: 'SUCCESS STORY',
            title: 'Road Repair Work Completed Successfully',
            kannadaTitle: 'ರಸ್ತೆ ದುರಸ್ತಿ ಕಾಮಗಾರಿ ಯಶಸ್ವಿಯಾಗಿ ಪೂರ್ಣಗೊಂಡಿದೆ',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAnUEJ1c-5eC7qsTj6Z7GqxZ7MWVSDGeZyGlz2zSgGDHvCKkxtkPpJy7ZXo9euOm_3VDJoqxV00Mgfa_srX5WWUfO4CelzyPZyo-VzjsOO_8qzXK3UggEOkVc37nHHXeEe-PFJhF7_cyAa_SbCU0IhPmQLWudQCDhhrNaPPqVVB7wmmdujZD6HIbAtltsMVZngcvq0dBAE53IkrRVuNgTS0tAU68qk4qONghdjBv6xoNG-y_wLQBbm0KBKg_5Vxal82PJSPofXUIAE',
            likes: '2.1k',
            onTap: () => Navigator.pushNamed(context, AppRoutes.newsDetails),
          ),
        ],
      ),
    );
  }
}
