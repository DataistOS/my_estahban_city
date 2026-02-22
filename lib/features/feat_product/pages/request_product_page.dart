// lib/features/feat_product/pages/request_product_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/services/request_product_service.dart';

class RequestProductPage extends StatefulWidget {
  const RequestProductPage({super.key});

  @override
  State<RequestProductPage> createState() => _RequestProductPageState();
}

class _RequestProductPageState extends State<RequestProductPage> {
  final _requestController = TextEditingController();
  final RequestProductService _requestService = RequestProductService();
  bool _isLoading = false;

  @override
  void dispose() {
    _requestController.dispose();
    super.dispose();
  }

  void _submitRequest() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('برای ثبت درخواست، ابتدا وارد حساب کاربری خود شوید.'),
        ),
      );
      return;
    }

    if (_requestController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً متن درخواست خود را وارد کنید.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _requestService.createProductRequest(
        userId: userId,
        requestText: _requestController.text,
      );
      // Show success message and clear text field.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('درخواست شما با موفقیت ثبت شد.'),
            backgroundColor: Colors.green,
          ),
        );
        _requestController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطا در ارسال درخواست: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('درخواست موجود کردن محصول')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'اگر محصول مورد نظر شما در فروشگاه موجود نیست، می‌توانید از این طریق آن را درخواست دهید تا در صورت امکان به محصولات اضافه شود.',
                style: TextStyle(fontFamily: 'Vazir', fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _requestController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText:
                      'نام محصول یا توضیحات مربوط به درخواست خود را اینجا بنویسید...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _submitRequest,
                      icon: const Icon(Icons.send),
                      label: const Text('ارسال درخواست'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
