import 'package:equatable/equatable.dart';
import 'login_event.dart';

class LoginState extends Equatable {
  final UserType userType;
  final String email;
  final String password;
  final String? loginResult; // <-- Add this
  final String? userId;

  const LoginState({
    this.userType = UserType.customer,
    this.email = '',
    this.password = '',
    this.loginResult, // <-- Add this
    this.userId,
  });

  LoginState copyWith({
    UserType? userType,
    String? email,
    String? password,
    String? loginResult, // <-- Add this
    String? userId,
  }) {
    return LoginState(
      userType: userType ?? this.userType,
      email: email ?? this.email,
      password: password ?? this.password,
      loginResult: loginResult, // <-- Always override for result
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [userType, email, password, loginResult];
}
