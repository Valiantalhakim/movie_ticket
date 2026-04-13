part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoginEvent extends AuthEvent {
  const LoginEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => <Object?>[email, password];
}

class RegisterEvent extends AuthEvent {
  const RegisterEvent({
    required this.fullName,
    required this.email,
    required this.password,
  });

  final String fullName;
  final String email;
  final String password;

  @override
  List<Object?> get props => <Object?>[fullName, email, password];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}
