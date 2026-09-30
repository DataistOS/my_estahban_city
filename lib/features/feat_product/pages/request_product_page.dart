// lib/features/feat_product/pages/request_product_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/services/request_product_service.dart';
import 'package:my_estahban_city/core/widgets/no_connection_widget.dart';
import 'package:my_estahban_city/core/errors/pocketbase_error_handler.dart';

class RequestProductPage extends StatefulWidget {
  const RequestProductPage({super.key});

  @override
  State<RequestProductPage> createState() => _RequestProductPageState();
}

class _RequestProductPageState extends State<RequestProductPage> {
  final _requestController = TextEditingController();
  final RequestProductService _requestService = RequestProductService();
  bool _isLoading = false;
  Object? _pageError;

  @override
  void dispose() {
    _requestController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {Color backgroundColor = Colors.black}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Vazir')),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _submitRequest() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.currentUser?.id;
    final requestText = _requestController.text.trim();

    if (userId == null) {
      _showSnackBar('برای ثبت درخواست، ابتدا وارد حساب کاربری خود شوید.');
      return;
    }

    if (requestText.isEmpty) {
      _showSnackBar('لطفاً متن درخواست خود را وارد کنید.');
      return;
    }

    setState(() {
      _isLoading = true;
      _pageError = null;
    });

    try {
      await _requestService.createProductRequest(
        userId: userId,
        requestText: requestText,
      );

      _showSnackBar(
        'درخواست شما با موفقیت ثبت شد.',
        backgroundColor: Colors.green,
      );

      if (mounted) {
        _requestController.clear();
      }
    } catch (e) {
      final errorStr = e.toString();
      if (errorStr.contains('SocketException') ||
          errorStr.contains('statusCode: 0') ||
          errorStr.contains('Failed host lookup')) {
        setState(() {
          _pageError = e;
        });
      } else {
        _showSnackBar(getFriendlyErrorMessage(e), backgroundColor: Colors.red);
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
        appBar: AppBar(
          title: const Text(
            'درخواست موجود کردن محصول',
            style: TextStyle(fontFamily: 'Vazir'),
          ),
        ),
        body: _pageError != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: NoConnectionWidget()),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _pageError = null;
                          });
                        },
                        child: const Text(
                          'تلاش مجدد',
                          style: TextStyle(fontFamily: 'Vazir'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
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
                      style: const TextStyle(fontFamily: 'Vazir'),
                      decoration: InputDecoration(
                        hintText:
                            'نام محصول یا توضیحات مربوط به درخواست خود را اینجا بنویسید...',
                        hintStyle: const TextStyle(fontFamily: 'Vazir'),
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
                            label: const Text(
                              'ارسال درخواست',
                              style: TextStyle(fontFamily: 'Vazir'),
                            ),
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
