import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:frontend/model/exam_model.dart';
import 'package:frontend/model/grade_model.dart';
import 'package:frontend/model/materials_model.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ApiService {
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final dio.Dio _dio = dio.Dio();

  //Regist
  Future<void> regist(context, name, email, password) async {
    try {
      final response = await _dio.post('$_baseUrl/register',
          options: dio.Options(
              contentType: 'application/json',
              validateStatus: (status) {
                return status! < 500;
              }),
          data: {
            'name': name,
            'email': email,
            'password': password,
            'role': 'siswa'
          });
      if (response.statusCode == 201) {
        StorageService.setString('token', response.data['token']);
        StorageService.setString('role', response.data['role']);
        StorageService.setString('name', response.data['name']);
        StorageService.setString('email', response.data['email']);
        if (response.data['role'] == 'siswa') {
          Get.offAllNamed('/homeSiswa');
        } else {
          Get.offAllNamed('/homeAdmin');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Berhasil mendaftar'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(response.data['errors']),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Email sudah terdaftar'),
        ),
      );
      debugPrint('error: $e');
    }
  }

  //Login
  Future<void> login(context, email, password) async {
    debugPrint('login with email $email password $password');
    try {
      final response = await _dio.post('$_baseUrl/login',
          options: dio.Options(
              contentType: 'application/json',
              validateStatus: (status) {
                return status! < 500;
              }),
          data: {'email': email, 'password': password});
      if (response.statusCode == 200) {
        StorageService.setString('token', response.data['token']);
        StorageService.setString('role', response.data['role']);
        StorageService.setString('name', response.data['name']);
        StorageService.setString('email', response.data['email']);
        debugPrint(
            'role: ${response.data['role']}, name: ${response.data['name']}, token: ${response.data['token']}');
        if (response.data['role'] == 'siswa') {
          Get.offAllNamed('/homeSiswa');
        } else {
          Get.offAllNamed('/homeAdmin');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Berhasil login'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(response.data['message']),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString()),
        ),
      );
      debugPrint('error: $e');
    }
  }

  //Logout
  Future<void> logout() async {
    try {
      final response = await _dio.post(
        '$_baseUrl/logout',
        options: dio.Options(
            headers: {
              'Authorization': 'Bearer ${StorageService.getString('token')}',
            },
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      if (response.statusCode == 200) {
        StorageService.clear();
        Get.offAllNamed('/login');
      }
    } catch (e) {
      debugPrint('error: $e');
    }
  }

  // Upload Material
  Future<void> uploadMaterial(BuildContext context, String judul,
      String deskripsi, File? file, bool isEdit, int id) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'judul': judul,
        'deskripsi': deskripsi,
        'file': null,
        if (file != null)
          'file': await dio.MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last),
      });
      final response = isEdit
          ? await _dio.post(
              '$_baseUrl/materials/$id',
              data: file != null
                  ? dio.FormData.fromMap({
                      'judul': judul,
                      'deskripsi': deskripsi,
                      'file': await dio.MultipartFile.fromFile(
                        file.path,
                        filename: file.path.split('/').last,
                      ),
                      '_method': 'PUT',
                    })
                  : {
                      'judul': judul,
                      'deskripsi': deskripsi,
                      '_method': 'PUT',
                    },
              options: dio.Options(
                headers: {
                  'Authorization':
                      'Bearer ${StorageService.getString('token')}',
                },
                contentType:
                    file != null ? 'multipart/form-data' : 'application/json',
                validateStatus: (status) => status! < 500,
              ),
            )
          : await _dio.post('$_baseUrl/materials',
              data: formData,
              options: dio.Options(
                headers: {
                  'Authorization':
                      'Bearer ${StorageService.getString('token')}',
                },
                contentType: 'multipart/form-data',
                validateStatus: (status) => status! < 500,
              ));

      if (isEdit ? response.statusCode == 200 : response.statusCode == 201) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Materi berhasil diunggah!'),
          ),
        );
        Get.back();
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content:
                Text(response.data['message'] ?? 'Gagal mengunggah materi'),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Error: $e'),
        ),
      );
      debugPrint('Error: $e');
    }
  }

  Future<List<MaterialsModel>> fetchMaterials() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/materials',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer ${StorageService.getString('token')}',
          },
          validateStatus: (status) => status! < 500,
        ),
      );
      if (response.statusCode == 200) {
        return response.data
            .map<MaterialsModel>((json) => MaterialsModel.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteMaterials(int id, context) async {
    try {
      final response = await _dio.delete(
        '$_baseUrl/materials/$id',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer ${StorageService.getString('token')}',
          },
          validateStatus: (status) => status! < 500,
        ),
      );
      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berhasil menghapus materi')));
        Get.back();
      }
    } catch (e) {
      debugPrint('error: $e');
    }
  }

  // Download File
  Future<String?> downloadFile(String fileUrl, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$fileName';

      await _dio.download(
        '$_baseUrl/materials/download/$fileUrl',
        options: dio.Options(
          responseType: dio.ResponseType.bytes,
          headers: {
            'Authorization': 'Bearer ${StorageService.getString('token')}',
            'Connection': 'Keep-Alive',
            'Accept-Encoding': 'gzip, deflate, br',
          },
          sendTimeout: const Duration(seconds: 30),
        ),
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint('${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );
      debugPrint('File download successfully');
      return filePath;
    } catch (e) {
      debugPrint('Error  : $e');
      return null;
    }
  }

  Future<List<GradeModel>> grade(String email) async {
    try {
      final response = await _dio.get(
        StorageService.getString('role') == 'siswa'
            ? '$_baseUrl/grades/$email'
            : '$_baseUrl/grades',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer ${StorageService.getString('token')}',
          },
          validateStatus: (status) => status! < 500,
        ),
      );
      if (response.statusCode == 200) {
        return response.data
            .map<GradeModel>((json) => GradeModel.fromJson(json))
            .toList();
      } else {
        debugPrint('error: ${response.data['message']}');
      }
      return [];
    } catch (e) {
      debugPrint('error: $e');
      return [];
    }
  }

  Future<bool> createExam(ExamModel exam) async {
    try {
      var examData = exam.toJson();
      examData.remove('id');
      examData['questions'].forEach((q) => q.remove('id'));
      debugPrint('sending data $examData');

      final response = await _dio.post(
        '$_baseUrl/exams',
        data: examData,
        options: dio.Options(
          contentType: 'application/json',
          headers: {
            'Authorization': 'Bearer ${StorageService.getString('token')}',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 201) {
        debugPrint('Exam created successfully');
        return true;
      } else {
        debugPrint('Error: ${response.data['message']}');
        return false;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  //Update Exam
  Future<bool> updateExam(ExamModel exam) async {
    try {
      var examData = exam.toJson();
      debugPrint('sending data $examData');

      examData['questions'].forEach((q) {
        if (q['id'] == null) {
          q.remove('id');
        }
        if (q['_delete'] == true) {
          q['_delete'] = true;
        }
      });

      final response = await _dio.put(
        '$_baseUrl/exams/${exam.id}',
        data: examData,
        options: dio.Options(
          contentType: 'application/json',
          headers: {
            'Authorization': 'Bearer ${StorageService.getString('token')}',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('Exam updated successfully');
        return true;
      } else {
        debugPrint('Error: ${response.data['message']}');
        return false;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  //Fetch Exams
  Future<List<ExamModel>> fetchExams() async {
    try {
      final response = await _dio.get(
        StorageService.getString('role') == 'siswa'
            ? '$_baseUrl/exams/student'
            : '$_baseUrl/exams',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer ${StorageService.getString('token')}',
          },
          validateStatus: (status) => status! < 500,
        ),
      );
      if (response.statusCode == 200) {
        return response.data
            .map<ExamModel>((json) => ExamModel.fromJson(json))
            .toList();
      } else {
        debugPrint('error: ${response.data['message']}');
        return [];
      }
    } catch (e) {
      debugPrint('error: $e');
      return [];
    }
  }

  //Delete Exam
  Future<bool> deleteExam(int id) async {
    try {
      final response = await _dio.delete(
        '$_baseUrl/exams/$id',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer ${StorageService.getString('token')}',
          },
          validateStatus: (status) => status! < 500,
        ),
      );
      if (response.statusCode == 200) {
        debugPrint('Exam deleted successfully');
        return true;
      } else {
        debugPrint('Error: ${response.data['message']}');
        return false;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  //Submit Grade
  Future<bool> submitGrade({
    required int examId,
    required int score,
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/grades',
        data: {
          'email': email,
          'score': score,
          'exam_id': examId,
        },
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer ${StorageService.getString('token')}',
          },
        ),
      );

      if (response.statusCode == 201) {
        debugPrint('Grade submitted successfully');
        return true;
      } else {
        debugPrint('Failed to submited Grade');
        return false;
      }
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    }
  }

  Future<ExamModel?> getSpesificExam(int id) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/exams/$id',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer ${StorageService.getString('token')}',
          },
          validateStatus: (status) => status! < 500,
        ),
      );
      if (response.statusCode == 200) {
        return ExamModel.fromJson(response.data);
      } else {
        debugPrint('error: ${response.data['message']}');
        return null;
      }
    } catch (e) {
      debugPrint('Error :$e');
      return null;
    }
  }
}
