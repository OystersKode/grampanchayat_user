import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Guest Login (Anonymous)
  Future<User?> signInGuest() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      if (user != null) {
        // Store guest data in Firestore
        await _firestore.collection('guest_users').doc(user.uid).set({
          'device_id': user.uid,
          'role': 'guest',
          'created_at': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred during guest login.';
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Helper to handle Firebase Auth Errors
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'operation-not-allowed':
        return 'Anonymous accounts are not enabled in Firebase Console.';
      case 'user-disabled':
        return 'This user has been disabled.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }
}
