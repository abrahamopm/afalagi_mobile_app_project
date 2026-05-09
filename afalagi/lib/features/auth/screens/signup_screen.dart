import 'package:afalagi/core/widgets/button.dart';
import 'package:afalagi/core/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:afalagi/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:afalagi/core/widgets/image.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),

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
                prefixIcon: const Icon(Icons.person_outline, size: 20),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: "EMAIL ADDRESS",
                hintText: "kalili@gmail.com",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined, size: 20),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: "PASSWORD",
                hintText: "••••••••",
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: const Icon(Icons.visibility_off_outlined, size: 20),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(value: false, onChanged: null),
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
                  onPressed: () => context.go('/dashboard'),
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
    );
  }
}
