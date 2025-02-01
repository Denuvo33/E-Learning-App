import 'package:flutter/material.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SiswaHomeScreen extends StatelessWidget {
  SiswaHomeScreen({super.key});
  var controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E Learning'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Wrap(
            runSpacing: 10,
            spacing: 10,
            children: [
              Text(
                'Selamat Datang, ${StorageService.getString('name')}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed('/examsList');
                },
                child: Card(
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    margin: const EdgeInsets.all(7),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.edit), Text('Kerjakan Ujian')],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed('/materials');
                },
                child: Card(
                  child: Container(
                    height: 60,
                    width: Get.width * 0.4,
                    margin: const EdgeInsets.all(7),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.note), Text('Baca Materi')],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed('/grade');
                },
                child: Card(
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.all(7),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline_outlined),
                        Text('Lihat Hasil Nilai Ujian')
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                      title: 'Keluar',
                      middleText: 'Apakah anda yakin ingin keluar?',
                      textConfirm: 'Ya',
                      textCancel: 'Tidak',
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        controller.logout();
                      });
                },
                child: Card(
                  color: Colors.red,
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.all(7),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        Text(
                          'Keluar',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
