// lib/features/feat_auth/pages/register_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_estahban_city/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();

  final _nationalCodeController = TextEditingController();
  final _birthDateController = TextEditingController();

  final _economicCodeController = TextEditingController();
  final _companyRegistrationNumberController = TextEditingController();
  final _ceoNameController = TextEditingController();

  String _userType = 'individual';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _nationalCodeController.dispose();
    _birthDateController.dispose();
    _economicCodeController.dispose();
    _companyRegistrationNumberController.dispose();
    _ceoNameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);

      authService.clearError();

      try {
        final Map<String, dynamic> userData = {
          'user_type': _userType,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
          'passwordConfirm': _passwordConfirmController.text,
          'phone_number': _phoneNumberController.text.trim(),
          'address': _addressController.text.trim(),
        };

        if (_userType == 'individual') {
          userData['national_code'] = _nationalCodeController.text.trim();

          final birthDate = _birthDateController.text.trim();
          if (birthDate.isNotEmpty) {
            userData['birth_date'] = birthDate;
          }
        } else {
          userData['economic_code'] = _economicCodeController.text.trim();
          userData['company_registration_number'] =
              _companyRegistrationNumberController.text.trim();
          userData['ceo_name'] = _ceoNameController.text.trim();
        }

        await authService.register(userData);
        if (!mounted) return;

        if (authService.errorMessage == null) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'ثبت‌نام با موفقیت انجام شد!',
                style: TextStyle(fontFamily: 'Vazir'),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                authService.errorMessage!,
                style: const TextStyle(fontFamily: 'Vazir'),
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'خطای غیرمنتظره: $e',
              style: const TextStyle(fontFamily: 'Vazir'),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE3F1),
      appBar: AppBar(
        title: const Text('ثبت‌نام', style: TextStyle(fontFamily: 'Vazir')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF333333)),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Consumer<AuthService>(
          builder: (context, authService, child) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ایجاد حساب کاربری جدید',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Vazir',
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text(
                                'حقیقی',
                                style: TextStyle(
                                  fontFamily: 'Vazir',
                                  color: Color(0xFF333333),
                                ),
                              ),
                              value: 'individual',
                              groupValue: _userType,
                              onChanged: (value) {
                                setState(() {
                                  _userType = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text(
                                'حقوقی',
                                style: TextStyle(
                                  fontFamily: 'Vazir',
                                  color: Color(0xFF333333),
                                ),
                              ),
                              value: 'legal',
                              groupValue: _userType,
                              onChanged: (value) {
                                setState(() {
                                  _userType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _nameController,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'Vazir',
                          color: Color(0xFF333333),
                        ),
                        decoration: InputDecoration(
                          labelText: _userType == 'individual'
                              ? 'نام و نام خانوادگی'
                              : 'نام شرکت',
                          labelStyle: const TextStyle(
                            fontFamily: 'Vazir',
                            color: Colors.grey,
                          ),
                          border: const OutlineInputBorder(),
                          suffixIcon: const Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا این فیلد را وارد کنید';
                          }
                          if (RegExp(
                            r'[0-9!@#\$%^&*()_+={}\[\]:;"<>,.?/\\|]',
                          ).hasMatch(value)) {
                            return 'نام نباید شامل اعداد یا نماد باشد';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _emailController,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'Vazir',
                          color: Color(0xFF333333),
                        ),
                        decoration: const InputDecoration(
                          labelText: 'ایمیل',
                          labelStyle: TextStyle(
                            fontFamily: 'Vazir',
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.email, color: Colors.grey),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا ایمیل خود را وارد کنید';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'ایمیل معتبر نیست';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _phoneNumberController,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'Vazir',
                          color: Color(0xFF333333),
                        ),
                        decoration: const InputDecoration(
                          labelText: 'شماره تماس (۰۹xxxxxxxxx)',
                          labelStyle: TextStyle(
                            fontFamily: 'Vazir',
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.phone, color: Colors.grey),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا شماره تماس خود را وارد کنید';
                          }
                          if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                            return 'شماره تماس باید ۱۱ رقم و فقط عدد باشد';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'Vazir',
                          color: Color(0xFF333333),
                        ),
                        decoration: const InputDecoration(
                          labelText: 'آدرس',
                          labelStyle: TextStyle(
                            fontFamily: 'Vazir',
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا آدرس خود را وارد کنید';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      if (_userType == 'individual') ...[
                        TextFormField(
                          controller: _nationalCodeController,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'Vazir',
                            color: Color(0xFF333333),
                          ),
                          decoration: const InputDecoration(
                            labelText: 'کد ملی (۱۰ رقم)',
                            labelStyle: TextStyle(
                              fontFamily: 'Vazir',
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(
                              Icons.credit_card,
                              color: Colors.grey,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'لطفا کد ملی را وارد کنید';
                            }
                            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                              return 'کد ملی باید ۱۰ رقم و فقط عدد باشد';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _birthDateController,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'Vazir',
                            color: Color(0xFF333333),
                          ),
                          decoration: const InputDecoration(
                            labelText: 'تاریخ تولد (YYYY-MM-DD)',
                            labelStyle: TextStyle(
                              fontFamily: 'Vazir',
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'لطفا تاریخ تولد را وارد کنید';
                            }
                            if (!RegExp(
                              r'^\d{4}-\d{2}-\d{2}$',
                            ).hasMatch(value)) {
                              return 'فرمت تاریخ باید YYYY-MM-DD باشد';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      if (_userType == 'legal') ...[
                        TextFormField(
                          controller: _economicCodeController,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'Vazir',
                            color: Color(0xFF333333),
                          ),
                          decoration: const InputDecoration(
                            labelText: 'کد اقتصادی',
                            labelStyle: TextStyle(
                              fontFamily: 'Vazir',
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(
                              Icons.business,
                              color: Colors.grey,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'لطفا کد اقتصادی را وارد کنید';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _companyRegistrationNumberController,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'Vazir',
                            color: Color(0xFF333333),
                          ),
                          decoration: const InputDecoration(
                            labelText: 'شماره ثبت شرکت',
                            labelStyle: TextStyle(
                              fontFamily: 'Vazir',
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(
                              Icons.insert_drive_file,
                              color: Colors.grey,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'لطفا شماره ثبت شرکت را وارد کنید';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _ceoNameController,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'Vazir',
                            color: Color(0xFF333333),
                          ),
                          decoration: const InputDecoration(
                            labelText: 'نام مدیر عامل',
                            labelStyle: TextStyle(
                              fontFamily: 'Vazir',
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(
                              Icons.person_pin,
                              color: Colors.grey,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'لطفا نام مدیر عامل را وارد کنید';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'Vazir',
                          color: Color(0xFF333333),
                        ),
                        decoration: const InputDecoration(
                          labelText: 'رمز عبور (حداقل ۱۲ کاراکتر، ترکیبی)',
                          labelStyle: TextStyle(
                            fontFamily: 'Vazir',
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.lock, color: Colors.grey),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا رمز عبور خود را وارد کنید';
                          }
                          if (value.length < 12) {
                            return 'رمز عبور باید حداقل ۱۲ کاراکتر باشد';
                          }
                          final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
                          final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
                          final hasDigits = RegExp(r'[0-9]').hasMatch(value);
                          final hasSpecialCharacters = RegExp(
                            r'[!@#\$&*~]',
                          ).hasMatch(value);

                          if (!hasUppercase) {
                            return 'باید شامل حروف بزرگ انگلیسی باشد.';
                          }
                          if (!hasLowercase) {
                            return 'باید شامل حروف کوچک انگلیسی باشد.';
                          }
                          if (!hasDigits) {
                            return 'باید شامل حداقل یک عدد باشد.';
                          }
                          if (!hasSpecialCharacters) {
                            return 'باید شامل حداقل یک نماد (!@#\$&*~) باشد.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordConfirmController,
                        obscureText: true,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'Vazir',
                          color: Color(0xFF333333),
                        ),
                        decoration: const InputDecoration(
                          labelText: 'تکرار رمز عبور',
                          labelStyle: TextStyle(
                            fontFamily: 'Vazir',
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.lock_open, color: Colors.grey),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا تکرار رمز عبور را وارد کنید';
                          }
                          if (value != _passwordController.text) {
                            return 'تکرار رمز عبور با رمز عبور مطابقت ندارد';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      authService.isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xFF333333),
                            )
                          : ElevatedButton(
                              onPressed: _register,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                backgroundColor: const Color(0xFF333333),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text(
                                'ثبت‌نام',
                                style: TextStyle(fontFamily: 'Vazir'),
                              ),
                            ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'قبلا حساب کاربری دارید؟ وارد شوید.',
                          style: TextStyle(
                            fontFamily: 'Vazir',
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
