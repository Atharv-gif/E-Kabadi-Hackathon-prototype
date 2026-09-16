import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Aarav Sharma');
  final TextEditingController _phoneController = TextEditingController(text: '9876512345');
  final TextEditingController _emailController = TextEditingController(text: 'aarav@example.com');
  final _formKey = GlobalKey<FormState>();

  void _onSignup() async {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      await ref.read(authProvider.notifier).login(phone);
      if (mounted) {
        context.push('/otp', extra: phone);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Account',
                    style: AppTypography.displayMedium.copyWith(fontSize: 26),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join the digital recycling revolution in your city.',
                    style: AppTypography.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Full Name',
                    hint: 'Aarav Sharma',
                    controller: _nameController,
                    prefixIcon: const Icon(LucideIcons.user, color: AppColors.textMuted),
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Mobile Number',
                    hint: '9876543210',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(LucideIcons.phone, color: AppColors.textMuted),
                    validator: (val) => val == null || val.length < 10 ? 'Enter valid number' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Email Address (Optional)',
                    hint: 'aarav@example.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(LucideIcons.mail, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'Register & Continue',
                    onPressed: _onSignup,
                    isLoading: authState.isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
