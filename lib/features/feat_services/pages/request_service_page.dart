// lib/features/feat_services/pages/request_service_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/services_provider.dart';
import '../models/service_model.dart';
import '../widgets/add_equipment_bottom_sheet.dart';
import '../../../services/auth_service.dart';

class RequestServicePage extends StatefulWidget {
  final ServiceModel service;

  const RequestServicePage({super.key, required this.service});

  @override
  State<RequestServicePage> createState() => _RequestServicePageState();
}

class _RequestServicePageState extends State<RequestServicePage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String? _selectedEquipmentId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthService>().currentUser?.id;
      if (userId != null && userId.isNotEmpty) {
        context.read<ServicesProvider>().fetchUserEquipments(userId);
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ثبت درخواست: ${widget.service.title}',
          style: const TextStyle(fontFamily: 'Vazir'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ServicesProvider>(
          builder: (context, provider, child) {
            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.service.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Vazir',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.service.description ?? 'بدون توضیحات',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontFamily: 'Vazir',
                            ),
                          ),
                          if (widget.service.basePrice != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              'هزینه پایه: ${widget.service.basePrice} تومان',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontFamily: 'Vazir',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'انتخاب تجهیز / دستگاه',
                            labelStyle: TextStyle(fontFamily: 'Vazir'),
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedEquipmentId,
                          items: provider.userEquipments.map((equipment) {
                            return DropdownMenuItem<String>(
                              value: equipment.id,
                              child: Text(
                                equipment.title,
                                style: const TextStyle(fontFamily: 'Vazir'),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedEquipmentId = value;
                            });
                          },
                          validator: (value) => value == null
                              ? 'لطفاً یک تجهیز را انتخاب کنید'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 56,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.add, color: Colors.blue),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) =>
                                  const AddEquipmentBottomSheet(),
                            );
                          },
                          tooltip: 'افزودن تجهیز جدید',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // فیلد توضیحات مشکل
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'توضیحات کامل مشکل یا درخواست',
                      labelStyle: TextStyle(fontFamily: 'Vazir'),
                      hintText:
                          'جزئیات نقص فنی یا سرویس مورد نظر را بنویسید...',
                      hintStyle: TextStyle(fontFamily: 'Vazir'),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontFamily: 'Vazir'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'لطفاً توضیحات مشکل را وارد کنید';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // دکمه ثبت نهایی
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: provider.isActionLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final authService = context.read<AuthService>();
                              final userId = authService.currentUser?.id;
                              final userTier =
                                  authService.currentUser?.tier ?? 'free';

                              if (userId == null || userId.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'لطفاً ابتدا وارد حساب کاربری خود شوید.',
                                      style: TextStyle(fontFamily: 'Vazir'),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final success = await provider
                                  .submitRepairRequest(
                                    userId: userId,
                                    userTier: userTier,
                                    serviceId: widget.service.id,
                                    equipmentId: _selectedEquipmentId!,
                                    issueDescription: _descriptionController
                                        .text
                                        .trim(),
                                  );

                              if (!context.mounted) return;

                              if (success) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: const Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 28,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'درخواست ثبت شد',
                                            style: TextStyle(
                                              fontFamily: 'Vazir',
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: const Text(
                                        'درخواست شما با موفقیت ثبت شد و در حال بررسی است. به زودی با شما تماس خواهیم گرفت.',
                                        style: TextStyle(
                                          fontFamily: 'Vazir',
                                          height: 1.5,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'متوجه شدم',
                                            style: TextStyle(
                                              fontFamily: 'Vazir',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      provider.errorMessage ?? 'خطایی رخ داد.',
                                      style: TextStyle(fontFamily: 'Vazir'),
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
                        : const Text(
                            'ثبت نهایی درخواست',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Vazir',
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
