import 'package:flutter/material.dart';
import 'package:frontend/controller/home_controller.dart';
import 'package:frontend/global/elevated_button_global.dart';
import 'package:get/get.dart';

class EditUploadMaterialsScreen extends StatefulWidget {
  const EditUploadMaterialsScreen({super.key});

  @override
  State<EditUploadMaterialsScreen> createState() =>
      _EditUploadMaterialsScreenState();
}

class _EditUploadMaterialsScreenState extends State<EditUploadMaterialsScreen> {
  late bool isEdit;
  late int index;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  var controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    isEdit = Get.arguments?['isEdit'] ?? false;
    index = Get.arguments?['index'] ?? 0;
    if (isEdit) {
      _title.text = controller.materials[index].judul;
      _desc.text = controller.materials[index].deskripsi;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _desc.dispose();
    controller.selectedFile.value = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Materi' : 'Tambahkan Materi'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Form(
            key: _form,
            child: Obx(
              () => Column(
                children: [
                  TextFormField(
                    controller: _title,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Judul Materi')),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul Materi Harus Diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _desc,
                    maxLines: 8,
                    minLines: 1,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), label: Text('Deskripsi')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi Harus Diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    child: Container(
                      margin: const EdgeInsets.all(7),
                      child: ListTile(
                        subtitle: controller.selectedFile.value == null
                            ? const Text(
                                'Hanya mendukung type file doc,docx,pdf,pptx (max 2MB)')
                            : null,
                        title: Text(controller.selectedFile.value != null
                            ? controller.selectedFile.value!.path
                                .split('/')
                                .last
                            : 'Tambahkan File Materi'),
                        trailing: controller.selectedFile.value != null
                            ? IconButton(
                                onPressed: () {
                                  controller.selectedFile.value = null;
                                },
                                icon: const Icon(Icons.delete))
                            : IconButton(
                                onPressed: () {
                                  controller.pickFile();
                                },
                                icon: const Icon(Icons.add)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButtonGlobal(
                    text: 'Kirim',
                    onPressed: () async {
                      if (_form.currentState!.validate()) {
                        Get.defaultDialog(
                            content: const CircularProgressIndicator());
                        await controller.uploadMaterials(
                            context, _title.text, _desc.text, isEdit, index);
                        Get.back();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
