import 'package:afalagi/core/theme/theme.dart';
import 'package:afalagi/core/widgets/button.dart';
import 'package:afalagi/core/widgets/input.dart';
import 'package:afalagi/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<PersonalInfoScreen> createState() =>
      _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _initFromUser(dynamic user) {
    if (_initialized || user == null) return;
    _nameController.text = user.name ?? '';
    _phoneController.text = user.phone ?? '';
    _emailController.text = user.email ?? '';
    _initialized = true;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(authStateProvider.notifier).updateProfile({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(child: Text('Error: $error')),
      ),
      data: (user) {
        _initFromUser(user);
        final isSaving = authState.isLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Profile',
              style: TextStyle(
                fontFamily: 'Figtree',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
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
                  CustomTextField(
                    label: 'FULL NAME',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'PHONE NUMBER',
                    controller: _phoneController,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'EMAIL ADDRESS',
                    controller: _emailController,
                    readOnly: true,
                  ),
                  const SizedBox(height: 48),
                  CustomButton(
                    text: isSaving ? 'Saving...' : 'Save Changes',
                    onPressed: isSaving ? () {} : _save,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
