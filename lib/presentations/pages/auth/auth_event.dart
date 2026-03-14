part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
  final dynamic user;
  AuthUserChanged(this.user);
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  AuthSignInRequested(this.email, this.password);
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String? displayName;
  AuthRegisterRequested(this.email, this.password, {this.displayName});
}

class AuthGoogleSignInRequested extends AuthEvent {
  final String? displayName;
  AuthGoogleSignInRequested({this.displayName});
}

class AuthSignOutRequested extends AuthEvent {}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;
  AuthPasswordResetRequested(this.email);
}
