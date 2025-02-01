import 'package:flutter/material.dart';
import 'package:frontend/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class GradeScreen extends StatelessWidget {
  var controller = Get.find<HomeController>();
  GradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getGrade();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nilai Siswa'),
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.grade.isEmpty
                  ? const Center(child: Text('Belum Ada Nilai'))
                  : ListView.builder(
                      itemCount: controller.grade.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.all(7),
                          child: Card(
                            child: Container(
                                margin: const EdgeInsets.all(7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Email: ${controller.grade[index].email}'),
                                    Text(
                                        'Nilai: ${controller.grade[index].score}'),
                                    Text(
                                        'Dikerjakan Tanggal: ${DateFormat('dd MMMM yyyy hh:mm').format(DateTime.parse(controller.grade[index].createdAt!))}'),
                                    TextButton(
                                        onPressed: () {
                                          Get.toNamed('/examsRead', arguments: {
                                            'id': controller.grade[index].examId
                                          });
                                        },
                                        child: const Text('Lihat Soal Ujian'))
                                  ],
                                )),
                          ),
                        );
                      },
                    ),
        ));
  }
}
