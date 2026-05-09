import 'package:afalagi/core/widgets/button.dart';
import 'package:afalagi/core/widgets/image.dart';
import 'package:afalagi/core/theme/theme.dart';
import 'package:afalagi/core/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(child: CustomImages.appLogo(height: 75)),
              const SizedBox(height: 30),
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please enter your credentials to manage your portfolio.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                label: "EMAIL ADDRESS",
                hintText: "john.doe@curator.com",
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
                children: const [
                  Switch(value: false, onChanged: null),
                  Text("Remember Me"),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Sign in",
                  onPressed: () => context.go('/dashboard'),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member? "),
                  GestureDetector(
                    onTap: () => context.push('/signup'),
                    child: const Text(
                      "Sign Up",
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
