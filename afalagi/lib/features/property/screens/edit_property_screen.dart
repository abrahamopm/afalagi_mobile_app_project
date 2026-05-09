import 'package:afalagi/core/theme/theme.dart';
import 'package:afalagi/core/widgets/button.dart';
import 'package:afalagi/core/widgets/input.dart';
import 'package:afalagi/features/property/models/property_model.dart';
import 'package:afalagi/features/property/property_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditPropertyScreen extends StatefulWidget {
  final Property property;

  const EditPropertyScreen({super.key, required this.property});

  @override
  State<EditPropertyScreen> createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _zipController;
  late final TextEditingController _bedroomsController;
  late final TextEditingController _bathroomsController;
  late final TextEditingController _sqmController;
  
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
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.property.title);
    _descriptionController = TextEditingController(text: widget.property.description);
    _priceController = TextEditingController(text: widget.property.price.toString());
    _addressController = TextEditingController(text: widget.property.location.split(',')[0]);
    _cityController = TextEditingController(text: widget.property.location.split(',').length > 1 ? widget.property.location.split(',')[1] : '');
    _zipController = TextEditingController(text: '');
    _bedroomsController = TextEditingController(text: widget.property.beds.toString());
    _bathroomsController = TextEditingController(text: widget.property.baths.toString());
    _sqmController = TextEditingController(text: widget.property.sqft.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _sqmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Edit Property',
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
                child: Stack(
                  children: [
                    Image.network(
                      widget.property.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
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
                    CustomTextField(
                      label: "Title", 
                      hintText: "e.g. Modern Villa in Bole",
                      controller: _titleController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: "Description", 
                      hintText: "Describe property...", 
                      maxLines: 3,
                      controller: _descriptionController,
                    ),

                    const SizedBox(height: 24),
                    _buildSectionHeader("Price Input Section"),
                    CustomTextField(
                      label: "Price", 
                      hintText: "e.g. 1500000", 
                      keyboardType: TextInputType.number, 
                      prefixText: " birr ",
                      controller: _priceController,
                    ),

                    const SizedBox(height: 24),
                    _buildSectionHeader("Location Details"),
                    CustomTextField(
                      label: "Address", 
                      hintText: "e.g. Churchill Ave",
                      controller: _addressController,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: "City", 
                            hintText: "e.g. Addis",
                            controller: _cityController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            label: "Zip Code", 
                            hintText: "e.g. 1000",
                            controller: _zipController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _buildSectionHeader("Rooms & Layout"),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: "Bedrooms", 
                            hintText: "3", 
                            keyboardType: TextInputType.number,
                            controller: _bedroomsController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            label: "Bathrooms", 
                            hintText: "2", 
                            keyboardType: TextInputType.number,
                            controller: _bathroomsController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            label: "SQM", 
                            hintText: "120", 
                            keyboardType: TextInputType.number,
                            controller: _sqmController,
                          ),
                        ),
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

                    const SizedBox(height: 40),
                    CustomButton(
                      text: "Update Property",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final updatedProperty = Property(
                            id: widget.property.id,
                            title: _titleController.text.trim(),
                            description: _descriptionController.text.trim(),
                            price: double.tryParse(_priceController.text) ?? 0,
                            location: "${_addressController.text.trim()}, ${_cityController.text.trim()}",
                            beds: int.tryParse(_bedroomsController.text) ?? 0,
                            baths: int.tryParse(_bathroomsController.text) ?? 0,
                            sqft: int.tryParse(_sqmController.text) ?? 0,
                            imageUrl: widget.property.imageUrl,
                          );
                          
                          PropertyService.updateProperty(updatedProperty);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Property updated successfully')),
                          );
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
