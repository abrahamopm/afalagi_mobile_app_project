import 'package:afalagi/core/theme/theme.dart';
import 'package:afalagi/core/widgets/button.dart';
import 'package:afalagi/core/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _selectedTags = [];
  bool _isAvailable = true;

  final List<String> _availableTags = [
    "Luxury",
    "Modern",
    "Garden",
    "Pool",
    "Security",
    "Parking",
    "Furnished"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Add Property',
          style: TextStyle(
            fontFamily: 'Figtree',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Asymmetric Hero Section (Visuals) Placeholder
              Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined,
                        size: 48, color: Colors.grey[600]),
                    const SizedBox(height: 8),
                    Text(
                      "Upload Property Visuals",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Basic Information"),
                    CustomTextField(label: "Title", hintText: "e.g. Modern Villa in Bole"),
                    const SizedBox(height: 16),
                    CustomTextField(label: "Description", hintText: "Describe the property...", maxLines: 3),

                    const SizedBox(height: 24),
                    _buildSectionHeader("Price Input Section"),
                    CustomTextField(label: "Price", hintText: "e.g. 1500000", keyboardType: TextInputType.number, prefixText: " birr "),

                    const SizedBox(height: 24),
                    _buildSectionHeader("Location Details"),
                    CustomTextField(label: "Address", hintText: "e.g. Churchill Ave"),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: CustomTextField(label: "City", hintText: "e.g. Addis")),
                        const SizedBox(width: 12),
                        Expanded(child: CustomTextField(label: "Zip Code", hintText: "e.g. 1000")),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _buildSectionHeader("Rooms & Layout"),
                    Row(
                      children: [
                        Expanded(child: CustomTextField(label: "Bedrooms", hintText: "3", keyboardType: TextInputType.number)),
                        const SizedBox(width: 12),
                        Expanded(child: CustomTextField(label: "Bathrooms", hintText: "2", keyboardType: TextInputType.number)),
                        const SizedBox(width: 12),
                        Expanded(child: CustomTextField(label: "SQM", hintText: "120", keyboardType: TextInputType.number)),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _buildSectionHeader("Status Selection"),
                    SwitchListTile(
                      title: const Text("Property Availability"),
                      subtitle: Text(_isAvailable ? "Available" : "Sold/Rented"),
                      value: _isAvailable,
                      onChanged: (val) => setState(() => _isAvailable = val),
                      activeColor: AppTheme.primaryColor,
                    ),

                    const SizedBox(height: 24),
                    _buildSectionHeader("Tags / Pills"),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableTags.map((tag) {
                        final isSelected = _selectedTags.contains(tag);
                        return FilterChip(
                          label: Text(tag),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedTags.add(tag);
                              } else {
                                _selectedTags.remove(tag);
                              }
                            });
                          },
                          selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                          checkmarkColor: AppTheme.primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 40),
                    CustomButton(
                      text: "Save Property",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: Save logic
                          context.pop();
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  }

