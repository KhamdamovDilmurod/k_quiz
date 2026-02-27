// lib/repositories/auth_repository.dart

import '../../services/firebase_auth_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuthService _authService;

  AuthRepository(this._authService);

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
    return UserModel.fromFirebaseUser(user);
  }

  Future<UserModel> register(String email, String password) async {
    final user = await _authService.registerWithEmail(
      email: email,
      password: password,
    );
    if (user == null) throw 'Registration failed';
    return UserModel.fromFirebaseUser(user);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email);
  }
}