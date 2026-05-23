import 'package:afalagi/Core/theme/theme.dart';
import 'package:afalagi/Core/widgets/afalagi_dialog.dart';
import 'package:afalagi/Core/widgets/button.dart';
import 'package:afalagi/Core/widgets/image.dart';
import 'package:afalagi/features/client/domain/entities/client_entity.dart';
import 'package:afalagi/features/client/providers/client_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ClientListScreen extends ConsumerStatefulWidget {
  const ClientListScreen({super.key});

  @override
  ConsumerState<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends ConsumerState<ClientListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  String _searchQuery = '';
  String _selectedPriority = 'MODERATE';
  int _selectedInterest = 3;
  int? _expandedIndex;

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _areaController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  List<ClientEntity> _filterClients(List<ClientEntity> clients) {
    if (_searchQuery.isEmpty) return clients;
    return clients
        .where(
          (c) =>
              c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              c.area.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  void _showClientDialog({ClientEntity? client}) {
    if (client != null) {
      _nameController.text = client.name;
      _phoneController.text = client.phone;
      _areaController.text = client.area;
      _budgetController.text = client.budget;
      _selectedPriority = client.priority;
      _selectedInterest = client.interest;
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
          shape: AppTheme.compactDialogShape,
          title: Text(
            client == null ? 'New Acquisition' : 'Edit Client',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPopupLabel('CLIENT NAME'),
                TextField(
                  controller: _nameController,
                  decoration: _buildPopupInputDecoration('e.g. Dawit Mengistu'),
                ),
                const SizedBox(height: 16),
                _buildPopupLabel('PHONE NUMBER'),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _buildPopupInputDecoration('e.g. +251 9...'),
                ),
                const SizedBox(height: 16),
                _buildPopupLabel('TARGET AREA'),
                TextField(
                  controller: _areaController,
                  decoration:
                      _buildPopupInputDecoration('e.g. Bole, Penthouse'),
                ),
                const SizedBox(height: 16),
                _buildPopupLabel('BUDGET SCALE'),
                TextField(
                  controller: _budgetController,
                  decoration:
                      _buildPopupInputDecoration('e.g. 45M – 60M ETB'),
                ),
                const SizedBox(height: 16),
                _buildPopupLabel('PRIORITY STATUS'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedPriority,
                      isExpanded: true,
                      items: ['VIP', 'HIGH', 'MODERATE', 'LOW']
                          .map(
                            (p) => DropdownMenuItem(value: p, child: Text(p)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setDialogState(() => _selectedPriority = val!),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildPopupLabel('INTEREST LEVEL'),
                Row(
                  children: List.generate(5, (i) {
                    return IconButton(
                      onPressed: () =>
                          setDialogState(() => _selectedInterest = i + 1),
                      icon: Icon(
                        i < _selectedInterest
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                      ),
                    );
                  }),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      Navigator.pop(context);

                      final entity = ClientEntity(
                        id: client?.id ?? '',
                        name: _nameController.text.trim(),
                        phone: _phoneController.text.trim(),
                        priority: _selectedPriority,
                        interest: _selectedInterest,
                        area: _areaController.text.trim().isEmpty
                            ? 'N/A'
                            : _areaController.text.trim(),
                        budget: _budgetController.text.trim().isEmpty
                            ? 'N/A'
                            : _budgetController.text.trim(),
                        image: client?.image ??
                            'assets/images/generic_avatar.png',
                      );

                      try {
                        if (client == null) {
                          await ref
                              .read(clientListProvider.notifier)
                              .addClient(entity);
                        } else {
                          await ref
                              .read(clientListProvider.notifier)
                              .updateClient(client.id, entity);
                        }
                      } catch (e) {
                        messenger.showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                    child: const Text(
                      'Save Client',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
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
      fillColor: AppColors.inputBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Future<void> _deleteClient(ClientEntity client) async {
    final confirmed = await AfalagiDialog.showConfirm(
      context,
      title: 'Delete Client',
      content: 'Remove this client from your portfolio?',
    );
    if (confirmed != true || !mounted) return;

    try {
      await ref.read(clientListProvider.notifier).deleteClient(client.id);
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
    final clientsAsync = ref.watch(clientListProvider);

    return clientsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(clientListProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (clients) {
        final filtered = _filterClients(clients);

        return RefreshIndicator(
          onRefresh: () => ref.read(clientListProvider.notifier).refresh(),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 15),
                    CustomButton(
                      onPressed: () => _showClientDialog(),
                      text: 'New Acquisition',
                      icon: Icons.add,
                    ),
                    const SizedBox(height: 25),
                    if (filtered.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Text(
                            'No clients yet. Add your first acquisition.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ...filtered.asMap().entries.map((entry) {
                        final client = entry.value;
                        final index = clients.indexOf(client);
                        return client.priority == 'VIP'
                            ? Column(
                                children: [
                                  _buildFeaturedCard(context, client, index),
                                  const SizedBox(height: 16),
                                ],
                              )
                            : _buildClientCard(context, client, index);
                      }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(15),
      ),
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

  Widget _buildFeaturedCard(
    BuildContext context,
    ClientEntity client,
    int index,
  ) {
    return GestureDetector(
      onTap: () => context.push('/client-detail', extra: client),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.inputBackground,
              ),
            ),
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
                          client.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildPriorityBadge(client.priority),
                                _buildClientMenu(client),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              client.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            Text(
                              client.phone,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < client.interest
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoBox('TARGET AREA', client.area),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoBox('BUDGET SCALE', client.budget),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientCard(
    BuildContext context,
    ClientEntity client,
    int index,
  ) {
    final isExpanded = _expandedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedIndex = isExpanded ? null : index;
        });
      },
      onLongPress: () => context.push('/client-detail', extra: client),
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
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipOval(
                  child: CustomImages.resilientImage(
                    client.image,
                    width: 48,
                    height: 48,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        client.phone,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                _buildClientMenu(client),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildInfoBox('TARGET AREA', client.area)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildInfoBox('BUDGET', client.budget)),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < client.interest
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ),
                    Text(
                      client.priority,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.push('/client-detail', extra: client),
                child: const Text('View details'),
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
                        i < client.interest
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                  ),
                  Text(
                    client.priority,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priority,
        style: const TextStyle(
          color: AppColors.success,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String? value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 9,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value ?? 'N/A',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientMenu(ClientEntity client) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
      onSelected: (val) {
        if (val == 'edit') _showClientDialog(client: client);
        if (val == 'delete') _deleteClient(client);
        if (val == 'view') context.push('/client-detail', extra: client);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(Icons.visibility, size: 18),
              SizedBox(width: 8),
              Text('View'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: AppColors.danger),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: AppColors.danger)),
            ],
          ),
        ),
      ],
    );
  }
}
