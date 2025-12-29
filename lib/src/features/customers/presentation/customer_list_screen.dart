import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../customers/data/customer_repository.dart';
import '../../customers/domain/customer.dart';
import '../../auth/data/auth_repository.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0; // 0: All, 1: 1W, 2: 3W, 3: 7W, 4: 1Y

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Customer> _filterCustomers(List<Customer> customers) {
    final query = _searchController.text.toLowerCase();
    final now = DateTime.now();

    return customers.where((customer) {
      // 1. Text Search
      final matchesQuery =
          customer.name.toLowerCase().contains(query) ||
          (customer.mobilePhoneNumber ?? '').contains(query);

      if (!matchesQuery) return false;

      // 2. Date Filter
      if (_selectedFilterIndex == 0) return true;

      // Filter logic based on Legacy App:
      // "1W", "3W", "7W" seem to imply customers who need checking or visited recently?
      // Assuming it filters by `updatedAt` or `joinDate` or maybe `hearingAidPurchaseDate`?
      // For now, let's filter by `updatedAt` within the timeframe.

      final registrationDate = customer.registrationDate;
      if (registrationDate == null || registrationDate.isEmpty)
        return _selectedFilterIndex == 0;

      final dateToCheck = DateTime.tryParse(registrationDate) ?? now;
      final diff = now.difference(dateToCheck).inDays;

      switch (_selectedFilterIndex) {
        case 1: // 1 Week
          return diff <= 7;
        case 2: // 3 Weeks
          return diff <= 21;
        case 3: // 7 Weeks
          return diff <= 49;
        case 4: // 1 Year
          return diff <= 365;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('고객 관리'), // Customer Manager
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('로그아웃'),
                  content: const Text('정말 로그아웃 하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('로그아웃'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await ref.read(authServiceProvider).signOut();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Settings
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '이름 또는 전화번호 검색', // Search Name or Phone
                prefixIcon: const Icon(Icons.search),
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip(0, '전체'),
                const SizedBox(width: 8),
                _buildFilterChip(1, '1주'),
                const SizedBox(width: 8),
                _buildFilterChip(2, '3주'),
                const SizedBox(width: 8),
                _buildFilterChip(3, '7주'),
                const SizedBox(width: 8),
                _buildFilterChip(4, '1년'),
              ],
            ),
          ),
          // Customer List
          Expanded(
            child: customersAsync.when(
              data: (customers) {
                final filtered = _filterCustomers(customers);

                if (filtered.isEmpty) {
                  return const Center(child: Text('검색 결과가 없습니다.'));
                }

                return RefreshIndicator(
                  onRefresh: () => ref.refresh(customersListProvider.future),
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final customer = filtered[index];
                      return _CustomerListTile(customer: customer);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('오류: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedFilterIndex == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedFilterIndex = index);
        }
      },
    );
  }
}

class _CustomerListTile extends StatelessWidget {
  final Customer customer;

  const _CustomerListTile({required this.customer});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.go('/edit/${customer.id}'),
      leading: CircleAvatar(
        child: Text(customer.name.isNotEmpty ? customer.name[0] : '?'),
      ),
      title: Text(
        customer.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${customer.address}\n${customer.mobilePhoneNumber}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            customer.registrationDate ?? '',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          // Hearing Aid Model if exists
          if (customer.hearingAid != null && customer.hearingAid!.isNotEmpty)
            const Icon(Icons.hearing, size: 16, color: Colors.blueGrey),
        ],
      ),
    );
  }
}
