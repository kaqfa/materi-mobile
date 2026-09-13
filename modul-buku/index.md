---
title: 'Pemrograman Mobile dengan Flutter'
description: 'Pengantar bertahap pengembangan aplikasi mobile lintas platform dengan Flutter dan Dart, dari dasar bahasa sampai rilis ke Google Play Store.'
author: 'Kaqfa'
coverImage: '/flutter-book-cover.png'
publishDate: 2024-09-18
updateDate: 2026-09-13
category: 'Programming'
difficulty: 'intermediate'
tags: ['flutter', 'dart', 'mobile', 'programming']
accessLevel: 'free'
estimatedReadTime: 10
chapters: 14
bookType: 'multi-chapter'
status: 'published'
prerequisites:
  - 'Pemrograman berorientasi objek: class, pewarisan, dan interface'
  - 'Struktur data dasar: list, map, dan iterasi'
  - 'Konsep dasar basis data relasional'
learningOutcomes:
  - 'Menulis program Dart yang idiomatik: tipe data, null safety, async, dan generics'
  - 'Menyusun antarmuka dengan sistem widget, layout responsif, Material 3, dan custom widget'
  - 'Mengelola state aplikasi dari setState sampai Provider, termasuk shared_preferences'
  - 'Menyimpan data lokal dengan SQLite dan menerapkan pola offline-first'
  - 'Mengonsumsi REST API: serialisasi JSON, autentikasi token, dan caching'
  - 'Menguji aplikasi dengan unit, widget, dan integration test, lalu memprofil performa dan merilis aplikasi ke Play Store'
---

# Pemrograman Mobile dengan Flutter

Buku ini menuntun pembaca membangun aplikasi mobile untuk Android dan iOS dari nol menggunakan Flutter. Materi disusun bertahap: dimulai dari bahasa Dart, lalu sistem widget dan antarmuka, state management, penyimpanan data dan integrasi API, sampai pengujian, optimasi performa, dan rilis aplikasi.

Seluruh bab implementasi memakai satu aplikasi acuan yang sama, semacam pencatat tugas dan jadwal belajar (Task/Study Tracker). Aplikasi ini tumbuh dari bab ke bab: awalnya hanya antarmuka statis, kemudian diberi state, penyimpanan lokal, koneksi ke API, dukungan offline, pengujian, dan akhirnya dibangun versi rilisnya. Dengan satu aplikasi yang terus berkembang, pembaca melihat bagaimana setiap konsep baru menempel pada kode yang sudah dikenal, bukan pada contoh yang berganti-ganti.

Buku ini jujur soal cakupannya. Fokus utamanya adalah state management dengan Provider, penyimpanan lokal, REST API, pengujian, fitur perangkat umum seperti kamera dan lokasi, optimasi performa, dan deployment ke Play Store. Riverpod dan BLoC tidak diajarkan sebagai materi inti, tetapi dibahas sebagai pembanding berkode di bab 7 agar pembaca punya dasar memilih saat aplikasinya tumbuh. Push notification dan internasionalisasi tidak dibahas sama sekali.

## Prasyarat

Pembaca diasumsikan sudah pernah menulis program berorientasi objek dan memahami struktur data dasar. Pengalaman membuat aplikasi CRUD sederhana akan membantu, tetapi tidak wajib. Pengetahuan Android atau iOS native tidak dibutuhkan; bagian yang relevan akan dijelaskan saat muncul.

## Peta Belajar

Empat belas bab membentuk keseluruhan buku. Daftar lengkap bab beserta tautannya tersedia pada daftar isi di bawah halaman ini. Ringkasan fasenya sebagai berikut.

| Fase                   | Bab   | Fokus                                                                                |
| ---------------------- | ----- | ------------------------------------------------------------------------------------ |
| Bahasa Dart            | 1-2   | Sintaks Dart, pemodelan data, async, dan generics                                    |
| Pondasi Flutter dan UI | 3-6   | Widget tree, layout, build system, Material 3, custom widget                         |
| State dan data         | 7-10  | setState hingga Provider, penyimpanan lokal, REST API, SQLite dan pola offline-first |
| Kualitas sampai rilis  | 11-14 | Pengujian, fitur perangkat, optimasi performa, deployment                            |

Bab 1 dan 2 memakai contoh kecil berbasis teks agar fokus tertuju pada bahasanya. Sejak bab 3, pembaca bekerja pada aplikasi Tracker yang sama sampai selesai.

## Cara Menggunakan Buku Ini

Baca secara berurutan pada penjelajahan pertama; urutan bab mengikuti ketergantungan konsep, dan bab-bab akhir memakai kode yang dibangun di bab sebelumnya. Setiap bab berisi penjelasan konsep, contoh terbimbing langkah demi langkah, dan ringkasan. Kerjakan contoh dengan mengetik sendiri, bukan menyalin-tempel, karena sebagian besar pembelajaran terjadi ketika compiler menolak kode Anda.

Setiap bab ditutup blok "Bekerja dengan AI di Bab Ini": apa yang wajar didelegasikan ke AI untuk topik itu, apa yang sebaiknya Anda tulis sendiri, dan satu latihan menilai keluaran AI. Blok itu tidak mengatur kapan Anda boleh memakai AI, karena buku bisa dibaca kapan saja; aturan penilaian ada di LMS.

Siapkan lingkungan kerja sejak awal: Flutter SDK, editor seperti VS Code atau Android Studio, dan emulator atau perangkat fisik untuk menjalankan aplikasi. Instruksi instalasi lengkap ada di dokumentasi resmi Flutter. Tiap bab diakhiri latihan konsep ringan untuk mengecek pemahaman; tugas terstruktur mata kuliah dikerjakan di LMS, bukan di buku ini.

## Baseline Versi

Contoh kode pada buku ini ditulis terhadap baseline berikut (tanggal baseline: 3 September 2026):

- Flutter stable 3.47.x dengan versi Dart bawaannya. Verifikasi dengan `flutter --version`.
- Material 3 aktif secara bawaan, sesuai perilaku Flutter modern.
- Konfigurasi build Android memakai Gradle Kotlin DSL (`.kts`), sesuai template proyek Flutter terkini.
- API level Android mengikuti variabel template proyek (`flutter.compileSdkVersion`, `flutter.targetSdkVersion`, `flutter.minSdkVersion`) alih-alih angka yang dihardcode, sehingga contoh tetap valid ketika template diperbarui.
- Untuk rilis ke Play Store: kebijakan Google mewajibkan target API 36 (Android 16) bagi pembaruan aplikasi sejak 31 Agustus 2026. Contoh pada bab deployment mematuhi kebijakan tersebut melalui variabel template.

Nomor versi pada contoh dapat menua. Bila perilaku berbeda dari yang ditulis, jadikan changelog dokumentasi resmi sebagai rujukan akhir.

## Referensi Utama

- Dokumentasi Flutter: https://docs.flutter.dev
- API reference Flutter dan Dart: https://api.flutter.dev
- Dokumentasi Dart: https://dart.dev
- Dokumentasi Android untuk pengembang: https://developer.android.com
- Katalog paket publikasi Dart/Flutter: https://pub.dev

Buku ini tidak menggantikan dokumentasi resmi, melainkan menyusun jalannya secara berurutan untuk pemula.
