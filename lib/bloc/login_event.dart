import 'package:equatable/equatable.dart';

enum UserType { customer, vendor }

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserTypeChanged extends LoginEvent {
  final UserType userType;
  UserTypeChanged(this.userType);

  @override
  List<Object?> get props => [userType];
}

class EmailChanged extends LoginEvent {
  final String email;
  EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class LoginSubmitted extends LoginEvent {}
