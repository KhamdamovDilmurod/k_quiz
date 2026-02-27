// lib/repositories/auth_repository.dart

import '../../services/firebase_auth_service.dart';
import '../models/user_model.dart';
import '../../utils/pref_utils.dart';

class AuthRepository {
  final FirebaseAuthService _authService;
  final PrefUtils _prefUtils;

  AuthRepository(this._authService, this._prefUtils);

  Stream<UserModel?> get user {
    return _authService.authStateChanges.map((firebaseUser) {
      return firebaseUser != null
          ? UserModel.fromFirebaseUser(firebaseUser)
          : null;
    });
  }

  Future<UserModel> signIn(String email, String password) async {
    final user = await _authService.signInWithEmail(
      email: email,
      password: password,
    );
    if (user == null) throw 'Login failed';
    final userModel = UserModel.fromFirebaseUser(user);
    await _prefUtils.setUserInfo(userModel);
    return userModel;
  }

  Future<UserModel> register(
    String email,
    String password, {
    String? displayName,
  }) async {
    final user = await _authService.registerWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
    if (user == null) throw 'Registration failed';
    final userModel = UserModel.fromFirebaseUser(user);
    await _prefUtils.setUserInfo(userModel);
    return userModel;
  }

  Future<UserModel> signInWithGoogle({String? displayName}) async {
    final user = await _authService.signInWithGoogle(displayName: displayName);
    if (user == null) throw 'Google login failed';
    final userModel = UserModel.fromFirebaseUser(user);
    await _prefUtils.setUserInfo(userModel);
    return userModel;
  }

  Future<GoogleProfileData?> pickGoogleProfile() {
    return _authService.pickGoogleProfile();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    await _prefUtils.setUserInfo(null);
  }

  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email);
  }
}
