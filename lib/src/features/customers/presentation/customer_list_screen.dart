import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../customers/data/customer_repository.dart';
import '../../customers/domain/customer.dart';
import 'customer_detail_sheet.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  final String filter; // 'all', 'purchase', 'repair'

  const CustomerListScreen({super.key, this.filter = 'all'});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0; // 0: All, 1: 1W, 2: 3W, 3: 7W, 4: 1Y
  bool _isSanitizing = false; // Loading state logic

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _runDataSanitization() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('데이터 정리'),
        content: const Text('생년월일 자동 계산 및 불필요한 데이터를 정리하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('실행'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isSanitizing = true);

    try {
      final logs = await ref
          .read(customerRepositoryProvider)
          .sanitizeAndMigrateData();

      // Refresh list
      ref.invalidate(customersListProvider);

      if (mounted) {
        setState(() => _isSanitizing = false);

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('정리 완료'),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: logs.isEmpty
                  ? const Center(child: Text('변경사항이 없습니다.'))
                  : ListView.builder(
                      itemCount: logs.length,
                      itemBuilder: (context, index) => Text(
                        logs[index],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSanitizing = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _runMigration(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supabase 이관'),
        content: const Text(
          'Supabase로 데이터를 이관하시겠습니까?\n'
          '이 작업은 Firebase 데이터를 읽어서 Supabase에 저장을 시도합니다.\n'
          'Supabase 프로젝트 설정 및 API 키가 올바른지 확인해주세요.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('실행'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      await ref.read(customerRepositoryProvider).migrateToSupabase();

      if (context.mounted) {
        Navigator.pop(context); // Close loading
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('이관 완료'),
            content: const Text('데이터 이관 작업이 완료되었습니다.\n로그(console)를 확인해주세요.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Migration Error: $e')));
      }
    }
  }

  List<Customer> _filterCustomers(List<Customer> customers) {
    final query = _searchController.text.toLowerCase();
    final now = DateTime.now();

    return customers.where((customer) {
      // 0. Tab Filter (Purchase/Repair)
      if (widget.filter == 'purchase') {
        // Simple logic: Has hearing aid or bought something
        final hasHearingAid =
            customer.hearingAid != null && customer.hearingAid!.isNotEmpty;
        if (!hasHearingAid) return false;
      } else if (widget.filter == 'repair') {
        // Logic: has repairs in the new list
        final hasRepairs =
            customer.repairs != null && customer.repairs!.isNotEmpty;
        if (!hasRepairs) return false;
      }

      // 1. Text Search
      final matchesQuery =
          customer.name.toLowerCase().contains(query) ||
          (customer.mobilePhoneNumber ?? '').contains(query);

      if (!matchesQuery) return false;

      // 2. Date Filter
      if (_selectedFilterIndex == 0) return true;

      // Filter logic based on Legacy App:
      String? dateToUse = customer.registrationDate;

      // Helper to parse potential custom formats
      DateTime? parseDate(String? dateStr) {
        if (dateStr == null || dateStr.isEmpty) return null;
        // Normalize: 2023.05.05 -> 2023-05-05, 2023/05/05 -> 2023-05-05
        final normalized = dateStr.replaceAll('.', '-').replaceAll('/', '-');
        return DateTime.tryParse(normalized);
      }

      // Logic Update: Check Hearing Aid dates too.
      // If a customer bought a hearing aid recently, they should fall into the "1 Week" etc. buckets (Follow-up)
      if (customer.hearingAid != null && customer.hearingAid!.isNotEmpty) {
        // Collect all dates (registration + hearing aid dates)
        List<String> validDates = [];
        if (parseDate(dateToUse) != null) {
          validDates.add(dateToUse!);
        }
        for (final ha in customer.hearingAid!) {
          if (parseDate(ha.date) != null) {
            validDates.add(ha.date);
          }
        }

        // Find the most recent date
        validDates.sort((a, b) => parseDate(b)!.compareTo(parseDate(a)!));
        if (validDates.isNotEmpty) {
          dateToUse = validDates.first;
        }
        if (validDates.isNotEmpty) {
          dateToUse = validDates.first;
        }
      }

      // Logic Update: Check Repair dates too.
      if (customer.repairs != null && customer.repairs!.isNotEmpty) {
        // Collect all dates (registration + hearing aid + repair dates)
        List<String> validDates = [];
        if (parseDate(dateToUse) != null) {
          validDates.add(dateToUse!);
        }
        for (final repair in customer.repairs!) {
          if (parseDate(repair.date) != null) {
            validDates.add(repair.date);
          }
        }

        // Find the most recent date
        validDates.sort((a, b) => parseDate(b)!.compareTo(parseDate(a)!));
        if (validDates.isNotEmpty) {
          dateToUse = validDates.first;
        }
      }

      if (dateToUse == null || dateToUse.isEmpty)
        return _selectedFilterIndex == 0;

      final dateToCheck = parseDate(dateToUse);
      if (dateToCheck == null)
        return false; // Exclude invalid dates from specific filters

      final diff = now.difference(dateToCheck).inDays;

      switch (_selectedFilterIndex) {
        case 1: // 1 Week
          return diff >= 0 && diff <= 10; // Allow a bit of buffer
        case 2: // 3 Weeks
          return diff >= 14 && diff <= 28; // 2-4 weeks window
        case 3: // 7 Weeks
          return diff >= 42 && diff <= 56; // 6-8 weeks window
        case 4: // 1 Year
          return diff >= 335 && diff <= 395; // +/- 1 month
        case 5: // 2 Years
          return diff >= 700 && diff <= 760; // +/- 1 month
        case 6: // 5 Years
          return diff >= 1795 && diff <= 1855; // +/- 1 month
        default:
          return true;
      }
    }).toList();
  }

  String get _title {
    switch (widget.filter) {
      case 'purchase':
        return '고객 관리 (구매)';
      case 'repair':
        return '고객 관리 (수리)';
      default:
        return '고객 관리';
    }
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'cleanup') _runDataSanitization();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'cleanup',
                child: Text('데이터 정리 (Data Cleanup)'),
              ),
            ],
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
      body: Stack(
        children: [
          Column(
            children: [
              // Filter Chips
              if (widget.filter != 'repair')
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                      const SizedBox(width: 8),
                      _buildFilterChip(5, '2년'),
                      const SizedBox(width: 8),
                      _buildFilterChip(6, '5년'),
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
                      onRefresh: () =>
                          ref.refresh(customersListProvider.future),
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final customer = filtered[index];
                          return _CustomerListTile(customer: customer);
                        },
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('오류: $err')),
                ),
              ),
            ],
          ),
          if (_isSanitizing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
      floatingActionButton: _isSanitizing
          ? null
          : FloatingActionButton(
              heroTag: 'fab_${widget.filter}',
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
    final hasMobile =
        customer.mobilePhoneNumber != null &&
        customer.mobilePhoneNumber!.isNotEmpty;
    final hasPhone =
        customer.phoneNumber != null && customer.phoneNumber!.isNotEmpty;
    final hasAddress = customer.address != null && customer.address!.isNotEmpty;

    return ListTile(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) => CustomerDetailSheet(customer: customer),
        );
      },
      leading: null,
      title: Text(
        customer.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: (hasMobile || hasPhone || hasAddress)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasMobile)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.smartphone,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          customer.mobilePhoneNumber!,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                if (hasPhone)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.phone, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          customer.phoneNumber!,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                if (hasAddress)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.home, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            customer.address!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            )
          : null,
      isThreeLine: false, // Let the Column determine height naturally
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (customer.hearingAid != null) ...[
            if (customer.hearingAid!.any((h) => h.side.toLowerCase() == 'left'))
              const Icon(Icons.hearing, size: 20, color: Colors.blueGrey),
            if (customer.hearingAid!.any(
              (h) => h.side.toLowerCase() == 'right',
            ))
              Transform.flip(
                flipX: true,
                child: const Icon(
                  Icons.hearing,
                  size: 20,
                  color: Colors.blueGrey,
                ),
              ),
          ],
          if (customer.repairs != null && customer.repairs!.isNotEmpty) ...[
            const SizedBox(width: 4),
            const Icon(Icons.build, size: 16, color: Colors.orange),
          ],
        ],
      ),
    );
  }
}
