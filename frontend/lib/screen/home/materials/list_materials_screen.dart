import 'package:flutter/material.dart';
import 'package:frontend/controller/home_controller.dart';
import 'package:frontend/global/elevated_button_global.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ListMaterialsScreen extends StatelessWidget {
  ListMaterialsScreen({super.key});
  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    controller.getMaterials();
    var isAdmin = StorageService.getString('role') == 'admin';
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('Materi'),
        ),
        floatingActionButton: isAdmin
            ? FloatingActionButton(
                onPressed: () {
                  Get.toNamed('/createMaterials', arguments: {'isEdit': false});
                },
                child: const Text('+'),
              )
            : null,
        body: controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: const EdgeInsets.all(8),
                child: controller.materials.isEmpty
                    ? Center(
                        child: isAdmin
                            ? ElevatedButtonGlobal(
                                text: 'Tambah Materi',
                                onPressed: () {
                                  Get.toNamed('/createMaterials',
                                      arguments: {'isEdit': false});
                                })
                            : const Text('Tidak Ada Materi'))
                    : ListView.builder(
                        itemCount: controller.materials.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Get.toNamed('/fullMaterials',
                                  arguments: {'index': index});
                            },
                            child: Card(
                              child: Container(
                                margin: const EdgeInsets.all(7),
                                child: ListTile(
                                  title:
                                      Text(controller.materials[index].judul),
                                  subtitle: Text(
                                    controller.materials[index].deskripsi,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                    softWrap: true,
                                    maxLines: 2,
                                  ),
                                  trailing: isAdmin
                                      ? IconButton(
                                          onPressed: () {
                                            Get.toNamed('/createMaterials',
                                                arguments: {
                                                  'isEdit': true,
                                                  'index': index
                                                });
                                          },
                                          icon: const Icon(Icons.edit))
                                      : null,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
