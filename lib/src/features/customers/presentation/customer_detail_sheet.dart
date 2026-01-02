import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../customers/data/customer_repository.dart';
import '../../customers/domain/customer.dart';
import '../../customers/domain/repair.dart';
import 'customer_avatar.dart';

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
  File? _selectedImage;
  final _picker = ImagePicker();

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
      // Automatically save when image is picked?
      // Or wait for manual save?
      // Given the current UI, better to upload immediately and refresh.
      await _uploadSelectedImage();
    }
  }

  Future<void> _uploadSelectedImage() async {
    if (_selectedImage == null) return;
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(customerRepositoryProvider);
      await repo.uploadProfilePicture(_customer.id, _selectedImage!);

      // Invalidate and await the refresh
      ref.invalidate(customersListProvider);
      final list = await ref.read(customersListProvider.future);

      // Update local state with fresh data (including new updated_at)
      final updated = list.firstWhere((c) => c.id == _customer.id);

      setState(() {
        _customer = updated;
        _selectedImage = null;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
            _buildHeader(),
            const SizedBox(height: 32),
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
            const SizedBox(height: 16),
            _buildRepairSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- 0. Header (Avatar & Name) ---
  Widget _buildHeader() {
    return Column(
      children: [
        Stack(
          children: [
            CustomerAvatar(
              customer: _customer,
              radius: 40,
              fontSize: 32,
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
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _isLoading ? null : _pickImage,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 14,
                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Balancing invisible widget to ensure Name is centered
            Opacity(
              opacity: 0,
              child: IgnorePointer(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.edit, size: 18),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            Text(
              _customer.name,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _startEditing(EditSection.basic),
              icon: const Icon(Icons.edit, size: 18),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              color: Colors.grey,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${_customer.age ?? "나이 미상"}세 • ${_customer.sex == 'Male'
              ? '남'
              : _customer.sex == 'Female'
              ? '여'
              : '성별 미상'}',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
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
    return const SizedBox.shrink();
  }

  // --- Actions Row ---
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(Icons.phone, '전화', () {
          final mobile = _customer.mobilePhoneNumber;
          final home = _customer.phoneNumber;
          final hasMobile = mobile != null && mobile.isNotEmpty;
          final hasHome = home != null && home.isNotEmpty;

          if (hasMobile && hasHome) {
            // Show selection sheet
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '전화 걸기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.smartphone),
                      title: Text(mobile!),
                      subtitle: const Text('휴대전화'),
                      onTap: () {
                        Navigator.pop(context);
                        _makePhoneCall(mobile);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(home!),
                      subtitle: const Text('유선전화'),
                      onTap: () {
                        Navigator.pop(context);
                        _makePhoneCall(home);
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (hasMobile) {
            _makePhoneCall(mobile!);
          } else if (hasHome) {
            _makePhoneCall(home!);
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('등록된 전화번호가 없습니다.')));
          }
        }),
        const SizedBox(width: 32),
        _buildActionButton(Icons.message, '문자', () {
          final mobile = _customer.mobilePhoneNumber;
          if (mobile != null && mobile.isNotEmpty) {
            _sendSms(mobile);
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('휴대전화 번호가 없습니다.')));
          }
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
                  subtitle: Text(ha.date ?? '날짜 미상'),
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
                            ha.date ?? '날짜 미상',
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

  // --- 6. Repair Section ---
  Widget _buildRepairSection() {
    // Repairs are read-only in this view (edit/add logic could be separate or added later)
    // We sort by date descending (newest first)
    final repairs = _customer.repairs ?? [];

    // Sort logic
    final sortedRepairs = List.of(repairs)
      ..sort((a, b) {
        final dateAStr = a.date?.replaceAll('.', '-') ?? '1900-01-01';
        final dateBStr = b.date?.replaceAll('.', '-') ?? '1900-01-01';
        final dateA = DateTime.tryParse(dateAStr) ?? DateTime(1900);
        final dateB = DateTime.tryParse(dateBStr) ?? DateTime(1900);
        return dateB.compareTo(dateA);
      });

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '수리 내역 (${sortedRepairs.length})',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: _addRepair,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '추가',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (sortedRepairs.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '수리 내역이 없습니다.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              Column(
                children: sortedRepairs.asMap().entries.map((entry) {
                  final isLast = entry.key == sortedRepairs.length - 1;
                  final repair = entry.value;

                  return Container(
                    margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
                    padding: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : Border(
                              bottom: BorderSide(
                                color: Theme.of(
                                  context,
                                ).dividerColor.withOpacity(0.1),
                              ),
                            ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date & Status
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              repair.date ?? '날짜 미상',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: repair.isCompleted
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                repair.isCompleted ? '완료' : '진행중',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: repair.isCompleted
                                      ? Colors.green[700]
                                      : Colors.orange[800],
                                ),
                              ),
                            ),
                            // Complete Button for In Progress
                            if (!repair.isCompleted)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: InkWell(
                                  onTap: () => _markRepairCompleted(repair),
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).primaryColor.withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '완료 처리',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Content & Cost
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                repair.content,
                                style: const TextStyle(fontSize: 14),
                              ),
                              if (repair.cost != null &&
                                  repair.cost!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '비용: ${repair.cost}원',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
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

  Future<void> _addRepair() async {
    final newRepair = await showDialog<Repair>(
      context: context,
      builder: (context) => _AddRepairDialog(),
    );

    if (newRepair != null) {
      if (mounted) setState(() => _isLoading = true);
      try {
        final currentRepairs = List<Repair>.from(_customer.repairs ?? []);
        currentRepairs.add(newRepair);

        final updatedCustomer = _customer.copyWith(repairs: currentRepairs);

        await ref
            .read(customerRepositoryProvider)
            .updateCustomer(updatedCustomer);

        // Refresh local state to show it immediately
        setState(() {
          _customer = updatedCustomer;
        });

        ref.invalidate(customersListProvider);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error adding repair: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _markRepairCompleted(Repair targetRepair) async {
    if (mounted) setState(() => _isLoading = true);
    try {
      // Find index by ID if possible, otherwise by content/date match
      final repairs = List<Repair>.from(_customer.repairs ?? []);
      final index = repairs.indexWhere((r) => r.id == targetRepair.id);

      if (index != -1) {
        repairs[index] = targetRepair.copyWith(isCompleted: true);

        final updatedCustomer = _customer.copyWith(repairs: repairs);

        await ref
            .read(customerRepositoryProvider)
            .updateCustomer(updatedCustomer);

        // Refresh local state
        setState(() {
          _customer = updatedCustomer;
        });

        ref.invalidate(customersListProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating repair: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll('-', ''), // Remove dashes for execution
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('전화를 걸 수 없습니다.')));
      }
    }
  }

  Future<void> _sendSms(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber.replaceAll('-', ''),
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('문자를 보낼 수 없습니다.')));
      }
    }
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
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
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

class _AddRepairDialog extends StatefulWidget {
  @override
  __AddRepairDialogState createState() => __AddRepairDialogState();
}

class __AddRepairDialogState extends State<_AddRepairDialog> {
  final _contentController = TextEditingController();
  final _costController = TextEditingController();
  final _dateController = TextEditingController(
    text: DateTime.now().toString().split(' ')[0],
  );

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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '수리 내역 추가',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Content
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: '수리 내용',
                  hintText: '예: 스피커 교체',
                  prefixIcon: const Icon(Icons.build),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Cost
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '비용 (선택)',
                  hintText: '예: 50000',
                  prefixIcon: const Icon(Icons.attach_money),
                  suffixText: '원',
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

              // Date Picker
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: IgnorePointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: '접수일',
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
                        if (_contentController.text.isNotEmpty) {
                          Navigator.pop(
                            context,
                            Repair(
                              id: 'repair_${DateTime.now().millisecondsSinceEpoch}',
                              date: _dateController.text,
                              content: _contentController.text,
                              cost: _costController.text,
                              isCompleted: false,
                            ),
                          );
                        } else {
                          // Hint required?
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
      ),
    );
  }
}
