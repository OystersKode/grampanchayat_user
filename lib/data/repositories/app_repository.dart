import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/news_model.dart';
import '../models/wish_model.dart';

class AppRepository {
  AppRepository._(this._firestore, this._auth);

  static AppRepository? _instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  static void initialize() {
    _instance = AppRepository._(
      FirebaseFirestore.instance,
      FirebaseAuth.instance,
    );
  }

  static AppRepository get instance {
    final AppRepository? instance = _instance;
    if (instance == null) {
      throw StateError('AppRepository.initialize() must be called first');
    }
    return instance;
  }

  // In-memory cache
  final Map<String, List<News>> _newsCache = {};
  final Map<String, List<Wish>> _wishesCache = {};

  // Updated News result class for pagination
  Future<({List<News> news, DocumentSnapshot? lastDoc})> getNews({
    DateTime? startDate,
    DateTime? endDate,
    DocumentSnapshot? startAfter,
    int limit = 10,
    bool forceRefresh = false,
  }) async {
    final String cacheKey = '${startDate?.toIso8601String()}_${endDate?.toIso8601String()}';
    
    // Only use cache for the first page and if not forcing refresh
    if (!forceRefresh && startAfter == null && _newsCache.containsKey(cacheKey)) {
      return (news: _newsCache[cacheKey]!, lastDoc: null); // lastDoc null because we don't cache pagination tokens
    }

    final String? uid = _auth.currentUser?.uid;
    
    Query query = _firestore.collection('news');

    if (startDate != null) {
      query = query.where('created_at', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }
    if (endDate != null) {
      query = query.where('created_at', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }

    query = query.orderBy('created_at', descending: true).limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final QuerySnapshot querySnapshot = await query.get();

    List<News> newsList = [];
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      
      final imagesSnapshot = await doc.reference.collection('images').get();
      data['images'] = imagesSnapshot.docs.map((d) => d.data()['image_url']).toList();
      
      if (uid != null) {
        final likeQuery = await _firestore
            .collection('likes')
            .where('guest_id', isEqualTo: uid)
            .where('content_id', isEqualTo: doc.id)
            .where('content_type', isEqualTo: 'news')
            .limit(1)
            .get();
        data['is_liked'] = likeQuery.docs.isNotEmpty;
      } else {
        data['is_liked'] = false;
      }
      
      newsList.add(News.fromJson(data));
    }
    
    if (startAfter == null) {
      _newsCache[cacheKey] = newsList;
    }

    return (
      news: newsList,
      lastDoc: querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null
    );
  }

  Future<News> getNewsDetails(String id) async {
    final String? uid = _auth.currentUser?.uid;
    final DocumentSnapshot doc = await _firestore.collection('news').doc(id).get();
    
    if (!doc.exists) {
      throw Exception('News not found');
    }

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;

    // Fetch subcollection images
    final imagesSnapshot = await doc.reference.collection('images').get();
    data['images'] = imagesSnapshot.docs.map((d) => d.data()['image_url']).toList();

    if (uid != null) {
      final likeQuery = await _firestore
          .collection('likes')
          .where('guest_id', isEqualTo: uid)
          .where('content_id', isEqualTo: id)
          .where('content_type', isEqualTo: 'news')
          .limit(1)
          .get();
      data['is_liked'] = likeQuery.docs.isNotEmpty;
    } else {
      data['is_liked'] = false;
    }

    return News.fromJson(data);
  }

  Future<void> submitMemberRequest({
    required String name,
    required String mobileNumber,
    required String address,
  }) async {
    final String? uid = _auth.currentUser?.uid;
    await _firestore.collection('member_requests').add({
      'user_uid': uid,
      'name': name,
      'mobile_number': mobileNumber,
      'address': address,
      'status': 'pending',
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> toggleLike({
    required String contentId,
    required String contentType,
  }) async {
    final String? uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');

    final QuerySnapshot existingLike = await _firestore
        .collection('likes')
        .where('guest_id', isEqualTo: uid)
        .where('content_id', isEqualTo: contentId)
        .where('content_type', isEqualTo: contentType)
        .limit(1)
        .get();

    final DocumentReference contentRef = _firestore.collection(contentType).doc(contentId);

    if (existingLike.docs.isNotEmpty) {
      // Unlike
      await _firestore.runTransaction((transaction) async {
        transaction.delete(_firestore.collection('likes').doc(existingLike.docs.first.id));
        transaction.update(contentRef, {
          'like_count': FieldValue.increment(-1),
        });
      });
      return false;
    } else {
      // Like
      await _firestore.runTransaction((transaction) async {
        transaction.set(_firestore.collection('likes').doc(), {
          'guest_id': uid,
          'content_id': contentId,
          'content_type': contentType,
          'created_at': FieldValue.serverTimestamp(),
        });
        transaction.update(contentRef, {
          'like_count': FieldValue.increment(1),
        });
      });
      return true;
    }
  }

  Future<List<Wish>> getWishes({bool forceRefresh = false}) async {
    if (!forceRefresh && _wishesCache.containsKey('all')) {
      return _wishesCache['all']!;
    }

    final String? uid = _auth.currentUser?.uid;
    final QuerySnapshot querySnapshot = await _firestore
        .collection('wishes')
        .orderBy('created_at', descending: true)
        .get();

    List<Wish> wishes = [];
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;

      if (uid != null) {
        final likeQuery = await _firestore
            .collection('likes')
            .where('guest_id', isEqualTo: uid)
            .where('content_id', isEqualTo: doc.id)
            .where('content_type', isEqualTo: 'wishes')
            .limit(1)
            .get();
        data['is_liked'] = likeQuery.docs.isNotEmpty;
      } else {
        data['is_liked'] = false;
      }

      wishes.add(Wish.fromJson(data));
    }
    
    _wishesCache['all'] = wishes;
    return wishes;
  }
}
