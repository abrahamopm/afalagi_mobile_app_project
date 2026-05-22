import 'package:afalagi/core/theme/theme.dart';
import 'package:afalagi/core/widgets/button.dart';
import 'package:afalagi/core/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers with initial data from design
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "Dawit Gebremariam");
    _phoneController = TextEditingController(text: "+251 91 123 4567");
    _emailController = TextEditingController(text: "dawit.realty@afalagi.et");
    _bioController = TextEditingController(
      text: "Specializing in luxury apartments in Bole and CMC. Helping clients find their dream homes across Addis Ababa."
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontFamily: 'Figtree', fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal\nDetails',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Figtree',
                  color: Color(0xFF1B385E),
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Update your public profile and contact info',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),

              CustomTextField(label: "FULL NAME", controller: _nameController),
              const SizedBox(height: 24),
              CustomTextField(label: "PHONE NUMBER", controller: _phoneController),
              const SizedBox(height: 24),
              CustomTextField(label: "EMAIL ADDRESS", controller: _emailController),
              const SizedBox(height: 24),
              CustomTextField(label: "PROFESSIONAL BIO", controller: _bioController, maxLines: 4),

              const SizedBox(height: 48),
              CustomButton(
                text: "Save Changes",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.pop();
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
