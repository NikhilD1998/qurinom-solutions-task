import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinom/utils/constants.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<UserTypeChanged>((event, emit) {
      emit(state.copyWith(userType: event.userType));
    });
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });
    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
    on<LoginSubmitted>((event, emit) async {
      final url = Uri.parse('${baseApiUrl}user/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': state.email,
          'password': state.password,
          'role': state.userType == UserType.customer ? 'customer' : 'vendor',
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final userId = decoded['data']?['user']?['_id'];
        emit(state.copyWith(loginResult: response.body, userId: userId));
      } else {
        emit(
          state.copyWith(
            loginResult: 'Error: ${response.statusCode} ${response.body}',
          ),
        );
      }
    });
  }
}
