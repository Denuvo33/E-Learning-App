class MaterialsModel {
  int id;
  String judul, deskripsi;
  String? file;
  String? createdAt;

  MaterialsModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.createdAt,
    required this.file,
  });

  factory MaterialsModel.fromJson(Map<String, dynamic> json) {
    return MaterialsModel(
      id: json['id'] as int,
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      createdAt: json['created_at'],
      file: json['file_url'],
    );
  }
}
