// lib/features/feat_scanner/pages/product_scanner_page.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../services/product_service.dart';
import '../../../core/widgets/no_connection_widget.dart';
import '../../feat_product/pages/product_detail_page.dart';

class ProductScannerPage extends StatefulWidget {
  const ProductScannerPage({super.key});

  static const String routeName = '/product-scanner';

  @override
  State<ProductScannerPage> createState() => _ProductScannerPageState();
}

class _ProductScannerPageState extends State<ProductScannerPage> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    returnImage: false,
  );

  bool _isProcessing = false;
  String _errorMessage = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleBarcode(
    BarcodeCapture barcodeCapture,
    BuildContext context,
  ) async {
    if (_isProcessing) return;

    final String? code = barcodeCapture.barcodes.first.rawValue;
    if (code == null || code.isEmpty) {
      setState(() {
        _errorMessage = 'کد اسکن شده نامعتبر است.';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = '';
    });

    try {
      final productService = Provider.of<ProductService>(
        context,
        listen: false,
      );
      final product = await productService.getProductByCode(code);

      if (product != null) {
        if (mounted) {
          controller.stop();

          Navigator.of(
            context,
          ).popAndPushNamed(ProductDetailPage.routeName, arguments: product);
        }
      } else {
        setState(() {
          _errorMessage =
              'محصولی با این کد (${code.substring(0, code.length > 20 ? 20 : code.length)}...) یافت نشد.';
        });
        await Future.delayed(const Duration(seconds: 5));
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'خطایی در جستجوی محصول رخ داد.';
      });
      await Future.delayed(const Duration(seconds: 5));
    } finally {
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        controller.start();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PermissionStatus>(
      future: Permission.camera.request(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data != PermissionStatus.granted) {
          return NoConnectionWidget(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.videocam_off,
                    size: 100,
                    color: Color(0xFF333333),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'دسترسی به دوربین برای اسکن بارکد لازم است.',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Vazir',
                      color: Color(0xFF333333),
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => openAppSettings(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF333333),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'باز کردن تنظیمات',
                      style: TextStyle(fontFamily: 'Vazir'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'بازگشت به صفحه قبل',
                      style: TextStyle(fontFamily: 'Vazir', color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'اسکن محصول',
              style: TextStyle(fontFamily: 'Vazir'),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Stack(
            children: [
              MobileScanner(
                controller: controller,
                onDetect: (barcodeCapture) {
                  if (!_isProcessing) {
                    _handleBarcode(barcodeCapture, context);
                  }
                },
              ),
              Center(
                child: Container(
                  width: 250,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              if (_isProcessing)
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              if (_errorMessage.isNotEmpty)
                Positioned(
                  bottom: 50,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Vazir',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
