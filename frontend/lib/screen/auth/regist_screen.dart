import 'package:flutter/material.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/global/elevated_button_global.dart';
import 'package:get/get.dart';

class RegistScreen extends StatefulWidget {
  const RegistScreen({super.key});

  @override
  State<RegistScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegistScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  var controller = Get.find<AuthController>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E Learning'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Center(
          child: Form(
            key: _formKey,
            child: Obx(
              () => SingleChildScrollView(
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Daftar Sekarang',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                labelText: 'Nama',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.all(10)),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                counterText: 'Minimal 8 karakter',
                                contentPadding: const EdgeInsets.all(10),
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            keyboardType: TextInputType.emailAddress,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButtonGlobal(
                            text: 'Daftar',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (_passwordController.text.length >= 8) {
                                  controller.register(
                                      context,
                                      _nameController.text,
                                      _emailController.text,
                                      _passwordController.text);
                                  return;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content:
                                          Text('Password minimal 8 karakter'),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Sudah punya akun?'),
                              TextButton(
                                onPressed: () {
                                  Get.offAndToNamed('/login');
                                },
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
