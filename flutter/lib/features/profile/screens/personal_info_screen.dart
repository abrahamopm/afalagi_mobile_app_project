import 'dart:convert';
import 'package:afalagi/core/theme/Theme.dart';
import 'package:afalagi/core/widgets/button.dart';
import 'package:afalagi/core/widgets/input.dart';
import 'package:afalagi/core/widgets/image.dart';
import 'package:afalagi/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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
  final _bioController = TextEditingController();
  String? _pickedBase64Image;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _initFromUser(dynamic user) {
    if (_initialized || user == null) return;
    _nameController.text = user.name ?? '';
    _phoneController.text = user.phone ?? '';
    _emailController.text = user.email ?? '';
    _bioController.text = user.bio ?? '';
    _initialized = true;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 50,
        maxWidth: 800,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        final mimeType = image.name.endsWith('png') ? 'image/png' : 'image/jpeg';
        setState(() {
          _pickedBase64Image = 'data:$mimeType;base64,$base64String';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: AppTheme.primaryColor),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined, color: AppTheme.primaryColor),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final updateData = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
      };
      if (_pickedBase64Image != null) {
        updateData['profileImage'] = _pickedBase64Image!;
      }

      await ref.read(authStateProvider.notifier).updateProfile(updateData);
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
                  // Row with Figma layout: Left Avatar, Right Title/Sub
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFEDF2F7),
                                width: 3,
                              ),
                            ),
                            child: ClipOval(
                              child: _pickedBase64Image != null
                                  ? CustomImages.resilientImage(
                                      _pickedBase64Image!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : CustomImages.resilientImage(
                                      user!.profileImage,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _showImagePickerOptions,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Personal\nDetails',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Figtree',
                                color: AppColors.primary,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Update your public profile and contact info',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'PROFESSIONAL BIO',
                    controller: _bioController,
                    maxLines: 4,
                    hintText: 'Share your real estate experience, areas of operation, and specializations...',
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
