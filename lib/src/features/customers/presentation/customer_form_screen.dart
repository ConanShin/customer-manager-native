import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../customers/data/customer_repository.dart';
import '../../customers/domain/customer.dart';
import 'customer_avatar.dart';

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
  // final _ageController = TextEditingController(); // Removed
  final _birthDateController = TextEditingController(); // Added
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
  File? _selectedImage;
  final _picker = ImagePicker();

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
    // _ageController.dispose();
    _birthDateController.dispose();
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
      // _ageController.text = c.age ?? '';
      _birthDateController.text = c.birthDate ?? '';
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

  String _calculateAge(String? birthDateString) {
    if (birthDateString == null || birthDateString.isEmpty) return '';
    final birthDate = DateTime.tryParse(birthDateString);
    if (birthDate == null) return '';
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(customerRepositoryProvider);
      final customerId = widget.customerId ?? const Uuid().v4();

      final customer = Customer(
        id: customerId,
        name: _nameController.text,
        age: _calculateAge(_birthDateController.text),
        birthDate: _birthDateController.text.isEmpty
            ? null
            : _birthDateController.text,
        sex: _sex,
        mobilePhoneNumber: _mobileController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        cardAvailability: _cardAvailability,
        registrationDate: _registrationDateController.text.isEmpty
            ? null
            : _registrationDateController.text,
        batteryOrderDate: _batteryOrderDateController.text.isEmpty
            ? null
            : _batteryOrderDateController.text,
        hearingAid: _hearingAids.isEmpty
            ? null
            : _hearingAids
                  .map(
                    (ha) => ha.copyWith(
                      date: (ha.date == null || ha.date!.isEmpty)
                          ? null
                          : ha.date,
                    ),
                  )
                  .toList(),
        note: _noteController.text,
      );

      if (widget.customerId != null) {
        await repo.updateCustomer(customer);
      } else {
        await repo.addCustomer(customer);
      }

      if (_selectedImage != null) {
        await repo.uploadProfilePicture(customerId, _selectedImage!);
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
        content: const Text('정말로 삭제하시겠습니까?'),
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.customerId == null ? '새 고객 등록' : '고객 정보 수정',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (widget.customerId != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _isLoading ? null : _delete,
              color: Colors.red,
            ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: _isLoading ? null : _save,
              child: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      '저장',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildImageSection(),
            const SizedBox(height: 20),
            _buildBasicSection(),
            const SizedBox(height: 20),
            _buildContactSection(),
            const SizedBox(height: 20),
            _buildHearingAidSection(),
            const SizedBox(height: 20),
            _buildEtcSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Center(
      child: Stack(
        children: [
          CustomerAvatar(
            customer: widget.customerId != null
                ? ref
                      .watch(customersListProvider)
                      .when(
                        data: (list) => list.firstWhere(
                          (c) => c.id == widget.customerId,
                          orElse: () => Customer.empty(),
                        ),
                        loading: () => Customer.empty(),
                        error: (_, __) => Customer.empty(),
                      )
                : Customer.empty().copyWith(name: _nameController.text),
            radius: 60,
            fontSize: 48,
            imageFile: _selectedImage,
          ),
          if (_isLoading)
            Positioned.fill(
              child: ClipOval(
                child: Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 4,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 18,
              child: IconButton(
                icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                onPressed: _isLoading ? null : _pickImage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 1. Basic Info ---
  Widget _buildBasicSection() {
    return _buildSectionCard(
      title: '기본 정보',
      children: [
        TextFormField(
          controller: _nameController,
          decoration: _inputDecoration('이름'),
          validator: (v) => v!.isEmpty ? '이름을 입력하세요' : null,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildDatePickerField(
                '생년월일',
                _birthDateController,
                icon: Icons.cake,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '성별',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Male', label: Text('남성')),
                      ButtonSegment(value: 'Female', label: Text('여성')),
                    ],
                    selected: {_sex},
                    onSelectionChanged: (v) => setState(() => _sex = v.first),
                    showSelectedIcon: false,
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- 2. Contact ---
  Widget _buildContactSection() {
    return _buildSectionCard(
      title: '연락처',
      children: [
        TextFormField(
          controller: _mobileController,
          decoration: _inputDecoration('휴대전화', icon: Icons.smartphone),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: _inputDecoration('유선전화', icon: Icons.phone),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: _inputDecoration('주소', icon: Icons.home),
        ),
      ],
    );
  }

  // --- 3. Hearing Aid ---
  Widget _buildHearingAidSection() {
    return _buildSectionCard(
      title: '보청기 정보',
      children: [
        if (_hearingAids.isEmpty)
          const Center(
            child: Text('등록된 보청기가 없습니다.', style: TextStyle(color: Colors.grey)),
          )
        else
          ..._hearingAids.asMap().entries.map((entry) {
            final index = entry.key;
            final aid = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      DropdownButton<String>(
                        value: aid.side,
                        underline: Container(),
                        items: const [
                          DropdownMenuItem(
                            value: 'left',
                            child: Text(
                              '좌 (L)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'right',
                            child: Text(
                              '우 (R)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        onChanged: (val) => setState(
                          () => _hearingAids[index] = aid.copyWith(side: val!),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: aid.model,
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: '모델명',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          onChanged: (val) => setState(
                            () =>
                                _hearingAids[index] = aid.copyWith(model: val),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                        ),
                        onPressed: () =>
                            setState(() => _hearingAids.removeAt(index)),
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  _buildDatePickerInline(
                    date: aid.date,
                    onChanged: (val) => setState(
                      () => _hearingAids[index] = aid.copyWith(date: val),
                    ),
                  ),
                ],
              ),
            );
          }),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => setState(
            () => _hearingAids.add(
              HearingAid(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                side: 'left',
                model: '',
                date: '',
              ),
            ),
          ),
          icon: const Icon(Icons.add),
          label: const Text('보청기 추가'),
        ),
        const SizedBox(height: 16),
        _buildDatePickerField(
          '배터리 주문일',
          _batteryOrderDateController,
          icon: Icons.battery_charging_full,
        ),
      ],
    );
  }

  // --- 4. Etc ---
  Widget _buildEtcSection() {
    return _buildSectionCard(
      title: '기타 정보',
      children: [
        _buildDatePickerField(
          '가입일',
          _registrationDateController,
          icon: Icons.calendar_today,
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '복지카드 여부',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'Yes',
                  label: Text('있음'),
                  icon: Icon(Icons.check_circle_outline),
                ),
                ButtonSegment(
                  value: 'No',
                  label: Text('없음'),
                  icon: Icon(Icons.cancel_outlined),
                ),
              ],
              selected: {_cardAvailability},
              onSelectionChanged: (v) =>
                  setState(() => _cardAvailability = v.first),
              showSelectedIcon: false,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _noteController,
          decoration: _inputDecoration('메모', icon: Icons.note),
          maxLines: 4,
        ),
      ],
    );
  }

  // --- Helpers ---

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
    );
  }

  Widget _buildDatePickerField(
    String label,
    TextEditingController controller, {
    IconData? icon,
  }) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          locale: const Locale('ko', 'KR'),
        );
        if (picked != null) {
          setState(
            () => controller.text = DateFormat('yyyy-MM-dd').format(picked),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: IgnorePointer(
        child: TextFormField(
          controller: controller,
          decoration: _inputDecoration(
            label,
            icon: icon ?? Icons.calendar_today,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerInline({
    required String? date,
    required ValueChanged<String> onChanged,
  }) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.tryParse(date ?? '') ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          locale: const Locale('ko', 'KR'),
        );
        if (picked != null) {
          onChanged(DateFormat('yyyy-MM-dd').format(picked));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              date == null || date.isEmpty ? '구입일 선택' : date,
              style: TextStyle(
                color: (date == null || date.isEmpty)
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
