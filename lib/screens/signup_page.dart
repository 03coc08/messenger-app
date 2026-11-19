import 'package:flutter/material.dart';
import 'package:messenger_app/theme/figma_colors.dart';
import 'package:messenger_app/widgets/app_text_field.dart';
import 'package:messenger_app/core/utils/app_snackbar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: FigmaColors.surfaceBlackOpacity0),
      body: SafeArea(
        top: false,
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Tạo tài khoản',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Đăng ký để bắt đầu trò chuyện với bạn bè.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: FigmaColors.effectNeutral02,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 26),
                    AppTextField(
                      label: 'Họ và tên',
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      validator: (value) => (value?.trim().isEmpty ?? true)
                          ? 'Vui lòng nhập họ tên.'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      keyboardType: TextInputType.emailAddress,
                      label: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (value) => (value?.contains('@') ?? false)
                          ? null
                          : 'Vui lòng nhập email hợp lệ.',
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      label: 'Mật khẩu',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                      validator: (value) => (value?.length ?? 0) < 6
                          ? 'Mật khẩu phải có ít nhất 6 ký tự.'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      obscureText: _obscurePassword,
                      label: 'Nhập lại mật khẩu',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      validator: (value) => value == _passwordController.text
                          ? null
                          : 'Mật khẩu nhập lại không khớp.',
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      height: 54,
                      child: FilledButton(
                        onPressed: () {
                          if (!(_formKey.currentState?.validate() ?? false)) {
                            return;
                          }
                          AppSnackBar.success('Tạo tài khoản thành công.');

                          Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: FigmaColors.surfaceBrandPrimary02,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text('Đăng ký'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
