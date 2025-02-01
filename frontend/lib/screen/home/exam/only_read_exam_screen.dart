import 'package:flutter/material.dart';
import 'package:frontend/controller/home_controller.dart';
import 'package:frontend/model/exam_model.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class OnlyReadExamScreen extends StatelessWidget {
  var controller = Get.find<HomeController>();
  OnlyReadExamScreen({super.key});
  var isLoading = true.obs;
  late int id;
  late final ExamModel? exam;

  void getExams() async {
    isLoading(true);
    id = Get.arguments['id'] ?? 0;
    exam = await controller.getSpesificExam(id);
    isLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    getExams();
    return Scaffold(
      appBar: AppBar(),
      body: Obx(
        () => isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : exam == null
                ? const Text('Data Tidak Ditemukan')
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          exam!.title,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          exam!.description,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Pertanyaan:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: exam!.questions.length,
                          itemBuilder: (BuildContext context, int qIndex) {
                            var question = exam!.questions[qIndex];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${qIndex + 1}. ${question.question}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Column(
                                      children: question.options
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        int optIndex = entry.key;
                                        String option = entry.value;
                                        return ListTile(
                                          title: Text(
                                              'Option ${optIndex + 1}: $option'),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
