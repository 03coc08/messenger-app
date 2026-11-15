import 'package:flutter/material.dart';
import 'package:messenger_app/theme/app_colors.dart';

import 'package:messenger_app/services/mattermost_api.dart';
import 'package:messenger_app/screens/forgot_password_page.dart';
import 'package:messenger_app/screens/messenger_screen.dart';
import 'package:messenger_app/screens/signup_page.dart';
import 'package:messenger_app/core/utils/app_snackbar.dart';
import 'package:messenger_app/core/utils/validators.dart';
import 'package:messenger_app/core/network/api_error_handler.dart';
import 'package:messenger_app/widgets/app_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _api = mattermostApi;

  bool _isLoggingIn = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoggingIn) return;
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final error = Validators.login(email: email, password: password);
    if (error != null) {
      AppSnackBar.error(error);
      return;
    }

    setState(() => _isLoggingIn = true);
    try {
      final session = await _api.login(email, password);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => MessengerScreen(session: session, api: _api),
        ),
      );
    } catch (e, stack) {
      AppSnackBar.error(handleRequestError(e, stack).message);
    } finally {
      if (mounted) setState(() => _isLoggingIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black12,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Column(
                  children: [
                    Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 25,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Enter your email and password to securely access your account and manage your services.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      // nhập email
                      AppTextField(
                        key: const Key('emailField'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        hint: 'email Address ',
                        prefixIcon: const Icon(
                          Icons.email,
                          color: AppColors.gray600,
                        ),
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // nhập passwword
                      AppTextField(
                        key: const Key('passwordField'),
                        controller: _passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _login(),
                        hint: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.gray600,
                        ),
                        suffixIcon: const Icon(
                          Icons.visibility_off_outlined,
                          color: AppColors.gray600,
                        ),
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Row(
                      children: [
                        Checkbox(value: false, onChanged: null),
                        Text(
                          'remember me',
                          style: TextStyle(color: AppColors.black),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'forgot password',
                              style: TextStyle(color: AppColors.black),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // nút login
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    key: const Key('loginButton'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _isLoggingIn ? null : _login,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'dont have an accout?',
                      style: TextStyle(color: AppColors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const SignupPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up Here',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Column(
                  children: [
                    Divider(color: AppColors.black, thickness: 1),
                    SizedBox(height: 30),
                    Text('Or Continue With Accout'),
                  ],
                ),
                const SizedBox(height: 30),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialButton(child: Icon(Icons.facebook)),
                    SizedBox(width: 20),
                    _SocialButton(
                      child: Text(
                        'G',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    _SocialButton(child: Icon(Icons.apple)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        boxShadow: [
          BoxShadow(color: AppColors.black12, blurRadius: 5, offset: Offset(1, 3)),
        ],
      ),
      child: Center(child: child),
    );
  }
}
