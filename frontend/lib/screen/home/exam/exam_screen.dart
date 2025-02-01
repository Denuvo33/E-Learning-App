import 'package:flutter/material.dart';
import 'package:frontend/global/elevated_button_global.dart';
import 'package:get/get.dart';
import 'package:frontend/controller/home_controller.dart';

// ignore: must_be_immutable
class ExamScreen extends StatelessWidget {
  var controller = Get.find<HomeController>();
  late int index;

  ExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    index = Get.arguments?['index'];
    var exam = controller.exam[index];
    Map<int, String> selectedAnswers = <int, String>{}.obs;

    return Scaffold(
      appBar: AppBar(
        title: Text(exam.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exam.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Text(
              'Durasi: ${exam.duration} menit',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pertanyaan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: exam.questions.length,
              itemBuilder: (context, qIndex) {
                var question = exam.questions[qIndex];
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
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Obx(
                          () => Column(
                            children: question.options.map((option) {
                              return RadioListTile<String>(
                                title: Text(option),
                                value: option,
                                groupValue: selectedAnswers[qIndex],
                                onChanged: (value) {
                                  selectedAnswers[qIndex] = value!;
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButtonGlobal(
                text: 'Kirim Jawaban',
                onPressed: () async {
                  int totalScore = 0;
                  for (var qIndex = 0;
                      qIndex < exam.questions.length;
                      qIndex++) {
                    var question = exam.questions[qIndex];
                    if (selectedAnswers[qIndex] == question.answer) {
                      totalScore += question.score;
                    }
                  }

                  bool success = await controller.submitGrade(
                    exam.id!,
                    totalScore,
                  );

                  if (success) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ujian Berhasil Dikirim'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Get.offNamed('/homeSiswa');
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gagal mengirim Ujian'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
