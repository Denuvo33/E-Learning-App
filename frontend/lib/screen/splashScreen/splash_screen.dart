import 'package:flutter/material.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final controller = Get.find<AuthController>();

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));
    controller.splashScreen();
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: FlutterLogo(
          size: 150,
        ),
      ),
    );
  }
}
