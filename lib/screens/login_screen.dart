import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinom/utils/constants.dart';
import 'package:qurinom/utils/helper.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LoginForm();
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = DeviceHelper.width(context);
    double screenHeight = DeviceHelper.height(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.06), // Responsive padding
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.loginResult != null) {
              if (!state.loginResult!.startsWith('Error:')) {
                final responseJson = jsonDecode(state.loginResult!);
                final userId = responseJson['data']?['user']?['_id'];
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen(userId: userId)),
                );
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Login failed!')));
              }
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return ToggleButtons(
                    isSelected: [
                      state.userType == UserType.customer,
                      state.userType == UserType.vendor,
                    ],
                    onPressed: (int index) {
                      context.read<LoginBloc>().add(
                        UserTypeChanged(
                          index == 0 ? UserType.customer : UserType.vendor,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    fillColor: primaryColor,
                    selectedColor: Colors.white,
                    color: Colors.black,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text('Customer'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text('Vendor'),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.04), // Responsive spacing
              TextField(
                controller: _emailController,
                onChanged: (value) =>
                    context.read<LoginBloc>().add(EmailChanged(value)),
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                ), // Responsive font
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ), // <-- grey border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ), // <-- grey border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ), // <-- grey border
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Responsive spacing
              TextField(
                controller: _passwordController,
                obscureText: true,
                onChanged: (value) =>
                    context.read<LoginBloc>().add(PasswordChanged(value)),
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                ), // Responsive font
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05), // Responsive spacing
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.065, // Responsive button height

                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                  ),
                  onPressed: () {
                    context.read<LoginBloc>().add(LoginSubmitted());
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
