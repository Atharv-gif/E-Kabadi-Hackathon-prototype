import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '9876512345');
  final _formKey = GlobalKey<FormState>();

  void _onContinue() async {
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
          onPressed: () => context.go('/onboarding'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to E-Kabaadi',
                  style: AppTypography.displayMedium.copyWith(fontSize: 26),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your mobile number to get an OTP for verification.',
                  style: AppTypography.bodyLarge,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'Mobile Number',
                  hint: '9876543210',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      '+91',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.length < 10) {
                      return 'Please enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Get OTP Code',
                  onPressed: _onContinue,
                  isLoading: authState.isLoading,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: AppTypography.bodyMedium),
                    GestureDetector(
                      onTap: () => context.push('/signup'),
                      child: Text(
                        'Sign Up',
                        style: AppTypography.titleSmall.copyWith(color: AppColors.primary),
                      ),
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
