import 'package:flutter/material.dart';
import 'package:frontend/controller/home_controller.dart';
import 'package:frontend/global/elevated_button_global.dart';
import 'package:get/get.dart';
import 'package:frontend/model/question_model.dart';

class EditUploadExamsScreen extends StatefulWidget {
  const EditUploadExamsScreen({super.key});

  @override
  State<EditUploadExamsScreen> createState() => _EditUploadExamsScreenState();
}

class _EditUploadExamsScreenState extends State<EditUploadExamsScreen> {
  late bool isEdit;
  late int index;
  late int examId;

  var controller = Get.find<HomeController>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _durationController = TextEditingController();
  List<List<TextEditingController>> optionControllers = [];
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> scoreControllers = [];
  List<QuestionModel> questions = [];
  List<QuestionModel> deletedQuestions = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _durationController.dispose();
    questions.clear();
    questionControllers.clear();
    scoreControllers.clear();
    optionControllers.clear();
    deletedQuestions.clear();
  }

  @override
  void initState() {
    super.initState();
    isEdit = Get.arguments?['isEdit'] ?? false;
    index = Get.arguments?['index'] ?? 0;
    examId = Get.arguments?['examId'] ?? 0;

    if (isEdit) {
      var exam = controller.exam[index];
      _titleController.text = exam.title;
      _descriptionController.text = exam.description;
      _startDateController.text = exam.startDate.toString();
      _durationController.text = exam.duration.toString();
      questions = List.from(exam.questions);

      for (var question in questions) {
        questionControllers.add(TextEditingController(text: question.question));
        scoreControllers
            .add(TextEditingController(text: question.score.toString()));

        List<TextEditingController> tempOptions = [];
        for (var option in question.options) {
          tempOptions.add(TextEditingController(text: option));
        }
        optionControllers.add(tempOptions);
      }
    }
  }

  void removeQuestion(int index) {
    setState(() {
      if (isEdit && questions[index].id != null) {
        questions[index].markForDeletion();
        deletedQuestions.add(questions[index]);
      }

      questions.removeAt(index);

      questionControllers.removeAt(index);
      optionControllers.removeAt(index);
      scoreControllers.removeAt(index);
    });
  }

  void setAnswer(int qIndex, String value) {
    setState(() {
      questions[qIndex].answer = value;
    });
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      _startDateController.text = picked.toLocal().toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Ujian' : 'Tambah Ujian')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Ujian'),
                validator: (value) =>
                    value!.isEmpty ? 'Judul harus diisi' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                validator: (value) =>
                    value!.isEmpty ? 'Deskripsi harus diisi' : null,
              ),
              TextFormField(
                controller: _startDateController,
                decoration: const InputDecoration(labelText: 'Tanggal Mulai'),
                readOnly: true,
                onTap: _selectDate,
              ),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Durasi (menit)'),
                validator: (value) =>
                    value!.isEmpty ? 'Durasi harus diisi' : null,
              ),
              const SizedBox(height: 16),
              const Text('Pertanyaan:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: questions.length,
                itemBuilder: (context, qIndex) {
                  final question = questions[qIndex];
                  if (question.isDeleted) {
                    return const SizedBox.shrink();
                  }
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: questionControllers[qIndex],
                            onChanged: (value) =>
                                question.question = value.trim(),
                            decoration:
                                const InputDecoration(labelText: 'Pertanyaan'),
                          ),
                          Column(
                            children: List.generate(
                              question.options.length,
                              (optIndex) => Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: optionControllers[qIndex]
                                          [optIndex],
                                      onChanged: (value) {
                                        question.options[optIndex] =
                                            value.trim();
                                        question.answer = value.trim();
                                        setState(() {});
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Opsi ${optIndex + 1}'),
                                    ),
                                  ),
                                  Radio<String>(
                                    value: question.options[optIndex],
                                    groupValue: question.answer,
                                    onChanged: (value) =>
                                        setAnswer(qIndex, value!),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  question.options.add('');
                                  setState(() {});
                                },
                                child: const Text('Tambah Opsi'),
                              ),
                              if (question.options.length > 2)
                                TextButton(
                                  onPressed: () {
                                    question.options.removeLast();
                                    setState(() {});
                                  },
                                  child: const Text('Hapus Opsi'),
                                ),
                            ],
                          ),
                          TextField(
                            controller: scoreControllers[qIndex],
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              question.score = int.tryParse(value) ?? 0;
                            },
                            decoration:
                                const InputDecoration(labelText: 'Skor'),
                          ),
                          if (questions.length > 1)
                            TextButton(
                              onPressed: () => removeQuestion(qIndex),
                              child: const Text('Hapus Pertanyaan'),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ElevatedButtonGlobal(
                text: 'Tambah Pertanyaan',
                onPressed: () {
                  setState(() {
                    questionControllers.add(TextEditingController());
                    optionControllers.add([
                      TextEditingController(),
                      TextEditingController(),
                    ]);
                    scoreControllers.add(TextEditingController());
                    questions.add(QuestionModel(
                      question: '',
                      options: ['', ''],
                      answer: '',
                      score: 0,
                    ));
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButtonGlobal(
                bgColors: Colors.green,
                text: isEdit ? 'Update Ujian' : 'Simpan Ujian',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (questions.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Setidaknya harus ada 1 pertanyaan')),
                      );
                      return;
                    }

                    if (isEdit) {
                      for (var question in questions) {
                        if (question.score == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Skor pertanyaan harus diisi')),
                          );
                          return;
                        }
                      }
                      await controller.updateExam(
                        examId,
                        _titleController.text,
                        _descriptionController.text,
                        _startDateController.text,
                        int.parse(_durationController.text),
                        questions,
                        deletedQuestions,
                      );
                    } else {
                      for (var question in questions) {
                        if (question.score == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Skor pertanyaan harus diisi')),
                          );
                          return;
                        }
                      }
                      await controller.addExam(
                        _titleController.text,
                        _descriptionController.text,
                        _startDateController.text,
                        int.parse(_durationController.text),
                        questions,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
