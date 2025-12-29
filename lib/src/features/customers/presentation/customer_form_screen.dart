import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../customers/data/customer_repository.dart';
import '../../customers/domain/customer.dart';

class CustomerFormScreen extends ConsumerStatefulWidget {
  final String? customerId;

  const CustomerFormScreen({super.key, this.customerId});

  @override
  ConsumerState<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends ConsumerState<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _mobileController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  final _registrationDateController = TextEditingController();
  final _batteryOrderDateController = TextEditingController();

  // State
  String _sex = 'Male';
  String _cardAvailability = 'No';
  List<HearingAid> _hearingAids = [];

  @override
  void initState() {
    super.initState();
    _registrationDateController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());
    if (widget.customerId != null) {
      _loadCustomer();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    _registrationDateController.dispose();
    _batteryOrderDateController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomer() async {
    try {
      final List<Customer> customers = await ref.read(
        customersListProvider.future,
      );
      final customer = customers.firstWhere(
        (c) => c.id == widget.customerId,
        orElse: () => throw Exception('Customer not found'),
      );
      _populateForm(customer);
    } catch (e) {
      if (mounted) context.pop();
    }
  }

  void _populateForm(Customer c) {
    setState(() {
      _nameController.text = c.name;
      _ageController.text = c.age ?? '';
      _mobileController.text = c.mobilePhoneNumber ?? '';
      _phoneController.text = c.phoneNumber ?? '';
      _addressController.text = c.address ?? '';
      _noteController.text = c.note ?? '';
      _registrationDateController.text = c.registrationDate ?? '';
      _batteryOrderDateController.text = c.batteryOrderDate ?? '';

      _sex = c.sex ?? 'Male';
      _cardAvailability = c.cardAvailability ?? 'No';
      _hearingAids = List.from(c.hearingAid ?? []);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final customer = Customer(
        id: widget.customerId ?? '', // ID handled by repo push() if empty
        name: _nameController.text,
        age: _ageController.text,
        sex: _sex,
        mobilePhoneNumber: _mobileController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        cardAvailability: _cardAvailability,
        registrationDate: _registrationDateController.text,
        batteryOrderDate: _batteryOrderDateController.text.isEmpty
            ? null
            : _batteryOrderDateController.text,
        hearingAid: _hearingAids.isEmpty ? null : _hearingAids,
        note: _noteController.text,
      );

      final repo = ref.read(customerRepositoryProvider);
      if (widget.customerId != null) {
        await repo.updateCustomer(customer);
      } else {
        await repo.addCustomer(customer);
      }

      ref.invalidate(customersListProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _delete() async {
    if (widget.customerId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('삭제 확인'),
        content: const Text('정말로 삭제하시겠습니까?'), // Really delete?
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(customerRepositoryProvider)
          .deleteCustomer(widget.customerId!);
      ref.invalidate(customersListProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Delete Error: $e')));
      }
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customerId == null ? '새 고객' : '고객 정보 수정'),
        actions: [
          if (widget.customerId != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _isLoading ? null : _delete,
              color: Colors.red,
            ),
          IconButton(
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            onPressed: _isLoading ? null : _save,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('기본 정보 (Basic Info)'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: '이름 (Name)'),
                    validator: (v) => v!.isEmpty ? '이름을 입력하세요' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: '나이 (Age)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _sex,
                    decoration: const InputDecoration(labelText: '성별 (Sex)'),
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('남성 (Male)')),
                      DropdownMenuItem(
                        value: 'Female',
                        child: Text('여성 (Female)'),
                      ),
                    ],
                    onChanged: (val) => setState(() => _sex = val!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _cardAvailability,
                    decoration: const InputDecoration(
                      labelText: '복지카드 (Welfare)',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Yes', child: Text('있음 (Yes)')),
                      DropdownMenuItem(value: 'No', child: Text('없음 (No)')),
                    ],
                    onChanged: (val) =>
                        setState(() => _cardAvailability = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _mobileController,
              decoration: const InputDecoration(labelText: '핸드폰 (Mobile)'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: '자택 전화 (Phone)'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: '주소 (Address)'),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('보청기 정보 (Hearing Aid)'),
            const SizedBox(height: 8),
            ..._buildHearingAidList(),
            TextButton.icon(
              onPressed: () => setState(
                () => _hearingAids.add(
                  const HearingAid(side: 'left', model: '', date: ''),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('보청기 추가 (Add Hearing Aid)'),
            ),
            const SizedBox(height: 16),
            _buildDatePickerField(
              '배터리 주문일 (Battery Order)',
              _batteryOrderDateController,
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('기타 (Other)'),
            const SizedBox(height: 16),
            _buildDatePickerField(
              '가입일 (Join Date)',
              _registrationDateController,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: '메모 (Note)'),
              maxLines: 3,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  List<Widget> _buildHearingAidList() {
    return _hearingAids.asMap().entries.map((entry) {
      final index = entry.key;
      final aid = entry.value;
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  DropdownButton<String>(
                    value: aid.side,
                    items: const [
                      DropdownMenuItem(value: 'left', child: Text('좌 (L)')),
                      DropdownMenuItem(value: 'right', child: Text('우 (R)')),
                    ],
                    onChanged: (val) => setState(
                      () => _hearingAids[index] = aid.copyWith(side: val!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      initialValue: aid.model,
                      decoration: const InputDecoration(labelText: '모델명'),
                      onChanged: (val) => setState(
                        () => _hearingAids[index] = aid.copyWith(model: val),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () =>
                        setState(() => _hearingAids.removeAt(index)),
                  ),
                ],
              ),
              _buildDatePickerFieldInline(
                '구입일',
                aid.date,
                (val) => setState(
                  () => _hearingAids[index] = aid.copyWith(date: val),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(
            () => controller.text = DateFormat('yyyy-MM-dd').format(picked),
          );
        }
      },
      child: IgnorePointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerFieldInline(
    String label,
    String date,
    ValueChanged<String> onChanged,
  ) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.tryParse(date) ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onChanged(DateFormat('yyyy-MM-dd').format(picked));
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today, size: 16),
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
        ),
        child: Text(date.isEmpty ? '날짜 선택' : date),
      ),
    );
  }
}
