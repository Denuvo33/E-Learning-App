import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/model/exam_model.dart';
import 'package:frontend/model/grade_model.dart';
import 'package:frontend/model/materials_model.dart';
import 'package:frontend/model/question_model.dart';
import 'package:frontend/service/api_service.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

class HomeController extends GetxController {
  var selectedFile = Rx<File?>(null);
  final ApiService api = ApiService();
  var materials = <MaterialsModel>[].obs;
  var grade = <GradeModel>[].obs;
  var isLoading = false.obs;
  var exam = <ExamModel>[].obs;

  // Pick file to upload to server
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'pptx'],
    );

    if (result != null && result.files.single.path != null) {
      selectedFile.value = File(result.files.single.path!);
    }
  }

  // Upload materials to server
  Future<void> uploadMaterials(
      context, String judul, String deskripsi, isEdit, int index) async {
    try {
      Get.defaultDialog(
        title: 'Upload Materi',
        content: const CircularProgressIndicator(),
      );
      await api.uploadMaterial(context, judul, deskripsi, selectedFile.value,
          isEdit, materials[index].id);
      Get.back();
      getMaterials();
    } catch (e) {
      debugPrint('error: $e');
    }
  }

  Future<void> deleteMaterials(int index, context) async {
    Get.defaultDialog(
        title: 'Hapus Materi', content: const CircularProgressIndicator());
    await api.deleteMaterials(materials[index].id, context);
    Get.back();
    getMaterials();
  }

  // Get materials from server
  Future<void> getMaterials() async {
    try {
      isLoading(true);
      final data = await api.fetchMaterials();
      materials.value = data;
      isLoading(false);
    } catch (e) {
      isLoading(false);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Gagal Mengambil Materi'),
        ),
      );
      debugPrint('error: $e');
    }
  }

  // Download file
  Future<void> downloadMaterialFile(int materialId, String fileName) async {
    try {
      final filePath = await api.downloadFile(materialId.toString(), fileName);

      if (filePath != null) {
        OpenFile.open(filePath);
        Get.snackbar('Success', 'File downloaded successfully!');
      } else {
        Get.snackbar('Error', 'Failed to download file.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {}
  }

  //Get Grade
  Future<void> getGrade() async {
    isLoading(true);
    grade.value = await api.grade(StorageService.getString('email'));
    isLoading(false);
  }

  //Get Exams
  Future<void> getExams() async {
    isLoading(true);
    exam.value = await api.fetchExams();
    isLoading(false);
  }

  //Submit Exam
  Future<void> addExam(
    String title,
    String description,
    String startDate,
    int duration,
    List<QuestionModel> questions,
  ) async {
    Get.defaultDialog(
        title: 'Loading', content: const CircularProgressIndicator());

    var newExam = ExamModel(
      title: title,
      description: description,
      startDate: startDate,
      duration: duration,
      questions: questions.where((q) => !q.isDeleted).toList(),
    );

    bool success = await api.createExam(newExam);
    Get.back();

    if (success) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Berhasil menambahkan ujian'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      await getExams();
      Get.back();
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Gagal menambahkan ujian'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  //Update Exam
  Future<void> updateExam(
    int examId,
    String title,
    String description,
    String startDate,
    int duration,
    List<QuestionModel> questions,
    List<QuestionModel> deletedQuestions,
  ) async {
    Get.defaultDialog(
        title: 'Loading', content: const CircularProgressIndicator());

    var allQuestions = [...questions, ...deletedQuestions];

    var updatedExam = ExamModel(
      id: examId,
      title: title,
      description: description,
      startDate: startDate,
      duration: duration,
      questions: allQuestions,
    );

    bool success = await api.updateExam(updatedExam);
    Get.back();

    if (success) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Berhasil memperbarui ujian'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      await getExams();
      Get.back();
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Gagal memperbarui ujian'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  //Delete Exam
  Future<void> deleteExam(int examId) async {
    Get.defaultDialog(
        title: 'Loading', content: const CircularProgressIndicator());
    bool success = await api.deleteExam(examId);
    Get.back();
    if (success) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Berhasil menghapus ujian'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      await getExams();
      Get.back();
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus ujian'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  //Submit Grade
  Future<bool> submitGrade(int examId, int score) async {
    try {
      final response = await api.submitGrade(
        examId: examId,
        score: score,
        email: StorageService.getString('email'),
      );

      if (response) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  //Get Specific Exam
  Future<ExamModel?> getSpesificExam(int id) async {
    return await api.getSpesificExam(id);
  }
}
