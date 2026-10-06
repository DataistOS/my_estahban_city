// lib/features/feat_services/widgets/add_equipment_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/services_provider.dart';
import '../../../services/auth_service.dart';

class AddEquipmentBottomSheet extends StatefulWidget {
  const AddEquipmentBottomSheet({super.key});

  @override
  State<AddEquipmentBottomSheet> createState() =>
      _AddEquipmentBottomSheetState();
}

class _AddEquipmentBottomSheetState extends State<AddEquipmentBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _identifierController = TextEditingController();
  final _detailsController = TextEditingController();
  String _selectedType = 'car';

  @override
  void dispose() {
    _titleController.dispose();
    _identifierController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'افزودن تجهیز یا خودروی جدید',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'نوع تجهیز',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'car', child: Text('خودرو')),
                  DropdownMenuItem(
                    value: 'home_appliance',
                    child: Text('لوازم خانگی'),
                  ),
                  DropdownMenuItem(value: 'other', child: Text('سایر')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان (مثلاً: خودروی پراید)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'لطفاً عنوان را وارد کنید'
                    : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _identifierController,
                decoration: const InputDecoration(
                  labelText: 'شماره پلاک یا شماره سریال (اختیاری)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _detailsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'جزئیات یا مدل (اختیاری)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              Consumer<ServicesProvider>(
                builder: (context, provider, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: provider.isActionLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final authService = context.read<AuthService>();
                              final userId = authService.currentUser?.id;

                              if (userId == null) return;

                              final data = {
                                'user': userId,
                                'type': _selectedType,
                                'title': _titleController.text.trim(),
                                'identifier': _identifierController.text.trim(),
                                'details': _detailsController.text.trim(),
                              };

                              final success = await provider.addNewEquipment(
                                data,
                              );

                              if (!context.mounted) return;

                              if (success) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'تجهیز جدید با موفقیت اضافه شد.',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      provider.errorMessage ??
                                          'خطا در ثبت تجهیز',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                    child: provider.isActionLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('ثبت تجهیز'),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
