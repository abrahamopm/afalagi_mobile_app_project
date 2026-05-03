import 'package:flutter/material.dart';

class ClientManagementScreen extends StatefulWidget {
  const ClientManagementScreen({Key? key}) : super(key: key);

  @override
  State<ClientManagementScreen> createState() => _ClientManagementScreenState();
}

class _ClientManagementScreenState extends State<ClientManagementScreen> {
  final List<Map<String, dynamic>> _clients = [
    {
      'initials': 'DM',
      'name': 'Dawit Mengistu',
      'phone': '+251 91 123 4567',
      'rating': 5.0,
      'level': 'VIP PRIORITY',
      'isVIP': true,
      'targetArea': 'Bole, Penthouse',
      'budget': '45M - 60M ETB'
    },
    {
      'initials': 'SH',
      'name': 'Sara Haile',
      'phone': '+251 92 887 6654',
      'rating': 3.5,
      'level': 'MODERATE'
    },
    {
      'initials': 'AY',
      'name': 'Abebe Yosef',
      'phone': '+251 94 332 1198',
      'rating': 4.0,
      'level': 'HIGH'
    },
    {
      'initials': 'MT',
      'name': 'Martha Tadesse',
      'phone': '+251 91 554 3321',
      'rating': 0.0,
      'level': ''
    },
  ];


  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredClients = [];

  @override
  void initState() {
    super.initState();
    _filteredClients = _clients;
    _searchController.addListener(_filterClients);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterClients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredClients = _clients.where((client) {
        return client['name'].toLowerCase().contains(query) ||
            client['phone'].toLowerCase().contains(query);
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
        title: Row(
          children: [
            Icon(Icons.home_work_outlined, color: Color(0xFF1E566E), size: 28),
            const SizedBox(width: 8),
            Text('Afalagi', style: TextStyle(color: Color(0xFF1E566E), fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Search bar
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search by name, phone number...',
                        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // New Acquisition Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final formKey = GlobalKey<FormState>();
                  final nameController = TextEditingController();
                  final phoneController = TextEditingController();
                  final interestController = TextEditingController();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('New Acquisition'),
                        content: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: nameController,
                                decoration: const InputDecoration(labelText: 'Client Name'),
                                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                              ),
                              TextFormField(
                                controller: phoneController,
                                decoration: const InputDecoration(labelText: 'Contact Number'),
                                validator: (value) => value == null || value.length < 9 ? 'Enter a valid phone number' : null,
                              ),
                              TextFormField(
                                controller: interestController,
                                decoration: const InputDecoration(labelText: 'Property Interest'),
                                validator: (value) => value == null || value.isEmpty ? 'Please enter interest' : null,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  _clients.add({
                                    'initials': nameController.text.isNotEmpty ? nameController.text[0].toUpperCase() : 'NA',
                                    'name': nameController.text,
                                    'phone': phoneController.text,
                                    'rating': 0.0,
                                    'level': 'NEW'
                                  });
                                  _filterClients();
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Client added successfully!')),
                                );
                              }
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B365D),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 5,
                  shadowColor: Colors.black45,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text('New Acquisition', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Client List Items
            ..._filteredClients.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> client = entry.value;
              
              if (client['isVIP'] == true) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildVIPCard(context, index, client),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildClientItem(
                  context,
                  index,
                  client['initials'],
                  client['name'],
                  client['phone'],
                  client['rating'],
                  client['level'],
                ),
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF1B365D),
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // Clients tab selected
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.business_outlined), label: 'PROPERTIES'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt), label: 'CLIENTS'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'VIEWINGS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'PROFILE'),
        ],
      ),
    );
  }

  Widget _buildVIPCard(BuildContext context, int index, Map<String, dynamic> client) {
    return GestureDetector(
      onTap: () {
        final formKey = GlobalKey<FormState>();
        final nameController = TextEditingController(text: client['name']);
        final phoneController = TextEditingController(text: client['phone']);
        final targetAreaController = TextEditingController(text: client['targetArea'] ?? '');
        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Edit VIP Client: ${client['name']}'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) => value == null || value.isEmpty ? 'Name required' : null,
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      validator: (value) => value == null ? 'Phone required' : null,
                    ),
                    TextFormField(
                      controller: targetAreaController,
                      decoration: const InputDecoration(labelText: 'Target Area'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete VIP Client'),
                        content: Text('Are you sure you want to remove ${client['name']}?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () {
                              setState(() {
                                _clients.removeWhere((c) => c['name'] == client['name'] && c['phone'] == client['phone']);
                                _filterClients();
                              });
                              Navigator.pop(context); // Close confirm
                              Navigator.pop(context); // Close edit
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('VIP Client removed')));
                            },
                            child: const Text('Delete', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        final actualIndex = _clients.indexWhere((c) => c['name'] == client['name'] && c['phone'] == client['phone']);
                        if (actualIndex != -1) {
                          _clients[actualIndex]['name'] = nameController.text;
                          _clients[actualIndex]['phone'] = phoneController.text;
                          _clients[actualIndex]['targetArea'] = targetAreaController.text;
                          _filterClients();
                        }
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('VIP Client updated')));
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Avatar placeholder
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Decorative circle
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4F8),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(80),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA5D6A7), // Light green
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(client['level'], style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          starIndex < client['rating'].floor() ? Icons.star : Icons.star_border,
                          color: const Color(0xFF6D4C41),
                          size: 14,
                        );
                      }),
                    ),
                    const Text('INTEREST LEVEL', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            Text(client['name'].replaceAll(' ', '\n'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B365D), height: 1.2)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(client['phone'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TARGET AREA', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.1)),
                        const SizedBox(height: 4),
                        Text(client['targetArea'] ?? 'Not set', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B365D))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BUDGET SCALE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.1)),
                        const SizedBox(height: 4),
                        Text(client['budget'] ?? 'Not set', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B365D))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientItem(BuildContext context, int index, String initials, String name, String phone, double rating, String level) {
    return GestureDetector(
      onTap: () {
        final formKey = GlobalKey<FormState>();
        final nameController = TextEditingController(text: name);
        final phoneController = TextEditingController(text: phone);
        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Edit Client: $name'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) => value == null || value.isEmpty ? 'Name required' : null,
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      validator: (value) => value == null || value.length < 9 ? 'Valid phone required' : null,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      final clientToRemove = _filteredClients[index];
                      _clients.removeWhere((c) => c['name'] == clientToRemove['name'] && c['phone'] == clientToRemove['phone']);
                      _filterClients();
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$name deleted successfully!')),
                    );
                  },
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        final clientToUpdate = _filteredClients[index];
                        final actualIndex = _clients.indexWhere((c) => c['name'] == clientToUpdate['name'] && c['phone'] == clientToUpdate['phone']);
                        if (actualIndex != -1) {
                          _clients[actualIndex]['name'] = nameController.text;
                          _clients[actualIndex]['phone'] = phoneController.text;
                          _filterClients();
                        }
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${nameController.text} updated successfully!')),
                      );
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                    ),
                    child: Center(
                      child: Text(initials, style: TextStyle(color: Color(0xFF1B365D), fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B365D))),
                    const SizedBox(height: 4),
                    Text(phone, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      if (index < rating.floor()) {
                        return const Icon(Icons.star, color: Color(0xFF6D4C41), size: 16);
                      } else if (index < rating) {
                        return const Icon(Icons.star_half, color: Color(0xFF6D4C41), size: 16);
                      } else {
                        return const Icon(Icons.star_border, color: Color(0xFF6D4C41), size: 16);
                      }
                    }),
                  ),
                  Text(level, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
