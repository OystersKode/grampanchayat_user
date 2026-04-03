import 'package:flutter/material.dart';
import '../../widgets/sidebar.dart';

enum WishType { birthday, festival, newArrival }

class WishesScreen extends StatelessWidget {
  const WishesScreen({super.key});

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
                side: const BorderSide(color: Colors.white24),
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
            'Celebrating the milestones, festivals, and achievements that bind Kagwad together.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF653D1E),
            ),
          ),
          const SizedBox(height: 32),
          
          const WishCard(
            type: WishType.birthday,
            title: 'Happy Birthday to Ramesh Gowda 🎉',
            description: 'Wishing our esteemed elder and community leader a very happy 75th birthday. Your wisdom continues to guide us.',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCNsnlSxvtXI4n7hSbLl-kM3a5Lxo5VncN95w6ub9xJlJ9Lnv8TIopx584Ojms5OOBSM5_hI9kvtEE5Cz-MIr1WkV2tkNAiWhXvNTYK3IC2--BCEQQ8wRv9aym765n1__oFaNwY2yGExjVDYdCFVorMF0gE75DDYG7w6g0mRB0Nim6RtK49w8-agoJBKQvX9jt37TXNYGrC1q9WbXxMxwojHfsWCgrmMvK53_yZK85Ct2qYuUfrgXJZnmBCaAAP_5L7bvPLxfdWOfs',
          ),

          const WishCard(
            type: WishType.festival,
            title: 'Ugadi Festival Wishes to All Villagers 🌸',
            description: 'May this New Year bring prosperity, health, and abundant harvests to every household in Kagwad.',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuATPRDTKltq3NSKCtVaz3jo55Z-ktd5R17yM_pbnS8xCGjMxqwoSQAle0c7sKT0SslbtlZYeun4a34np0nNfcvvIDRJRmYZofTZNnRd3WihC59MAWSlw2Sz9J9h_jT0xVe0hahYpPGJEAb5HaFT6k2_W6OKY1av6zXPyZO0HPlEOA0EpN0XPDJaMO2iif4HYmXgSMIGMCigrl7msLBpvLtvyFkfwGRhhfEXY_5SENJHORKIFitXFR_5tPOY_AfZLGQVbdQOxtEb4IE',
            likes: '128',
          ),

          const AchievementCard(
            title: 'Local Achievement: 10th Standard Toppers Honored',
            description: 'The Panchayat proudly recognizes the hard work of our students. Success is the fruit of dedication.',
          ),

          const WishCard(
            type: WishType.newArrival,
            title: 'Welcome to the World!',
            description: 'Congratulating Shweta and Murali on the arrival of their baby boy.',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAyLIX_pyK-7bgCKs4CjisO7h9GEmFX7zAVKvgZKa6hiKd1StvS6IDeZqd7gv8TVuK800dsmvu8a679_O6oKoFWOx7E6EEXOvYTJrRR1xKp57Fu7QBUQnIz_2b7asCga0y1fp_CGw4Ds797l6yfOt0okPl85fBx979rbT6Vg4LTobVihZQPwHxBFy3MyzggCeVEClA3Luiz8JSssV3QSibd0j7oUD2ONjndccO2mjge0Nuf_Zt36dXIeQRmL3V7DPi80pZeDr9MksE',
          ),

          const GeneralAnnouncementCard(
            title: 'General Announcements & Communal Harmony',
            description: 'The Panchayat wishes to thank everyone who participated in the Shramadaan (voluntary labor) last weekend. Our village roads look beautiful because of you!',
          ),
        ],
      ),
    );
  }
}

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
