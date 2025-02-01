import 'package:flutter/material.dart';
import 'package:frontend/controller/home_controller.dart';
import 'package:frontend/global/elevated_button_global.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ListExamScreen extends StatelessWidget {
  ListExamScreen({super.key});
  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    var isAdmin = StorageService.getString('role') == 'admin';
    controller.getExams();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('Ujian'),
        ),
        floatingActionButton: isAdmin
            ? FloatingActionButton(
                onPressed: () {
                  Get.toNamed('/createExams', arguments: {'isEdit': false});
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
                child: controller.exam.isEmpty
                    ? Center(
                        child: isAdmin
                            ? ElevatedButtonGlobal(
                                text: 'Buat Ujian',
                                onPressed: () {
                                  Get.toNamed('/createExams',
                                      arguments: {'isEdit': false});
                                })
                            : const Text('Tidak Ada Ujian Yang Tersedia'),
                      )
                    : ListView.builder(
                        itemCount: controller.exam.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Get.toNamed('/fullExams',
                                  arguments: {'index': index});
                            },
                            child: Card(
                              child: Container(
                                margin: const EdgeInsets.all(7),
                                child: ListTile(
                                  title: Text(controller.exam[index].title),
                                  subtitle: Text(
                                    controller.exam[index].description,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                    softWrap: true,
                                    maxLines: 2,
                                  ),
                                  trailing: isAdmin
                                      ? IconButton(
                                          onPressed: () {
                                            Get.toNamed('/createExams',
                                                arguments: {
                                                  'isEdit': true,
                                                  'index': index,
                                                  'examId':
                                                      controller.exam[index].id
                                                });
                                          },
                                          icon: const Icon(Icons.edit))
                                      : null,
                                ),
                              ),
                            ),
                          );
                        },
                      )),
      ),
    );
  }
}
