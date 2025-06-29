import 'package:equatable/equatable.dart';
import 'login_event.dart';

class LoginState extends Equatable {
  final UserType userType;
  final String email;
  final String password;
  final String? loginResult;
  final String? userId;

  const LoginState({
    this.userType = UserType.customer,
    this.email = '',
    this.password = '',
    this.loginResult,
    this.userId,
  });

  LoginState copyWith({
    UserType? userType,
    String? email,
    String? password,
    String? loginResult,
    String? userId,
  }) {
    return LoginState(
      userType: userType ?? this.userType,
      email: email ?? this.email,
      password: password ?? this.password,
      loginResult: loginResult,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [userType, email, password, loginResult];
}
