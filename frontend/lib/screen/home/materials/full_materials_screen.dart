import 'package:flutter/material.dart';
import 'package:frontend/controller/home_controller.dart';
import 'package:frontend/global/elevated_button_global.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class FullMaterialsScreen extends StatelessWidget {
  late int index;
  var controller = Get.find<HomeController>();
  FullMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    index = Get.arguments?['index'] ?? 0;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.materials[index].judul,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(controller.materials[index].deskripsi),
              Text(
                  'Diupload Pada: ${DateFormat('dd MMMM yyyy hh:mm').format(DateTime.parse(controller.materials[index].createdAt!))}'),
              if (controller.materials[index].file != null)
                Card(
                  child: Container(
                    margin: const EdgeInsets.all(7),
                    child: ListTile(
                      title: Text(
                          controller.materials[index].file!.split('/').last),
                      trailing: TextButton(
                          onPressed: () {
                            controller.downloadMaterialFile(
                                controller.materials[index].id,
                                controller.materials[index].file!
                                    .split('/')
                                    .last);
                          },
                          child: const Text('Download Materi')),
                    ),
                  ),
                ),
              if (StorageService.getString('role') == 'admin')
                Wrap(
                  spacing: 10,
                  children: [
                    ElevatedButtonGlobal(
                        bgColors: Colors.red,
                        text: 'Hapus Materi ',
                        onPressed: () {
                          controller.deleteMaterials(index, context);
                        }),
                    ElevatedButtonGlobal(
                        text: 'Edit Materi ',
                        onPressed: () {
                          Get.back();
                          Get.toNamed('/createMaterials',
                              arguments: {'index': index, 'isEdit': true});
                        }),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
