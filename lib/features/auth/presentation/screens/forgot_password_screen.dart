import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_strings.dart';
import '../../../../app/routes/app_router.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/text_fields.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/loading_error.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/extensions/extensions.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authProvider.notifier).resetPassword(
          _emailController.text.trim(),
        );

    if (mounted) {
      setState(() => _emailSent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final state = authState.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: Spacing.xxl),
                Icon(
                  _emailSent ? Icons.check_circle : Icons.lock_outline,
                  size: 80,
                  color: _emailSent ? AppColors.success : AppColors.primary,
                ),
                const SizedBox(height: Spacing.lg),
                Text(
                  _emailSent ? 'Email Sent!' : AppStrings.resetPassword,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: Spacing.md),
                Text(
                  _emailSent
                      ? 'Check your email for password reset instructions'
                      : 'Enter your email to receive reset instructions',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: Spacing.xxl),
                if (!_emailSent) ...[
                  AppTextField(
                    controller: _emailController,
                    label: AppStrings.email,
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.fieldRequired;
                      }
                      if (!value.isValidEmail) {
                        return AppStrings.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  if (state?.error != null) ...[
                    const SizedBox(height: Spacing.md),
                    AppErrorWidget(
                      message: state?.error ?? '',
                      icon: Icons.error_outline,
                    ),
                  ],
                  const SizedBox(height: Spacing.lg),
                  PrimaryButton(
                    text: 'Send Reset Link',
                    isLoading: authState.isLoading,
                    isFullWidth: true,
                    onPressed: _resetPassword,
                  ),
                ] else ...[
                  const SizedBox(height: Spacing.lg),
                  PrimaryButton(
                    text: AppStrings.login,
                    isFullWidth: true,
                    onPressed: () => context.go(AppRoutes.login),
                  ),
                ],
                const SizedBox(height: Spacing.lg),
                if (!_emailSent)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Remember your password? '),
                      TextButtonWithIcon(
                        text: AppStrings.login,
                        onPressed: () => context.pop(),
                        icon: Icons.arrow_forward,
                      ),
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
