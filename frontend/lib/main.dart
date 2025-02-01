import 'package:flutter/material.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/controller/home_controller.dart';
import 'package:frontend/screen/auth/login_screen.dart';
import 'package:frontend/screen/auth/regist_screen.dart';
import 'package:frontend/screen/home/admin/admin_home_screen.dart';
import 'package:frontend/screen/home/admin/edit_upload_exams_screen.dart';
import 'package:frontend/screen/home/admin/edit_upload_materials_screen.dart';
import 'package:frontend/screen/home/exam/exam_screen.dart';
import 'package:frontend/screen/home/exam/full_exam_screen.dart';
import 'package:frontend/screen/home/exam/list_exam_screen.dart';
import 'package:frontend/screen/home/exam/only_read_exam_screen.dart';
import 'package:frontend/screen/home/grade_screen.dart';
import 'package:frontend/screen/home/materials/full_materials_screen.dart';
import 'package:frontend/screen/home/materials/list_materials_screen.dart';
import 'package:frontend/screen/home/siswa/siswa_home_screen.dart';
import 'package:frontend/screen/splashScreen/splash_screen.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  Get.put(AuthController());
  Get.put(HomeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/homeAdmin', page: () => AdminHomeScreen()),
        GetPage(name: '/homeSiswa', page: () => SiswaHomeScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/regist', page: () => const RegistScreen()),
        GetPage(name: '/materials', page: () => ListMaterialsScreen()),
        GetPage(
            name: '/createMaterials', page: () => const EditUploadMaterialsScreen()),
        GetPage(name: '/fullMaterials', page: () => FullMaterialsScreen()),
        GetPage(name: '/grade', page: () => GradeScreen()),
        GetPage(name: '/examsList', page: () => ListExamScreen()),
        GetPage(name: '/createExams', page: () => const EditUploadExamsScreen()),
        GetPage(name: '/fullExams', page: () => FullExamScreen()),
        GetPage(name: '/exams', page: () => ExamScreen()),
        GetPage(name: '/examsRead', page: () => OnlyReadExamScreen()),
      ],
      title: 'E Learing',
    );
  }
}
