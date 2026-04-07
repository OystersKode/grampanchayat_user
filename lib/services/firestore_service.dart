import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ----------------------------------------
  // NEWS METHODS (READ ONLY)
  // ----------------------------------------

  Future<List<QueryDocumentSnapshot>> getAllNews() async {
    QuerySnapshot snapshot = await _db
        .collection('news')
        .orderBy('created_at', descending: true)
        .get();
    return snapshot.docs;
  }

  Future<DocumentSnapshot> getNewsById(String newsId) async {
    return await _db.collection('news').doc(newsId).get();
  }

  // ----------------------------------------
  // NEWS IMAGES (SUBCOLLECTION - READ ONLY)
  // ----------------------------------------

  Future<List<QueryDocumentSnapshot>> getNewsImages(String newsId) async {
    QuerySnapshot snapshot = await _db
        .collection('news')
        .doc(newsId)
        .collection('images')
        .get();
    return snapshot.docs;
  }

  // ----------------------------------------
  // MEMBER REQUEST METHODS (USER ACTION)
  // ----------------------------------------

  Future<void> createMemberRequest(Map<String, dynamic> data) async {
    await _db.collection('member_requests').add({
      ...data,
      'status': 'pending',
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // ----------------------------------------
  // LIKES SYSTEM (USER ACTION)
  // ----------------------------------------

  Future<void> toggleLike(String guestId, String contentId, String contentType) async {
    QuerySnapshot existingLike = await _db
        .collection('likes')
        .where('guest_id', isEqualTo: guestId)
        .where('content_id', isEqualTo: contentId)
        .where('content_type', isEqualTo: contentType)
        .limit(1)
        .get();

    if (existingLike.docs.isNotEmpty) {
      await _db.collection('likes').doc(existingLike.docs.first.id).delete();
    } else {
      await _db.collection('likes').add({
        'guest_id': guestId,
        'content_id': contentId,
        'content_type': contentType,
        'created_at': FieldValue.serverTimestamp(),
      });
    }
  }

  // ----------------------------------------
  // USER ACTIVITY (USER ACTION)
  // ----------------------------------------

  Future<void> logActivity(String guestId, String action) async {
    await _db.collection('user_activity').add({
      'guest_id': guestId,
      'action': action,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // ----------------------------------------
  // SEED DATA (TEMPORARY)
  // ----------------------------------------

  Future<void> seedData() async {
    final WriteBatch batch = _db.batch();

    // 1. Seed News
    final List<Map<String, dynamic>> newsData = [
      {
        'title': 'New Digital Library Inaugurated',
        'content': '### Empowering Youth through Technology\n\n'
            'We are proud to announce the opening of our new **Digital Library**. It features:\n\n'
            '*   10 High-speed computers\n'
            '*   Free Wi-Fi for students\n'
            '*   Access to 5000+ E-books\n\n'
            'The library will be open from 10:00 AM to 6:00 PM every day.',
        'header_image_url': 'https://images.unsplash.com/photo-1521587760476-6c12a4b040da?auto=format&fit=crop&q=80&w=800',
        'category': 'DEVELOPMENT',
        'created_at': FieldValue.serverTimestamp(),
        'like_count': 0,
      },
      {
        'title': 'Annual Village Health Camp',
        'content': '### Free Health Checkup for All Residents\n\n'
            'Join us this Sunday at the Community Center for a comprehensive health checkup.\n\n'
            '**Specialists Available:**\n'
            '1. General Physician\n'
            '2. Pediatrician\n'
            '3. Eye Specialist\n\n'
            '_Please bring your ID cards for registration._',
        'header_image_url': 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&q=80&w=800',
        'category': 'HEALTH',
        'created_at': FieldValue.serverTimestamp(),
        'like_count': 0,
      },
      {
        'title': 'ಹೊಸ ಕುಡಿಯುವ ನೀರಿನ ಯೋಜನೆ ಚಾಲನೆ',
        'content': '### ಪ್ರತಿಯೊಂದು ಮನೆಗೆ ಶುದ್ಧ ಕುಡಿಯುವ ನೀರು\n\n'
            'ಗ್ರಾಮ ಪಂಚಾಯತಿಯ ವತಿಯಿಂದ **ಹೊಸ ಕುಡಿಯುವ ನೀರಿನ ಯೋಜನೆ**ಯನ್ನು ಪ್ರಾರಂಭಿಸಲಾಗಿದೆ.\n\n'
            '*   ಹೊಸ ಪೈಪ್‌ಲೈನ್ ಅಳವಡಿಕೆ\n'
            '*   24x7 ನೀರಿನ ಪೂರೈಕೆ\n'
            '*   ಶುದ್ಧೀಕರಣ ಘಟಕದ ಸ್ಥಾಪನೆ\n\n'
            'ಈ ಯೋಜನೆಯು ಮುಂದಿನ ತಿಂಗಳಿನಿಂದ ಪೂರ್ಣಗೊಳ್ಳಲಿದೆ.',
        'header_image_url': 'https://images.unsplash.com/photo-1541810270634-2bc35b38195d?auto=format&fit=crop&q=80&w=800',
        'category': 'ಯೋಜನೆ',
        'created_at': FieldValue.serverTimestamp(),
        'like_count': 0,
      },
      {
        'title': 'ಗ್ರಾಮ ಸಭೆಯ ನೋಟಿಸ್',
        'content': '### ಮುಖ್ಯ ಗ್ರಾಮ ಸಭೆ ಆಯೋಜನೆ\n\n'
            'ಗ್ರಾಮದ ಅಭಿವೃದ್ಧಿ ಕಾಮಗಾರಿಗಳ ಬಗ್ಗೆ ಚರ್ಚಿಸಲು **ಗ್ರಾಮ ಸಭೆ**ಯನ್ನು ಕರೆಯಲಾಗಿದೆ.\n\n'
            '**ದಿನಾಂಕ:** ನವೆಂಬರ್ 25, 2024\n'
            '**ಸಮಯ:** ಮಧ್ಯಾಹ್ನ 2:00 ಗಂಟೆಗೆ\n'
            '**ಸ್ಥಳ:** ಗ್ರಾಮ ಪಂಚಾಯತಿ ಸಭಾಂಗಣ\n\n'
            '_ಎಲ್ಲಾ ಗ್ರಾಮಸ್ಥರು ಭಾಗವಹಿಸಬೇಕೆಂದು ವಿನಂತಿಸಲಾಗಿದೆ._',
        'header_image_url': 'https://images.unsplash.com/photo-1517048676732-d65bc937f952?auto=format&fit=crop&q=80&w=800',
        'category': 'ಸೂಚನೆ',
        'created_at': FieldValue.serverTimestamp(),
        'like_count': 0,
      },
    ];

    for (var news in newsData) {
      batch.set(_db.collection('news').doc(), news);
    }

    // 2. Seed Wishes
    final List<Map<String, dynamic>> wishesData = [
      {
        'title': 'Happy Independence Day!',
        'content': 'Wishing all the citizens of Kagwad a very Happy Independence Day. Let us build a stronger village together.',
        'tag': 'FESTIVAL',
        'header_image_url': 'https://images.unsplash.com/photo-1532375810709-75b1da00537c?auto=format&fit=crop&q=80&w=800',
        'created_at': FieldValue.serverTimestamp(),
      },
      {
        'title': 'ಗಣೇಶ ಚತುರ್ಥಿಯ ಶುಭಾಶಯಗಳು',
        'content': 'ನಮ್ಮ ಗ್ರಾಮದ ಎಲ್ಲಾ ಜನತೆಗೆ ಗಣೇಶ ಚತುರ್ಥಿಯ ಹಾರ್ದಿಕ ಶುಭಾಶಯಗಳು. ಸುಖ, ಶಾಂತಿ ಮತ್ತು ಸಮೃದ್ಧಿ ಸಿಗಲಿ ಎಂದು ಪ್ರಾರ್ಥಿಸುತ್ತೇವೆ.',
        'tag': 'ಹಬ್ಬ',
        'header_image_url': 'https://images.unsplash.com/photo-1621252179027-94459d278660?auto=format&fit=crop&q=80&w=800',
        'created_at': FieldValue.serverTimestamp(),
      },
    ];

    for (var wish in wishesData) {
      batch.set(_db.collection('wishes').doc(), wish);
    }

    await batch.commit();
  }

  Future<List<QueryDocumentSnapshot>> getAllWishes() async {
    QuerySnapshot snapshot = await _db
        .collection('wishes')
        .orderBy('created_at', descending: true)
        .get();
    return snapshot.docs;
  }
}
