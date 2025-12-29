import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../customers/data/customer_repository.dart';
import '../../customers/domain/customer.dart';

enum EditSection { none, basic, contact, hearingAid, note, etc }

class CustomerDetailSheet extends ConsumerStatefulWidget {
  final Customer customer;

  const CustomerDetailSheet({super.key, required this.customer});

  @override
  ConsumerState<CustomerDetailSheet> createState() =>
      _CustomerDetailSheetState();
}

class _CustomerDetailSheetState extends ConsumerState<CustomerDetailSheet> {
  late Customer _customer;
  EditSection _editingSection = EditSection.none;
  bool _isLoading = false;

  // Controllers (Initialized on demand or keep all? Keeping all is easier for state preservation)
  final _nameController = TextEditingController();
  // final _ageController = TextEditingController(); // Removed
  final _birthDateController = TextEditingController(); // Added
  final _mobileController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  final _registrationDateController = TextEditingController();
  final _batteryOrderDateController = TextEditingController();

  // Temporary State for Edit
  String _sex = 'Male';
  String _cardAvailability = 'No';
  // For Hearing Aid, we might need a more complex controller or just a list copy
  List<HearingAid> _tempHearingAids = [];

  @override
  void initState() {
    super.initState();
    _customer = widget.customer;
    _resetControllers();
  }

  void _resetControllers() {
    _nameController.text = _customer.name;
    // _ageController.text = _customer.age ?? '';
    _birthDateController.text = _customer.birthDate ?? ''; // Load birthDate
    _mobileController.text = _customer.mobilePhoneNumber ?? '';
    _phoneController.text = _customer.phoneNumber ?? '';
    _addressController.text = _customer.address ?? '';
    _noteController.text = _customer.note ?? '';
    _registrationDateController.text = _customer.registrationDate ?? '';
    _batteryOrderDateController.text = _customer.batteryOrderDate ?? '';

    _sex = _customer.sex ?? 'Male';
    _cardAvailability = _customer.cardAvailability ?? 'No';
    _tempHearingAids = List.from(_customer.hearingAid ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    // _ageController.dispose();
    _birthDateController.dispose(); // Dispose
    _mobileController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    _registrationDateController.dispose();
    _batteryOrderDateController.dispose();
    super.dispose();
  }

  void _startEditing(EditSection section) {
    setState(() {
      _editingSection = section;
      _resetControllers(); // Ensure controllers are fresh from current customer state
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingSection = EditSection.none;
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

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      // Build updated customer
      final updatedCustomer = _customer.copyWith(
        name: _nameController.text,
        age: _calculateAge(_birthDateController.text),
        birthDate: _birthDateController.text,
        sex: _sex,
        mobilePhoneNumber: _mobileController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        cardAvailability: _cardAvailability,
        registrationDate: _registrationDateController.text,
        batteryOrderDate: _batteryOrderDateController.text.isEmpty
            ? null
            : _batteryOrderDateController.text,
        hearingAid: _tempHearingAids.isEmpty ? null : _tempHearingAids,
        note: _noteController.text,
      );

      await ref
          .read(customerRepositoryProvider)
          .updateCustomer(updatedCustomer);
      ref.invalidate(customersListProvider);

      setState(() {
        _customer = updatedCustomer;
        _editingSection = EditSection.none;
      });
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _delete() async {
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

    if (confirm == true) {
      if (mounted) setState(() => _isLoading = true);
      try {
        await ref.read(customerRepositoryProvider).deleteCustomer(_customer.id);
        ref.invalidate(customersListProvider);
        if (mounted) Navigator.pop(context); // Close sheet
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('고객 상세'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') _delete();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text('고객 삭제', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBasicSection(),
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 32),
            _buildContactSection(),
            const SizedBox(height: 16),
            _buildHearingAidSection(),
            const SizedBox(height: 16),
            _buildNoteSection(),
            const SizedBox(height: 16),
            _buildEtcSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- 1. Basic Info Section (Name, Age, Sex) ---
  Widget _buildBasicSection() {
    final isEditing = _editingSection == EditSection.basic;

    if (isEditing) {
      return _buildEditCard(
        title: '기본 정보 수정',
        content: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '이름'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.tryParse(_birthDateController.text) ??
                            DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        locale: const Locale('ko', 'KR'),
                      );
                      if (picked != null) {
                        setState(() {
                          _birthDateController.text = picked.toString().split(
                            ' ',
                          )[0];
                        });
                      }
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        controller: _birthDateController,
                        decoration: const InputDecoration(
                          labelText: '생년월일',
                          suffixIcon: Icon(Icons.cake),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _sex,
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('남성')),
                      DropdownMenuItem(value: 'Female', child: Text('여성')),
                    ],
                    onChanged: (v) => setState(() => _sex = v!),
                    decoration: const InputDecoration(labelText: '성별'),
                  ),
                ),
              ],
            ),
          ],
        ),
        onSave: _save,
        onCancel: _cancelEditing,
      );
    }

    // View Mode
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 48.0,
            ), // Add padding to avoid icon interaction
            child: Column(
              children: [
                Text(
                  _customer.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_customer.age != null && _customer.age!.isNotEmpty)
                  Text(
                    '${_customer.age}세 • ${_customer.sex == 'Male' ? '남성' : '여성'}${_customer.birthDate != null ? '\n(${_customer.birthDate})' : ''}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
              onPressed: () => _startEditing(EditSection.basic),
            ),
          ),
        ],
      ),
    );
  }

  // --- Actions Row ---
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(Icons.phone, '전화', () {
          /* Call Logic */
        }),
        const SizedBox(width: 32),
        _buildActionButton(Icons.message, '문자', () {
          /* SMS Logic */
        }),
      ],
    );
  }

  // --- 2. Contact Section ---
  Widget _buildContactSection() {
    final isEditing = _editingSection == EditSection.contact;

    if (isEditing) {
      return _buildEditCard(
        title: '연락처 수정',
        content: Column(
          children: [
            TextFormField(
              controller: _mobileController,
              decoration: const InputDecoration(labelText: '휴대전화'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: '유선전화'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: '주소'),
            ),
          ],
        ),
        onSave: _save,
        onCancel: _cancelEditing,
      );
    }

    return _buildDetailCard(
      title: '연락처',
      onEdit: () => _startEditing(EditSection.contact),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.smartphone, _customer.mobilePhoneNumber),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.phone, _customer.phoneNumber),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.home, _customer.address),
        ],
      ),
    );
  }

  // --- 3. Hearing Aid Section ---
  Widget _buildHearingAidSection() {
    final isEditing = _editingSection == EditSection.hearingAid;

    if (isEditing) {
      return _buildEditCard(
        title: '보청기 정보 수정',
        content: Column(
          children: [
            // List of existing aids to edit/remove
            ..._tempHearingAids.asMap().entries.map((entry) {
              final index = entry.key;
              final ha = entry.value;
              return Card(
                child: ListTile(
                  title: Text('${ha.model} (${ha.side})'),
                  subtitle: Text(ha.date),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => _tempHearingAids.removeAt(index));
                    },
                  ),
                ),
              );
            }),
            // Add button
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('보청기 추가'),
              onPressed: () async {
                // Simple dialog to add hearing aid
                final result = await showDialog<HearingAid>(
                  context: context,
                  builder: (ctx) => _AddHearingAidDialog(),
                );
                if (result != null) {
                  setState(() => _tempHearingAids.add(result));
                }
              },
            ),
          ],
        ),
        onSave: _save,
        onCancel: _cancelEditing,
      );
    }

    return _buildDetailCard(
      title: '보청기 정보',
      onEdit: () => _startEditing(EditSection.hearingAid),
      content: _customer.hearingAid == null || _customer.hearingAid!.isEmpty
          ? const Text('등록된 보청기가 없습니다.', style: TextStyle(color: Colors.grey))
          : Column(
              children: _customer.hearingAid!
                  .map(
                    (ha) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${ha.side == 'left' ? '좌(L)' : '우(R)'} • ${ha.model}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ha.date,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  // --- 4. Note Section ---
  Widget _buildNoteSection() {
    final isEditing = _editingSection == EditSection.note;

    if (isEditing) {
      return _buildEditCard(
        title: '메모 수정',
        content: TextFormField(
          controller: _noteController,
          decoration: const InputDecoration(
            labelText: '메모',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        onSave: _save,
        onCancel: _cancelEditing,
      );
    }

    return _buildDetailCard(
      title: '메모',
      onEdit: () => _startEditing(EditSection.note),
      content: Text(_customer.note ?? ''),
    );
  }

  // --- 5. Etc Section ---
  Widget _buildEtcSection() {
    final isEditing = _editingSection == EditSection.etc;

    if (isEditing) {
      return _buildEditCard(
        title: '기타 정보 수정',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Registration Date
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate:
                      DateTime.tryParse(_registrationDateController.text) ??
                      DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  locale: const Locale('ko', 'KR'),
                );
                if (picked != null) {
                  setState(
                    () => _registrationDateController.text = picked
                        .toString()
                        .split(' ')[0],
                  );
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: IgnorePointer(
                child: TextFormField(
                  controller: _registrationDateController,
                  decoration: InputDecoration(
                    labelText: '가입일',
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Battery Order Date
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate:
                      DateTime.tryParse(_batteryOrderDateController.text) ??
                      DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  locale: const Locale('ko', 'KR'),
                );
                if (picked != null) {
                  setState(
                    () => _batteryOrderDateController.text = picked
                        .toString()
                        .split(' ')[0],
                  );
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: IgnorePointer(
                child: TextFormField(
                  controller: _batteryOrderDateController,
                  decoration: InputDecoration(
                    labelText: '배터리 주문일',
                    suffixIcon: const Icon(Icons.battery_charging_full),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Welfare Card Selection
            Text(
              '복지카드 여부',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
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
                onSelectionChanged: (newSelection) {
                  setState(() => _cardAvailability = newSelection.first);
                },
                showSelectedIcon: false,
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
        onSave: _save,
        onCancel: _cancelEditing,
      );
    }

    return _buildDetailCard(
      title: '기타 정보',
      onEdit: () => _startEditing(EditSection.etc),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            Icons.calendar_today,
            '가입일: ${_customer.registrationDate}',
          ),
          if (_customer.batteryOrderDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _buildInfoRow(
                Icons.battery_charging_full,
                '배터리 주문: ${_customer.batteryOrderDate}',
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildInfoRow(
              Icons.credit_card,
              '복지카드: ${_customer.cardAvailability == 'Yes' ? '있음' : '없음'}',
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        FloatingActionButton.small(
          heroTag: 'btn_$label',
          elevation: 0,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
          onPressed: onTap,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  Widget _buildDetailCard({
    required String title,
    required Widget content,
    VoidCallback? onEdit,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onEdit != null)
                  InkWell(
                    onTap: onEdit,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '수정',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildEditCard({
    required String title,
    required Widget content,
    required VoidCallback onSave,
    required VoidCallback onCancel,
  }) {
    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            content,
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onCancel, child: const Text('취소')),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _isLoading ? null : onSave,
                  child: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('저장'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String? text) {
    if (text == null || text.isEmpty) return const SizedBox.shrink();
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}

// Simple Dialog for adding Hearing Aid
// Polished Dialog for adding Hearing Aid
class _AddHearingAidDialog extends StatefulWidget {
  @override
  __AddHearingAidDialogState createState() => __AddHearingAidDialogState();
}

class __AddHearingAidDialogState extends State<_AddHearingAidDialog> {
  final _modelController = TextEditingController();
  final _dateController = TextEditingController(
    text: DateTime.now().toString().split(' ')[0],
  );
  String _side = 'left';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('ko', 'KR'),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Custom Dialog UI
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '보청기 등록',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Side Selection
            Text(
              '방향 선택',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'left',
                  label: Text('왼쪽 (L)'),
                  icon: Icon(Icons.headphones),
                ),
                ButtonSegment(
                  value: 'right',
                  label: Text('오른쪽 (R)'),
                  icon: Icon(Icons.headphones),
                ),
              ],
              selected: {_side},
              onSelectionChanged: (newSelection) {
                setState(() => _side = newSelection.first);
              },
              showSelectedIcon: false,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(height: 20),

            // Model Name
            TextFormField(
              controller: _modelController,
              decoration: InputDecoration(
                labelText: '모델명',
                hintText: '예: Evolv AI',
                prefixIcon: const Icon(Icons.hearing),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 16),

            // Date Picker (Readonly Text Field)
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: IgnorePointer(
                child: TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: '구입일',
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Actions
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (_modelController.text.isNotEmpty) {
                        Navigator.pop(
                          context,
                          HearingAid(
                            model: _modelController.text,
                            date: _dateController.text,
                            side: _side,
                          ),
                        );
                      } else {
                        // Optional: Show hint that model is required
                      }
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '추가',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
}
