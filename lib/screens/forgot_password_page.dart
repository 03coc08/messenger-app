import 'package:flutter/material.dart';
import 'package:messenger_app/theme/figma_colors.dart';
import 'package:messenger_app/theme/figma_typography.dart';
import 'package:messenger_app/widgets/app_text_field.dart';
import 'package:messenger_app/core/utils/app_snackbar.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(backgroundColor: FigmaColors.surfaceBlackOpacity0),
      body: SafeArea(
        top: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.lock_reset_rounded,
                      size: 68,
                      color: FigmaColors.surfaceBrandPrimary02,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Quên mật khẩu?',
                      textAlign: TextAlign.center,
                      style: FigmaTypography.heading28,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Nhập email để nhận hướng dẫn đặt lại mật khẩu.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: FigmaColors.effectNeutral02,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    AppTextField(
                      keyboardType: TextInputType.emailAddress,
                      label: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (value) => (value?.contains('@') ?? false)
                          ? null
                          : 'Vui lòng nhập email hợp lệ.',
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 54,
                      child: FilledButton(
                        onPressed: () {
                          if (!(formKey.currentState?.validate() ?? false)) {
                            return;
                          }
                          AppSnackBar.success(
                            'Đã gửi hướng dẫn đặt lại mật khẩu.',
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: FigmaColors.surfaceBrandPrimary02,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text('Gửi hướng dẫn'),
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
