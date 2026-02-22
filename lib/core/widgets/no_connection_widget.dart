// lib/core/widgets/no_connection_widget.dart

import 'package:flutter/material.dart';

class NoConnectionWidget extends StatelessWidget {
  final Color backgroundColor;
  final Widget? child;

  const NoConnectionWidget({
    super.key,
    this.backgroundColor = const Color(0xFFDDE3F1),
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child:
            child ??
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    size: 100,
                    color: Color(0xFF333333),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'لطفاً اتصال اینترنت خود را بررسی کنید',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Vazir',
                      color: Color(0xFF333333),
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
