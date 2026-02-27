// lib/services/firebase_auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleProfileData {
  final String email;
  final String? displayName;
  final String? photoUrl;

  const GoogleProfileData({
    required this.email,
    this.displayName,
    this.photoUrl,
  });
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _googleInitialized = false;
  GoogleSignInAccount? _selectedGoogleAccount;

  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    await GoogleSignIn.instance.initialize();
    _googleInitialized = true;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    }
  }

  Future<User?> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (result.user != null && (displayName?.trim().isNotEmpty ?? false)) {
        await result.user!.updateDisplayName(displayName!.trim());
        await result.user!.reload();
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    }
  }

  Future<GoogleProfileData?> pickGoogleProfile() async {
    try {
      await _ensureGoogleInitialized();
      final account = await GoogleSignIn.instance.authenticate();
      _selectedGoogleAccount = account;
      return GoogleProfileData(
        email: account.email,
        displayName: account.displayName,
        photoUrl: account.photoUrl,
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      throw 'Google akkauntni olishda xatolik: ${e.code.name}';
    }
  }

  Future<User?> signInWithGoogle({String? displayName}) async {
    try {
      await _ensureGoogleInitialized();
      final account = _selectedGoogleAccount ?? await GoogleSignIn.instance.authenticate();

      final googleAuth = account.authentication;
      if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
        throw 'Google ID token olinmadi. Firebase Console da Google Sign-In va SHA-1 ni tekshiring.';
      }
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;
      if (user != null && (displayName?.trim().isNotEmpty ?? false)) {
        await user.updateDisplayName(displayName!.trim());
        await user.reload();
      }
      _selectedGoogleAccount = null;
      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw 'Google sign-in bekor qilindi';
      }
      throw 'Google orqali kirishda xatolik yuz berdi';
    } catch (_) {
      throw 'Google orqali kirishda xatolik yuz berdi';
    }
  }

  Future<void> signOut() async {
    await _ensureGoogleInitialized();
    await GoogleSignIn.instance.signOut();
    _selectedGoogleAccount = null;
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    }
  }

  String _handleAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Bu email allaqachon ro\'yxatdan o\'tgan';
      case 'invalid-email':
        return 'Email noto\'g\'ri';
      case 'weak-password':
        return 'Parol juda oddiy (kamida 6 ta belgi)';
      case 'user-not-found':
        return 'Foydalanuvchi topilmadi';
      case 'wrong-password':
        return 'Parol noto\'g\'ri';
      case 'invalid-credential':
        return 'Email yoki parol noto\'g\'ri';
      default:
        return 'Xatolik yuz berdi';
    }
  }
}
