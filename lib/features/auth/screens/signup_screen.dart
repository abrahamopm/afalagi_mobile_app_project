import 'package:afalagi/core/widgets/button.dart';
import 'package:afalagi/core/widgets/input.dart';
import 'package:afalagi/core/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:afalagi/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:afalagi/core/widgets/image.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please agree to the Terms of Service")),
        );
        return;
      }
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) {
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
                  text: "Sign Up",
                  onPressed: _handleSignup,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => context.pop(),
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