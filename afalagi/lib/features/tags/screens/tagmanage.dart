import 'package:flutter/material.dart';

class TagManagementScreen extends StatefulWidget {
  const TagManagementScreen({super.key});

  @override
  State<TagManagementScreen> createState() => _TagManagementScreenState();
}

class _TagManagementScreenState extends State<TagManagementScreen> {
  int _selectedColorIndex = 0;
  final _tagNameController = TextEditingController();
  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<Color> _colors = [
    const Color(0xFF0D5C63), // Dark Teal
    const Color(0xFF2E7D32), // Green
    const Color(0xFF6D4C41), // Brown
    const Color(0xFF00838F), // Cyan
    const Color(0xFFA5D6A7), // Light Green
  ];

  final List<Map<String, dynamic>> _tags = [
    {'name': 'Luxury', 'count': 124, 'color': const Color(0xFF0D5C63)},
    {'name': 'Villa', 'count': 85, 'color': const Color(0xFF2E7D32)},
    {'name': 'Bole', 'count': 312, 'color': const Color(0xFF6D4C41)},
    {'name': 'Under Construction', 'count': 42, 'color': const Color(0xFF00838F)},
  ];

  List<Map<String, dynamic>> _filteredTags = [];

  @override
  void initState() {
    super.initState();
    _filteredTags = _tags;
    _searchController.addListener(_filterTags);
  }

  @override
  void dispose() {
    _tagNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterTags() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTags = _tags.where((tag) {
        return tag['name'].toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B365D)),
          onPressed: () {},
        ),
        title: const Text('Tag Management', style: TextStyle(color: Color(0xFF1B365D), fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "Organize and curate your property portfolio labels for Ethiopia's elite market.",
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            const SizedBox(height: 24),
            
            // Search field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  hintText: 'Search tags...',
                ),
              ),
            ),

            const SizedBox(height: 24),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Create New Tag', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B365D))),
                    const SizedBox(height: 4),
                    const Text('DEFINE A BRAND CATEGORY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey)),
                    const SizedBox(height: 20),
                    
                    const Text('Tag Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E4E7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _tagNameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'e.g. Waterfront',
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    const Text('Category Color', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(
                      children: List.generate(_colors.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColorIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedColorIndex == index ? _colors[index] : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: _colors[index],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _tags.add({
                                'name': _tagNameController.text,
                                'count': 0,
                                'color': _colors[_selectedColorIndex],
                              });
                              _filterTags();
                            });
                            _tagNameController.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B365D),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        child: const Text('Create Tag', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            const Text('Active Tags', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B365D))),
            const SizedBox(height: 16),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredTags.length,
              itemBuilder: (context, index) {
                final tag = _filteredTags[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(width: 4, height: 30, color: tag['color'] as Color),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tag['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('${tag['count']} PROPERTIES', style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          final editController = TextEditingController(text: tag['name']);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Edit Tag'),
                              content: TextField(
                                controller: editController,
                                decoration: const InputDecoration(labelText: 'Tag Name'),
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      final actualIndex = _tags.indexOf(tag);
                                      if (actualIndex != -1) {
                                        _tags[actualIndex]['name'] = editController.text;
                                        _filterTags();
                                      }
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _tags.remove(tag);
                            _filterTags();
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}