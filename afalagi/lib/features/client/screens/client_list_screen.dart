import 'package:flutter/material.dart';
import 'package:afalagi/core/theme/theme.dart';
import 'package:afalagi/core/widgets/button.dart';
import 'package:afalagi/core/widgets/image.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  
  String _searchQuery = '';
  String _selectedPriority = 'MODERATE';
  int _selectedInterest = 3;
  int? _expandedIndex;

  final List<Map<String, dynamic>> _clients = [
    {
      'id': 'c1',
      'name': 'Dawit Mengistu',
      'phone': '+251 91 123 4567',
      'priority': 'VIP',
      'interest': 5,
      'area': 'Bole, Penthouse',
      'budget': '45M – 60M ETB',
      'image': 'assets/images/client_avatar_1.png'
    },
    {
      'id': 'c2',
      'name': 'Sara Haile',
      'phone': '+251 92 887 6654',
      'priority': 'MODERATE',
      'interest': 3,
      'image': 'assets/images/generic_avatar.png'
    },
    {
      'id': 'c3',
      'name': 'Abebe Yosef',
      'phone': '+251 94 332 1198',
      'priority': 'HIGH',
      'interest': 4,
      'image': 'assets/images/generic_avatar.png'
    },
    {
      'id': 'c4',
      'name': 'Martha Tadesse',
      'phone': '+251 91 554 3321',
      'priority': 'MODERATE',
      'interest': 2,
      'image': 'assets/images/generic_avatar.png'
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _areaController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredClients {
    if (_searchQuery.isEmpty) return _clients;
    return _clients.where((c) => 
      c['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
      (c['area']?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
    ).toList();
  }

  void _showClientDialog({Map<String, dynamic>? client, int? index}) {
    if (client != null) {
      _nameController.text = client['name'];
      _phoneController.text = client['phone'];
      _areaController.text = client['area'] ?? '';
      _budgetController.text = client['budget'] ?? '';
      _selectedPriority = client['priority'];
      _selectedInterest = client['interest'] ?? 3;
    } else {
      _nameController.clear();
      _phoneController.clear();
      _areaController.clear();
      _budgetController.clear();
      _selectedPriority = 'MODERATE';
      _selectedInterest = 3;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            client == null ? 'New Acquisition' : 'Edit Client',
            style: TextStyle(
                color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Upload Placeholder
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Placeholder for Image Picker logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Image picker will open here')),
                      );
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F4F9),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.grey[300]!, width: 2),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, color: Colors.grey, size: 30),
                          SizedBox(height: 4),
                          Text(
                            "ADD PHOTO",
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildPopupLabel("CLIENT NAME"),
                TextField(
                    controller: _nameController,
                    decoration:
                        _buildPopupInputDecoration('e.g. Dawit Mengistu')),
                const SizedBox(height: 16),
                _buildPopupLabel("PHONE NUMBER"),
                TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration:
                        _buildPopupInputDecoration('e.g. +251 9...')),
                const SizedBox(height: 16),
                _buildPopupLabel("TARGET AREA"),
                TextField(
                    controller: _areaController,
                    decoration:
                        _buildPopupInputDecoration('e.g. Bole, Penthouse')),
                const SizedBox(height: 16),
                _buildPopupLabel("BUDGET SCALE"),
                TextField(
                    controller: _budgetController,
                    decoration:
                        _buildPopupInputDecoration('e.g. 45M – 60M ETB')),
                const SizedBox(height: 16),
                _buildPopupLabel("INTEREST LEVEL"),
                Row(
                  children: List.generate(5, (i) {
                    return IconButton(
                      onPressed: () =>
                          setDialogState(() => _selectedInterest = i + 1),
                      icon: Icon(
                        i < _selectedInterest ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                _buildPopupLabel("PRIORITY STATUS"),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedPriority,
                      isExpanded: true,
                      items: ['VIP', 'HIGH', 'MODERATE', 'LOW']
                          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                          .toList(),
                      onChanged: (val) =>
                          setDialogState(() => _selectedPriority = val!),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      setState(() {
                        final newClient = {
                          'id': client?['id'] ?? DateTime.now().toString(),
                          'name': _nameController.text,
                          'phone': _phoneController.text,
                          'priority': _selectedPriority,
                          'interest': _selectedInterest,
                          'image': 'assets/images/generic_avatar.png',
                          'area': _areaController.text.isEmpty
                              ? 'N/A'
                              : _areaController.text,
                          'budget': _budgetController.text.isEmpty
                              ? 'N/A'
                              : _budgetController.text,
                        };
                        if (index != null) {
                          _clients[index] = newClient;
                        } else {
                          _clients.insert(0, newClient);
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Save Client',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[400],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  InputDecoration _buildPopupInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF1F4F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  void _deleteClient(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Client'),
        content: const Text('Remove this client from your portfolio?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _clients.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              _buildSearchBar(),
              const SizedBox(height: 15),
              CustomButton(
                onPressed: () => _showClientDialog(),
                text: 'New Acquisition',
                icon: Icons.add,
              ),
              const SizedBox(height: 25),
              ..._filteredClients.asMap().entries.map((entry) {
                final client = entry.value;
                final index = _clients.indexOf(client);
                return client['priority'] == 'VIP'
                    ? Column(children: [
                        _buildFeaturedCard(context, client, index),
                        const SizedBox(height: 16)
                      ])
                    : _buildClientCard(context, client, index);
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFEDF1F5), borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: const InputDecoration(
          hintText: 'Search by name, property type...',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, Map<String, dynamic> client, int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 10))
          ]),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
              top: -20,
              right: -20,
              child: CircleAvatar(
                  radius: 60, backgroundColor: const Color(0xFFF1F4F9))),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CustomImages.resilientImage(
                          client['image'] ?? 'assets/images/generic_avatar.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildPriorityBadge(client['priority']),
                              _buildClientMenu(client, index),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(client['name'],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor)),
                          Text(client['phone'],
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        children: List.generate(
                            5,
                            (i) => Icon(
                                i < (client['interest'] ?? 0)
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20))),
                  ],
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _buildInfoBox('TARGET AREA', client['area'])),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInfoBox('BUDGET SCALE', client['budget']))
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard(
      BuildContext context, Map<String, dynamic> client, int index) {
    bool isExpanded = _expandedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedIndex = isExpanded ? null : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ]),
        child: Column(
          children: [
            Row(
              children: [
                ClipOval(
                    child: CustomImages.resilientImage(
                        client['image'] ?? 'assets/images/generic_avatar.png',
                        width: 48,
                        height: 48)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(client['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(client['phone'],
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12)),
                      ]),
                ),
                _buildClientMenu(client, index),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: _buildInfoBox(
                          'TARGET AREA', client['area'] ?? 'N/A')),
                  const SizedBox(width: 8),
                  Expanded(
                      child: _buildInfoBox('BUDGET', client['budget'] ?? 'N/A')),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        children: List.generate(
                            5,
                            (i) => Icon(
                                i < (client['interest'] ?? 0)
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 16))),
                    Text(client['priority'],
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      children: List.generate(
                          5,
                          (i) => Icon(
                              i < (client['interest'] ?? 0)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16))),
                  Text(client['priority'],
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: const Color(0xFFD1FAE5),
          borderRadius: BorderRadius.circular(8)),
      child: Text(priority,
          style: const TextStyle(
              color: Color(0xFF065F46),
              fontSize: 10,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoBox(String title, String? value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xFFF1F4F9),
          borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(
                fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value ?? 'N/A',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor)),
      ]),
    );
  }

  Widget _buildClientMenu(Map<String, dynamic> client, int index) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
      onSelected: (val) {
        if (val == 'edit') _showClientDialog(client: client, index: index);
        if (val == 'delete') _deleteClient(index);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit', 
          child: Row(children: [Icon(Icons.edit, size: 18), 
          SizedBox(width: 8), 
          Text('Edit')
          ])),
        const PopupMenuItem(
          value: 'delete', 
          child: Row(children: [Icon(Icons.delete, size: 18, color: Colors.red), 
          SizedBox(width: 8), 
          Text('Delete', style: TextStyle(color: Colors.red))])),
      ],
    );
  }
}