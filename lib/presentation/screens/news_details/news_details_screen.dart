import 'package:flutter/material.dart';

class NewsDetailsScreen extends StatelessWidget {
  const NewsDetailsScreen({super.key});

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
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 350,
                    color: const Color(0xFFF5E0BF),
                    child: const Icon(Icons.image_not_supported_outlined, size: 48),
                  ),
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
        errorBuilder: (context, error, stackTrace) => Container(
          width: 300,
          color: const Color(0xFFF5E0BF),
          child: const Icon(Icons.image_not_supported_outlined),
        ),
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
