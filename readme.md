## E Learning App

Ini adalah FullStack Aplikasi E learning dengan Menggunakan **LARAVEL** sebagai Backend dan **Flutter** sebagai FrontEnd.

## Instalasi Laravel

> [!IMPORTANT]
> - Pastikan menggunakan PHP versi 8.x keatas
> - Composer
> - MySql atau Database Lainnya

Ketika ingin melakukan instalasi laravel pastikan anda sudah berada di directory ```backend/```

1.Clone Repository
```
git clone https://github.com/Denuvo33/E-Learning-App.git
```
2.Install dependensi menggunakan composer
```
composer install
```
3.Salin dan ganti nama ```backend/.env.example``` menjadi ```.env``` dan sesuaikan konfigurasi dengan ```mysql``` atau db lainnya.

4.jalankan migrasi untuk membuat tabel-tabel database, pastikan database ```e_learning``` sudah dibuat di MySQL/
```
php artisan migrate
```

5.jalankan server dengan
```
php artisan serve
```
jika ingin membuat user dummy untuk pertama kalinya anda dapat mengedit langsung database table ```users``` dengan field ini
```
name;
email;
password;
role;
```
atau jika ingin lebih cepat anda dapat melakukan Seeder dengan command ini
```
php artisan db:seed --class=UserSeeder
```
## Flutter

> [!IMPORTANT]
> - Pastikan menggunakan Flutter 3.x keatas

Ketika ingin menjalakan Flutter pastikan anda sudah berada di directory ```frontend/```

1.Jalankan command ini untuk membersihkan dan menjalankan Flutter
```
flutter clean
flutter pub get
flutter run
```
2.jika menjalankan aplikasi dari emulator pastikan url seperti ini ```10.0.2.2:8000``` atau mungkin dapat berbeda. jika menjalankan dari physical device pastikan untuk mendapat ip dri jaringan anda dengan cara buka **CMD** lalu ketik 
```ipconfig``` dan copy IPv4 Address. . . . . . . . . . . 
dan ganti variable ```_baseUrl``` di ```frontend/lib/service/api_service.dart/``` menjadi ip anda dengan contoh ip addres milik anda adalah 192.168.1.100 make value di ```_baseUrl``` adalah ```http://192.168.1.100:8000/api```

## Route 
    Harus menyertakan token dalam Authorization header.

    POST /logout
        Mengeluarkan pengguna dari sistem dengan menghapus token.

    GET /grades/{email}
        Mendapatkan daftar nilai berdasarkan email pengguna.

    GET /materials/download/{id}
        Mengunduh materi berdasarkan id.

Routes untuk Siswa

    GET /materials
        Menampilkan daftar semua materi pembelajaran.

    GET /exams/student
        Menampilkan daftar ujian yang bisa diakses oleh siswa.

    POST /grades
        Menyimpan nilai siswa setelah mengikuti ujian.

    GET /exams/{id}
        Menampilkan detail ujian berdasarkan id.


Rute yang Hanya Bisa Diakses oleh Admin (role:admin)

    Selain autentikasi, hanya pengguna dengan peran admin yang bisa mengakses rute ini.

    apiResource('materials')
        Mengelola materi pembelajaran (CRUD).
        Admin dapat: menambah, memperbarui, dan menghapus materi.

    apiResource('exams')
        Mengelola ujian (CRUD).
        Admin dapat: membuat, mengedit, melihat, dan menghapus ujian.

    GET /grades
        Mendapatkan semua nilai siswa.

    apiResource('exams/{exam}/questions')
        Mengelola pertanyaan dalam ujian tertentu (CRUD).

    PUT /exams/{exam}/questions/{question}
        Memperbarui pertanyaan tertentu dalam ujian.

> [!CAUTION]
> Beberapa Emulator tidak dapat mendownload file dri Aplikasi karna beberapa hal.
> Gunakan Physical Device jika emulator tidak dapat mendownload file/materi yg tersedia (jangan lupa mengganti ipnya).
