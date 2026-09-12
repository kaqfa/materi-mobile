---
parentBook: 'pemrograman-berorientasi-objek'
chapterNumber: 16
chapterSlug: 'spesial-01-panduan-npm-tsconfig'
title: 'Panduan NPM & Konfigurasi TypeScript'
description: 'Referensi lengkap npm dan package.json, konfigurasi tsconfig.json untuk OOP TypeScript, strict mode options, dan best practices setup project'
estimatedReadTime: 25
objectives:
  - 'Memahami struktur dan field penting dalam package.json'
  - 'Mengkonfigurasi tsconfig.json dengan strict mode untuk OOP TypeScript'
  - 'Menjelaskan fungsi setiap compiler option yang relevan (noImplicitAny, strictPropertyInitialization, dll)'
  - 'Membuat struktur project TypeScript yang sesuai standar industri'
nextChapter: 'spesial-02-tutorial-electron'
prevChapter: '15-review-persiapan-capstone'
status: 'published'
accessLevel: 'free'
---


> **Mata Kuliah:** Pemrograman Berorientasi Objek
> **Minggu:** Spesial / Ekstra
> **Bagian:** Pengayaan Dasar Lingkungan Kerja
> **Bahasa:** TypeScript 5.x

---

## Capaian Pembelajaran Modul

Setelah mempelajari modul referensi ini, mahasiswa mampu:
1. Memahami peran Node Package Manager (npm) dalam pengembangan software modern.
2. Menginisialisasi proyek Node.js dan mengelola file `package.json`.
3. Menginstal, memperbarui, dan menghapus dependency.
4. Membuat dan mengonfigurasi file `tsconfig.json` untuk proyek TypeScript dengan tingkat ketat (strict mode) yang sesuai baku mutu OOP.
5. Memanfaatkan npm scripts untuk otomatisasi build dan run program.

---

## Prasyarat

- Instalasi Node.js terbaru (minimal LTS).
- Instalasi global TypeScript (`npm install -g typescript`).
- Pemahaman dasar terminal/command prompt.

---

## Daftar Isi

- [1. Pendahuluan](#1-pendahuluan)
- [2. Landasan Konsep](#2-landasan-konsep)
- [3. Memahami `package.json`](#3-memahami-packagejson)
- [4. Memahami `tsconfig.json`](#4-memahami-tsconfigjson)
- [5. Studi Kasus Komprehensif](#5-studi-kasus-komprehensif)
- [6. Kesalahan Umum & Best Practices](#6-kesalahan-umum--best-practices)
- [7. Ringkasan](#7-ringkasan)
- [8. Latihan Mandiri](#8-latihan-mandiri)

---

## 1. Pendahuluan

Dalam pengembangan aplikasi berorientasi objek menggunakan TypeScript, kita jarang menulis semuanya dari nol (from scratch). Sama seperti seorang arsitek yang membutuhkan beton, paku, dan kayu yang sudah diproduksi, programmer menggunakan **library** dan **tools** buatan komunitas.

NPM (Node Package Manager) adalah kunci untuk mengelola "bahan bangunan" tersebut. Di modul ekstra ini, kita akan membahas cara menyiapkan "lahan kerja" (proyek), mengelola alat dengan `package.json`, dan mengatur aturan arsitektur bahasa yang ketat melalui `tsconfig.json`.

---

## 2. Landasan Konsep

### 2.1 Apa itu NPM?
NPM adalah manajer paket (package manager) bawaan Node.js. NPM bertugas:
- **Registry:** Menyediakan jutaan library public yang bisa didownload.
- **Workflow Tool:** Menyediakan CLI (Command Line Interface) untuk instalasi library dan skrip otomatisasi.

### 2.2 Dependensi vs Dev-Dependensi
- **Dependencies (`dependencies`)**: Paket yang dibutuhkan agar aplikasi bisa berjalan di produksi (misal: framework web, konektor database).
- **Dev-Dependencies (`devDependencies`)**: Paket yang hanya digunakan saat masa pengembangan (development) seperti *compiler* TypeScript, testing framework, dan linter.

### 2.3 Perbandingan Lintas Bahasa

Hampir semua ekosistem bahasa pemrograman modern memiliki manajer paket dan cara mengonfigurasi proyek serupa.

| Aspek | Node / TypeScript | Java | Dart/Flutter | PHP |
|-------|------------------|------|--------------|-----|
| Package Manager | `npm` (atau `yarn` / `pnpm`) | `Maven` / `Gradle` | `pub` | `Composer` |
| File Metadata | `package.json` | `pom.xml` / `build.gradle` | `pubspec.yaml`| `composer.json` |
| Local Folder | `node_modules/` | `~/.m2/repository` | `.dart_tool/` | `vendor/` |

> 🔄 **Perbandingan:** Jika Anda sudah terbiasa dengan `composer` di PHP saat membuat web sebelumnya, maka transisi ke `npm` akan terasa sangat mirip. `npm install` mirip dengan `composer install`.

---

## 3. Memahami `package.json`

File `package.json` adalah "KTP" dari proyek Node.js. Ia menyimpan metadata proyek (nama, versi, author) dan daftar pustaka yang dibutuhkan.

### 3.1 Inisialisasi Proyek

Untuk membuat `package.json`, buka terminal di folder proyek dan jalankan:
```bash
npm init -y
```

### 3.2 Menambah Dependency

**Install standard dependency (tersimpan di `dependencies`):**
```bash
npm install lodash
```

**Install development dependency (tersimpan di `devDependencies`):**
```bash
npm install -D typescript @types/node
```

> 💡 **Insight:** Package `@types/...` sangat penting di TypeScript karena menyediakan informasi tipe (Type Definitions) untuk library yang pada asalnya murni ditulis dengan JavaScript biasa.

### 3.3 NPM Scripts

Elemen `scripts` dalam `package.json` adalah shortcut untuk command CLI yang panjang.

```json
{
  "name": "pbo-proyek",
  "version": "1.0.0",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "ts-node src/index.ts"
  }
}
```
Anda tinggal menjalankan `npm run build` yang mana script ini akan memanggil `tsc` (TypeScript Compiler).

---

## 4. Memahami `tsconfig.json`

File `tsconfig.json` bertujuan mengatur **bagaimana** TypeScript harus dikonversi (di-compile) menjadi JavaScript dan tingkat kedisiplinan (strictness) yang diberlakukan sang compiler.

### 4.1 Inisialisasi

Pada root proyek, jalankan:
```bash
tsc --init
```
Ini akan otomatis menghasilkan `tsconfig.json` beserta penjelasannya.

### 4.2 Properti Penting `tsconfig.json` untuk PBO

Untuk mata kuliah PBO secara khusus kita menggunakan aturan kuat (*Strict mode*):

```json
{
  "compilerOptions": {
    "target": "ES2022",           // Target bahasa generasi akhir JavaScript
    "module": "CommonJS",         // Cara mengatur modul antarsistem
    "rootDir": "./src",           // Tempat Anda menaruh kode asli (*.ts)
    "outDir": "./dist",           // Tempat hasil kompilasi (*.js)
    
    // OOP Strictness
    "strict": true,               // MENYALAKAN SEMUA TYPE CHECKING KETAT
    "strictPropertyInitialization": true,  // Mencegah class property uninitialized
    "noImplicitAny": true,        // Wajib menentukan tipe data setiap variabel
    
    // Developer Experience
    "esModuleInterop": true,
    "skipLibCheck": true,         // Hindari mengecek lib pihak ketiga untuk mempercepat kompilasi
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],        // Folder/file apa yang wajib di-compile
  "exclude": ["node_modules"]     // Jangan compile library dari luar
}
```

> ⚠️ **Perhatian:** Sangat disarankan untuk memisahkan file `.ts` dan output file `.js`. Folder `src` untuk kode dasar Anda dan `dist` (atau `build`) untuk hasil JavaScript. Ini mencegah kekacauan dalam folder.

---

## 5. Studi Kasus Komprehensif

### 5.1 Deskripsi Masalah

Kita ingin membuat project sederhana berbasis class OOP ("Sistem Greet") yang menggunakan dependency eksternal `chalk` untuk mewarnai teks di terminal dan berjalan lancar menggunakan kompilasi otomatis.

### 5.2 Desain Solusi (Langkah Kerja)

**Langkah 1: Bentuk environment awal terminal/Shell**
```bash
mkdir hello-ts
cd hello-ts
npm init -y
npm install -D typescript @types/node ts-node
npx tsc --init
npm install chalk@4.1.2 
```
*(Catatan: kita menggunakan versi 4 untuk support commonJS)*

**Langkah 2: Set `tsconfig.json` sesuai standar PBO**
Buka `tsconfig.json` dan pastikan konfigurasi minimum seperti di *Section 4.2*.

**Langkah 3: Konfigurasi `package.json` scripts**
```json
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "ts-node src/index.ts"
  }
```

### 5.3 Implementasi Kelas (src/index.ts)

Buat folder `src` dan tambahkan `index.ts`.

```typescript
import chalk from "chalk";

class Greeter {
    // strictPropertyInitialization mewajibkan ada konstruktor/initial value untuk 'name'
    constructor(private name: string) {}

    public announce(): void {
        console.log(chalk.blue.bold(`[Sistem PBO] `) + chalk.green(`Halo, ${this.name}! Environment siap.`));
    }
}

// Eksekusi program
const app = new Greeter("Mahasiswa");
app.announce();
```

### 5.4 Analisis Hasil

Ketikkan `npm run build` di terminal.
Jika berhasil, akan muncul folder `dist` berisi `index.js`.
Selanjutnya dapat dijalankan manual dengan `npm run start` atau `node dist/index.js`.

---

## 6. Kesalahan Umum & Best Practices

### ❌ Anti-Pattern / Kesalahan Umum

- **Meng-commit `node_modules` ke dalam Git Repository.**
  File/folder di dalam `node_modules` besarnya bisa mencapai ratusan megabyte.
  *Solusi:* Ingat selalu membuat file `.gitignore` yang memuat list direktori `node_modules/`.

- **Mengganti konfigurasi Strict menjadi false agar "mudah" di-compile.**
  Banyak programmer mengubah `"strict": false` untuk lolos dari error saat awal belajar. Di mata kuliah PBO, ini berarti mematikan manfaat dari OOP itu sendiri yang mana sangat kental dengan *Type Checking*.
  
### ✅ Best Practice

- Selidiki error dari TypeScript dan fix pada kode Anda alih-alih merubah `tsconfig.json` agar memaafkan error tersebut.
- Pisahkan dependency aplikasi (`dependencies`) dan dependency terkait alat kompilasi (`devDependencies`). Selalu ikuti dengan standard yang berlaku.
- Minimalisir instalasi modul global (`npm install -g`). Lebih baik instal di dalam lokus environment project kecuali dirasa perlu untuk tools seperti `typescript`.

---

## 7. Ringkasan

- **`NPM`** adalah cara pengembang mendownload package dan menyebarkan kode eksternal.
- **`package.json`** bertugas mencatat modul/library apa saja yang sedang dipakai dan custom skrip CLI.
- **`tsconfig.json`** mengatur target kompilasi JavaScript dan mengatur berbagai restriksi kode strict untuk mendukung gaya deklarasi OOP yang mantap.
- Dengan standard `strict: true`, compiler memaksa kita menjadi programmer yang lebih sadar terkait inisialisasi Object dan tipe Data.

---

## 8. Latihan Mandiri

1. **Pertanyaan Konseptual:** Mengapa folder `node_modules/` tidak disarankan untuk disertakan langsung ketika melempar file kerja kepada rekan tim menggunakan flashdisk maupun via Git?
2. **Mini Exercise:** Coba install paket NPM berupa `date-fns` atau `moment`. Buat class `TimeFormatter` yang menerima parameter tanggal di constructor, mengembalikannya dalam format string yang elegan memakai pustaka tersebut.
3. **Analisis Konfigurasi:** Jika Anda memiliki setting `"outDir": "./build"` di dalam `tsconfig.json`, dan Anda melakukan perintah `tsc`, apa perubahan spesifik yang perlu disesuaikan pada script `"start": "node dist/index.js"` di dalam `package.json`?

---

## Referensi & Bacaan Lanjutan

- Panduan Resmi NPM: https://docs.npmjs.com/
- TSConfig Reference Manual: https://www.typescriptlang.org/tsconfig
