import 'package:flutter/material.dart';
import 'package:frontend/service/api_service.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final ApiService api = ApiService();
  final RxBool isLoading = false.obs;

  Future<void> splashScreen() async {
    if (StorageService.getString('token').isNotEmpty) {
      debugPrint('token is ${StorageService.getString('token')}');
      if (StorageService.getString('role') == 'siswa') {
        Get.offAllNamed('/homeSiswa');
      } else {
        Get.offAllNamed('/homeAdmin');
      }
    } else {
      Get.offAllNamed('/login');
    }
  }

  Future<void> register(
      context, String name, String email, String password) async {
    isLoading(true);
    await api.regist(context, name, email, password);
    isLoading(false);
  }

  Future<void> login(context, email, password) async {
    isLoading(true);
    await api.login(context, email, password);

    isLoading(false);
  }

  void logout() {
    api.logout();
  }
}
