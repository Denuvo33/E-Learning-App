import 'package:flutter/material.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AdminHomeScreen extends StatelessWidget {
  AdminHomeScreen({super.key});
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
              const Icon(Icons.info),
              const Text(
                'Admin Panel',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                      children: [
                        Icon(Icons.edit),
                        Text('Buat Ujian / Edit Ujian')
                      ],
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
                    width: Get.width * 0.3,
                    margin: const EdgeInsets.all(7),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.note), Text('Materi')],
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
                        Text('Lihat Nilai Ujian Siswa')
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
