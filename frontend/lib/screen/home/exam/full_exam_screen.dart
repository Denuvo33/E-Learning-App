import 'package:flutter/material.dart';
import 'package:frontend/controller/home_controller.dart';
import 'package:frontend/global/elevated_button_global.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class FullExamScreen extends StatelessWidget {
  late int index;
  var controller = Get.find<HomeController>();
  FullExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    index = Get.arguments?['index'] ?? 0;
    var exam = controller.exam[index];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ujian'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(exam.title),
                subtitle: Text(exam.description),
              ),
              Text(
                  'Dapat Dikerjakan Pada: ${DateFormat('dd MMMM yyyy hh:mm').format(DateTime.parse(exam.startDate))}'),
              Text('Durasi: ${exam.duration} menit'),
              Text('Jumlah Soal: ${exam.questions.length}'),
              if (StorageService.getString('role') == 'admin')
                Wrap(
                  spacing: 10,
                  children: [
                    ElevatedButtonGlobal(
                      bgColors: Colors.red,
                      text: 'Hapus Ujian',
                      onPressed: () {
                        controller.deleteExam(controller.exam[index].id!);
                      },
                    ),
                    ElevatedButtonGlobal(
                      text: 'Edit Ujian',
                      onPressed: () {
                        Get.toNamed(
                          '/createExams',
                          arguments: {
                            'isEdit': true,
                            'index': index,
                            'examId': controller.exam[index].id
                          },
                        );
                      },
                    ),
                  ],
                ),
              if (StorageService.getString('role') == 'siswa')
                ElevatedButtonGlobal(
                    bgColors: Colors.green,
                    text: 'Mulai Ujian',
                    onPressed: () {
                      Get.defaultDialog(
                          title: 'Mulai Ujian',
                          middleText: 'Apakah Anda yakin ingin memulai ujian?',
                          onCancel: () {},
                          onConfirm: () {
                            Get.back();
                            Get.offAllNamed('/exams',
                                arguments: {'index': index});
                          });
                    }),
            ],
          ),
        ),
      ),
    );
  }
}
