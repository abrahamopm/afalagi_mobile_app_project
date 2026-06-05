import 'package:afalagi/core/widgets/button.dart';
import 'package:afalagi/core/widgets/input.dart';
import 'package:afalagi/core/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:afalagi/core/widgets/image.dart';

import '../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _agencyNameController = TextEditingController();
  final _agencyLicenseController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _agencyNameController.dispose();
    _agencyLicenseController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please agree to the Terms of Service")),
        );
        return;
      }
      
      await ref.read(authStateProvider.notifier).signup(
        name: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        agencyName: _agencyNameController.text.trim(),
        agencyLicense: _agencyLicenseController.text.trim(),
      );

      if (mounted) {
        final authState = ref.read(authStateProvider);
        if (authState.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authState.error.toString())),
          );
        } else if (authState.value != null) {
          context.go('/dashboard');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const SizedBox(height: 20),
              CustomImages.appLogo(height: 55),
              const SizedBox(height: 20),
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("Enter your details to begin your journey."),
              const SizedBox(height: 20),
              CustomTextField(
                label: "FULL NAME",
                hintText: "Kaleab Mulugeta",
                controller: _fullNameController,
                prefixIcon: const Icon(Icons.person_outline, size: 20),
                validator: Validators.validateFullName,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: "EMAIL ADDRESS",
                hintText: "kalili@gmail.com",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined, size: 20),
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: "PASSWORD",
                hintText: "••••••••",
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20,
                ),
                onSuffixIconTap: _togglePasswordVisibility,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: "PHONE (OPTIONAL)",
                hintText: "+251 9XX XXX XXX",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined, size: 20),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: "AGENCY NAME (OPTIONAL)",
                hintText: "Your Agency",
                controller: _agencyNameController,
                prefixIcon: const Icon(Icons.business_outlined, size: 20),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: "AGENCY LICENSE (OPTIONAL)",
                hintText: "License number",
                controller: _agencyLicenseController,
                prefixIcon: const Icon(Icons.badge_outlined, size: 20),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: isLoading ? null : (value) {
                      setState(() {
                        _agreeToTerms = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "I agree to the ",
                        children: [
                          TextSpan(
                            text: "Terms of Service",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          TextSpan(text: "."),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: isLoading ? "Signing Up..." : "Sign Up",
                  onPressed: isLoading ? () {} : _handleSignup,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: isLoading ? null : () => context.pop(),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
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