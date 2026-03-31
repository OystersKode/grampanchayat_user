import 'package:flutter/material.dart';

void main() {
  runApp(const GramPanchayatApp());
}

class GramPanchayatApp extends StatelessWidget {
  const GramPanchayatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shivapura Gram Panchayat',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5E0006),
          primary: const Color(0xFF5E0006),
          secondary: const Color(0xFFBC0006),
          surface: const Color(0xFFFFF8F3),
          onSurface: const Color(0xFF241A06),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8F3),
        fontFamily: 'sans-serif',
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E0006),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Shivapura Panchayat',
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
      drawer: Drawer(
        backgroundColor: const Color(0xFFFFF8F3),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF5E0006),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFFFF2E1),
                        child: Icon(Icons.person, size: 40, color: Color(0xFF5E0006)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Panchayat Portal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.person_outline,
                    title: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.newspaper,
                    title: 'News',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NewsDetailsPage()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.card_giftcard,
                    title: 'Wishes',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WishesPage()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'v1.0.0',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
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
          const AnnouncementCard(
            category: 'INFRASTRUCTURE',
            title: 'New Water Supply Scheme Launched in Village',
            kannadaTitle: 'ಗ್ರಾಮದಲ್ಲಿ ಹೊಸ ಕುಡಿಯುವ ನೀರಿನ ಯೋಜನೆ ಚಾಲನೆ',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD3Ssp976vTaxFXk7l1ccimhnvrRrPTZw4QyaMY-AJfD08RcOj6DO4x8kdKcAuKf9-8-40ymcsHSAo5dkXniljpHrlzWRo9viVEyB75xTBRLGstNv7sXzSGxw9DStKTTT9LDCZUM0cLsiV3Q2TbeUwyUZG1vf0iSpUT606BPD7Qd9XJmLt-IN2_ZWaHhZBwh3Ajlr4Rih6_uEHV0_wFsvqgLNKsud70DtcbBA42wPLl2I3r4PZK-5YQZThPW9puDaj9LYkufn5iSsY',
            likes: '248',
          ),
          const AnnouncementCard(
            category: 'HEALTH',
            categoryColor: Color(0xFF370002),
            title: 'Free Health Camp on Sunday at Panchayat Office',
            kannadaTitle: 'ಭಾನುವಾರ ಪಂಚಾಯತ್ ಕಚೇರಿಯಲ್ಲಿ ಉಚಿತ ಆರೋಗ್ಯ ಶಿಬಿರ',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDdi3swwZeB2Ij1Snpe26ojXqPz19W63DkLgq-M_Nkc1hm_a1KzLtoXtUY0b9S4j5LpRuDlAeVYwfeHkY89CoNTWC5_CQ6gWyX6JcA-nUeSzxSJV83Bnu-sqNgpmRdBeFuJvpBe-EH4RYzjHpRMFY8YtDrWCJt7z8KS6as6cHQkKBm5DGkHtmWcA7QGM1ZIG9jl3KWIChpQcH2E6PE1um2aJBc5x537spjrZFlvpEl40JrIWlT_IjWZLVIDaRu8boQRDNOyPCO5A4Q',
            likes: '1.2k',
          ),
          const AnnouncementCard(
            category: 'AGRICULTURE',
            categoryColor: Color(0xFF442205),
            title: 'Farmer Subsidy Registration Deadline Extended',
            kannadaTitle: 'ರೈತ ಸಹಾಯಧನ ನೋಂದಣಿ ದಿನಾಂಕ ವಿಸ್ತರಣೆ',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDS7dJvSTVgSGqX1wC7_Cev6qKA5OzFa6gzI2GZI8s-pUObQ9O6RX8hbQJLi_e0nXAohm7AP8RA6iqN_qfKZreUKMg4T6Oy02DM6Z_BYafV2YH98l90ZB17vBOAYd89K18ZoVOqNu_AVfU_QV_n1gMS-Ns4EUZ3s5ZJTXqiFYjqUw6S-cJZHQrraTtsOvmiUmjSKiKbSb5qT2i4-uyPjeZYaq0siZTLQyQFyvVaN-xN79-knaATebHurfzENSI4sfGZZNy_-8yVjO4',
            likes: '892',
          ),
          const AnnouncementCard(
            category: 'SUCCESS STORY',
            title: 'Road Repair Work Completed Successfully',
            kannadaTitle: 'ರಸ್ತೆ ದುರಸ್ತಿ ಕಾಮಗಾರಿ ಯಶಸ್ವಿಯಾಗಿ ಪೂರ್ಣಗೊಂಡಿದೆ',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAnUEJ1c-5eC7qsTj6Z7GqxZ7MWVSDGeZyGlz2zSgGDHvCKkxtkPpJy7ZXo9euOm_3VDJoqxV00Mgfa_srX5WWUfO4CelzyPZyo-VzjsOO_8qzXK3UggEOkVc37nHHXeEe-PFJhF7_cyAa_SbCU0IhPmQLWudQCDhhrNaPPqVVB7wmmdujZD6HIbAtltsMVZngcvq0dBAE53IkrRVuNgTS0tAU68qk4qONghdjBv6xoNG-y_wLQBbm0KBKg_5Vxal82PJSPofXUIAE',
            likes: '2.1k',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF5E0006)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF241A06),
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEED9B9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E0006),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'News Details',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Stack(
              children: [
                Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAJP-rVjGqMvHKMUx2dlpZ7Fpa05pA289TPPwCsUTk4G3lAk9Vj9JcI_ukiUbviyGgo0eYi2L0aNr1LqrBjlXgsObZhhT4zsmjhbiqqDWsujijDYi1jcgj1LN57Uf7p6BqgbbEaHaKZBWGAJmjrZMYLNcmZFOd-I_-QAruKc9ej0cFvFd8W3u2jtSJKKHax_lQBv6hUT46JmKdcYMlA9FPQlBH252691W0ytM4CKnAx9ERuYwr9j5HTIVSRb9WoU4nPBZveQTRRztk',
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildImageErrorPlaceholder(350),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1281F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'NEW SCHEME',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Farmer Subsidy Registration 2024',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'ರೈತ ಸಹಾಯಧನ ನೋಂದಣಿ 2024',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Content Area
            Container(
              transform: Matrix4.translationValues(0, -20, 0),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF8F3),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Posted Info & Buttons
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5E0BF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.calendar_today, color: Color(0xFF370002), size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'POSTED ON',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Color(0xFF653D1E),
                              ),
                            ),
                            Text(
                              'October 24, 2023',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF241A06),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFBE5C5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.favorite, color: Color(0xFFBC0006), size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Share on WhatsApp'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBC0006),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Scheme Overview
                    Row(
                      children: [
                        Container(width: 4, height: 24, color: const Color(0xFFBC0006)),
                        const SizedBox(width: 12),
                        const Text(
                          'Scheme Overview',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF370002),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'The Shivapura Gram Panchayat is pleased to announce the commencement of the 2024 Farmer Subsidy Program. This initiative is designed to support our local agricultural community by providing financial assistance for high-quality seeds, modern irrigation equipment, and organic fertilizers.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF57413F),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'ಶಿವಪುರ ಗ್ರಾಮ ಪಂಚಾಯಿತಿಯು 2024 ರ ರೈತ ಸಹಾಯಧನ ಕಾರ್ಯಕ್ರಮದ ಪ್ರಾರಂಭವನ್ನು ಘೋಷಿಸಲು ಸಂತೋಷಪಡುತ್ತದೆ. ಈ ಉಪಕ್ರಮವು ಉತ್ತಮ ಗುಣಮಟ್ಟದ ಬಿತ್ತನೆ ಬೀಜಗಳು, ಆಧುನಿಕ ನೀರಾವರಿ ಉಪಕರಣಗಳು ಮತ್ತು ಸಾವಯವ ಗೊಬ್ಬರಗಳಿಗೆ ಹಣಕಾಸಿನ ನೆರವು ನೀಡುವ ಮೂಲಕ ನಮ್ಮ ಸ್ಥಳೀಯ ಕೃಷಿ ಸಮೂದಾಯವನ್ನು ಬೆಂಬಲಿಸಲು ವಿನ್ಯಾಸಗೊಳಿಸಲಾಗಿದೆ.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF57413F),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Related Images
                    const Text(
                      'RELATED IMAGES',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Color(0xFF8B716E),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildRelatedImage('https://lh3.googleusercontent.com/aida-public/AG82647Y_m9MhX9R-8_u7G6-V8D_m_H-B-R-R-U-8-R-R-R-U'),
                          _buildRelatedImage('https://lh3.googleusercontent.com/aida-public/AG8264_F-k6MhX9R-8_u7G6-V8D_m_H-B-R-R-U-8-R-R-R-U'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Eligibility & Deadlines
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF2E1),
                        borderRadius: BorderRadius.circular(20),
                        border: const Border(left: BorderSide(color: Color(0xFFBC0006), width: 4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Eligibility Criteria',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF370002)),
                          ),
                          const SizedBox(height: 12),
                          _buildBulletPoint('Resident of Shivapura Panchayat'),
                          _buildBulletPoint('Possession of valid RTC/Pahani documents'),
                          _buildBulletPoint('Small or marginal land holding status'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDCC5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Key Deadlines',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF301400)),
                          ),
                          const SizedBox(height: 16),
                          _buildDeadlineItem('Registration Starts', 'Nov 01, 2023'),
                          const SizedBox(height: 10),
                          _buildDeadlineItem('Final Deadline', 'Dec 15, 2023', isFinal: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // How to Register
                    const Text(
                      'How to Register',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF370002)),
                    ),
                    const SizedBox(height: 20),
                    _buildStep(1, 'Document Collection', 'Gather your Aadhaar card, Bank Passbook, and land ownership records (RTC).'),
                    _buildStep(2, 'Visit Panchayat Office', 'Submit the physical application at the Seva Sindhu counter in the Gram Panchayat office.'),
                    _buildStep(3, 'Verification', 'Wait for the field inspection by the Village Administrative Officer (VAO).'),
                    const SizedBox(height: 32),

                    // Important Notice
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF370002),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.warning, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Important Notice',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Please ensure all details are correct. Incomplete applications or false information will lead to immediate disqualification and potential legal action under panchayat bylaws.',
                            style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8), height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Helpline Footer
                    const Center(
                      child: Text(
                        'FOR ANY ASSISTANCE CALL OUR HELPLINE',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF653D1E), letterSpacing: 1.2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBE5C5),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.call, color: Color(0xFF370002)),
                            SizedBox(width: 12),
                            Text(
                              '1800-425-1555',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF370002)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedImage(String url) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImageErrorPlaceholder(200),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFFBC0006), size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF57413F)))),
        ],
      ),
    );
  }

  Widget _buildDeadlineItem(String label, String date, {bool isFinal = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isFinal ? const Color(0xFFBC0006) : const Color(0xFF301400))),
          Text(date, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: isFinal ? const Color(0xFFBC0006) : const Color(0xFF301400))),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF370002),
            child: Text(number.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF241A06))),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 14, color: Color(0xFF653D1E), height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E0006),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Citizen Profile',
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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Identity Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2E1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAilXtv1yGO3Gm3vZOGmkWmaHfs8YeczM2ZxhV_CJicr3-6IQPnEZm-6UY4hV6PT3lkIzi1tPCm6poMrQP-hhVcYXj_TPRgUmEmURiEptrDnrIicPBnGMHuQs1G0ALo3hC98XsCFfuwy_I4MTpktXBV7DZifGrwxIZOJJV509dup-_6c2ujHSdWo4P5Cc9k9oxUvOdvZfPRGJlmyoPGyIkbVmV834MB4sQAQYJBBIBblmSTh-nMLOI2rNWRarAZcR5DbebUaGOZtiE',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildImageErrorPlaceholder(120),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'MEMBER SINCE 2018',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Color(0xFF653D1E),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manjunath Rao',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF370002),
                    fontFamily: 'headline',
                  ),
                ),
                const Text(
                  'Citizen / Farmer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFBC0006),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC40C0C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Details Grid
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.location_on,
                  label: 'Village',
                  value: 'Shivapura',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.language,
                  label: 'Language Preference',
                  value: 'Kannada / English',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          const Text(
            'Settings & Preferences',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF241A06),
            ),
          ),
          const SizedBox(height: 16),
          
          // Settings Section
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2E1),
              borderRadius: BorderRadius.circular(24),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.notifications,
                  title: 'Notification Settings',
                  subtitle: 'Manage alerts for news and events',
                ),
                _buildSettingsItem(
                  icon: Icons.text_fields,
                  title: 'Accessibility Options',
                  subtitle: 'Adjust font size and contrast',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5E0BF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Medium', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
                _buildSettingsItem(
                  icon: Icons.security,
                  title: 'Privacy & Security',
                  subtitle: 'Data usage and account security',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Help Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF370002),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Need assistance?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Contact the Shivapura Panchayat helpdesk for profile-related queries.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Get Support'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBC0006),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5E0BF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF370002), size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF653D1E), fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF241A06)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({required IconData icon, required String title, required String subtitle, Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFBC0006)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF653D1E))),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) trailing,
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Color(0xFF8B716E)),
        ],
      ),
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }
}

class WishesPage extends StatelessWidget {
  const WishesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E0006),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Village Wishes',
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          const Text(
            'COMMUNITY SPIRIT',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF653D1E),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Village Wishes',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Color(0xFF241A06),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Celebrating the milestones, festivals, and achievements that bind Shivapura together.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF653D1E),
            ),
          ),
          const SizedBox(height: 32),
          
          // Birthday Wish Card
          const WishCard(
            type: WishType.birthday,
            title: 'Happy Birthday to Ramesh Gowda 🎉',
            description: 'Wishing our esteemed elder and community leader a very happy 75th birthday. Your wisdom continues to guide us.',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCNsnlSxvtXI4n7hSbLl-kM3a5Lxo5VncN95w6ub9xJlJ9Lnv8TIopx584Ojms5OOBSM5_hI9kvtEE5Cz-MIr1WkV2tkNAiWhXvNTYK3IC2--BCEQQ8wRv9aym765n1__oFaNwY2yGExjVDYdCFVorMF0gE75DDYG7w6g0mRB0Nim6RtK49w8-agoJBKQvX9jt37TXNYGrC1q9WbXxMxwojHfsWCgrmMvK53_yZK85Ct2qYuUfrgXJZnmBCaAAP_5L7bvPLxfdWOfs',
          ),

          // Festival Wish Card
          const WishCard(
            type: WishType.festival,
            title: 'Ugadi Festival Wishes to All Villagers 🌸',
            description: 'May this New Year bring prosperity, health, and abundant harvests to every household in Shivapura.',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuATPRDTKltq3NSKCtVaz3jo55Z-ktd5R17yM_pbnS8xCGjMxqwoSQAle0c7sKT0SslbtlZYeun4a34np0nNfcvvIDRJRmYZofTZNnRd3WihC59MAWSlw2Sz9J9h_jT0xVe0hahYpPGJEAb5HaFT6k2_W6OKY1av6zXPyZO0HPlEOA0EpN0XPDJaMO2iif4HYmXgSMIGMCigrl7msLBpvLtvyFkfwGRhhfEXY_5SENJHORKIFitXFR_5tPOY_AfZLGQVbdQOxtEb4IE',
            likes: '128',
          ),

          // Achievement Card
          const AchievementCard(
            title: 'Local Achievement: 10th Standard Toppers Honored',
            description: 'The Panchayat proudly recognizes the hard work of our students. Success is the fruit of dedication.',
          ),

          // New Arrival Card
          const WishCard(
            type: WishType.newArrival,
            title: 'Welcome to the World!',
            description: 'Congratulating Shweta and Murali on the arrival of their baby boy.',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAyLIX_pyK-7bgCKs4CjisO7h9GEmFX7zAVKvgZKa6hiKd1StvS6IDeZqd7gv8TVuK800dsmvu8a679_O6oKoFWOx7E6EEXOvYTJrRR1xKp57Fu7QBUQnIz_2b7asCga0y1fp_CGw4Ds797l6yfOt0okPl85fBx979rbT6Vg4LTobVihZQPwHxBFy3MyzggCeVEClA3Luiz8JSssV3QSibd0j7oUD2ONjndccO2mjge0Nuf_Zt36dXIeQRmL3V7DPi80pZeDr9MksE',
          ),

          // General Announcement Card
          const GeneralAnnouncementCard(
            title: 'General Announcements & Communal Harmony',
            description: 'The Panchayat wishes to thank everyone who participated in the Shramadaan (voluntary labor) last weekend. Our village roads look beautiful because of you!',
          ),
        ],
      ),
    );
  }
}

enum WishType { birthday, festival, newArrival }

class WishCard extends StatelessWidget {
  final WishType type;
  final String title;
  final String description;
  final String imageUrl;
  final String? likes;

  const WishCard({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildImageErrorPlaceholder(200),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      type == WishType.birthday ? Icons.cake : (type == WishType.festival ? Icons.event : Icons.child_care),
                      size: 16,
                      color: const Color(0xFFBC0006),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      type == WishType.birthday ? 'BIRTHDAY WISH' : (type == WishType.festival ? 'COMMUNITY EVENT' : 'NEW ARRIVAL'),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Color(0xFFBC0006),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF370002),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF653D1E),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (type == WishType.birthday) ...[
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite, size: 18),
                        label: const Text('Like'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBC0006),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text('Share'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF370002),
                          side: const BorderSide(color: Color(0xFFDEC0BC)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ] else ...[
                      const Icon(Icons.favorite, color: Color(0xFFBC0006), size: 20),
                      const SizedBox(width: 16),
                      const Icon(Icons.share, color: Color(0xFF370002), size: 20),
                      if (likes != null) ...[
                        const Spacer(),
                        Text(
                          '$likes Likes',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF57413F),
                          ),
                        ),
                      ]
                    ]
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  final String title;
  final String description;

  const AchievementCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2E1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF370002),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium, color: Colors.white, size: 14),
                SizedBox(width: 6),
                Text(
                  'VILLAGE PRIDE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF370002),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF653D1E),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Stack(
                children: [
                  CircleAvatar(radius: 16, backgroundColor: Colors.white, child: Icon(Icons.person, size: 20)),
                  Padding(padding: EdgeInsets.only(left: 20), child: CircleAvatar(radius: 16, backgroundColor: Colors.white, child: Icon(Icons.person, size: 20))),
                  Padding(padding: EdgeInsets.only(left: 40), child: CircleAvatar(radius: 16, backgroundColor: Colors.white, child: Icon(Icons.person, size: 20))),
                ],
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(color: Color(0xFFF5E0BF), shape: BoxShape.circle),
                child: const Center(child: Text('+12', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite, color: Color(0xFFBC0006)),
                style: IconButton.styleFrom(backgroundColor: Colors.white),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share, color: Color(0xFF370002)),
                style: IconButton.styleFrom(backgroundColor: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GeneralAnnouncementCard extends StatelessWidget {
  final String title;
  final String description;

  const GeneralAnnouncementCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E0BF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF370002),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF653D1E),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up),
                  label: const Text('Applaud Effort'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF370002),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Spread the Word'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF370002),
                    side: const BorderSide(color: Color(0xFF370002), width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final String category;
  final Color? categoryColor;
  final String title;
  final String kannadaTitle;
  final String imageUrl;
  final String likes;

  const AnnouncementCard({
    super.key,
    required this.category,
    this.categoryColor,
    required this.title,
    required this.kannadaTitle,
    required this.imageUrl,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF241A06).withOpacity(0.08),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Image.network(
                imageUrl,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildImageErrorPlaceholder(240),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.85),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: categoryColor ?? const Color(0xFFBC0006),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      kannadaTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            color: const Color(0xFFFFF2E1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Color(0xFF5E0006), size: 22),
                    const SizedBox(width: 8),
                    Text(
                      likes,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF241A06),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Row(
                  children: [
                    const Icon(Icons.share_outlined, color: Color(0xFFBC0006), size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Share on WhatsApp',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFBC0006),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildImageErrorPlaceholder(double height) {
  return Container(
    height: height,
    width: double.infinity,
    color: const Color(0xFFF5E0BF),
    child: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported_outlined, color: Color(0xFF8B716E), size: 48),
          SizedBox(height: 8),
          Text(
            'Image not available',
            style: TextStyle(color: Color(0xFF8B716E), fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
