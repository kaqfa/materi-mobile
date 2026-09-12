---
parentBook: 'pemrograman-berorientasi-objek'
chapterNumber: 17
chapterSlug: 'spesial-02-tutorial-electron'
title: 'Tutorial Electron'
description: 'Panduan step-by-step membangun aplikasi desktop dengan Electron + TypeScript, mulai dari setup, main/renderer process, IPC communication, hingga packaging'
estimatedReadTime: 30
objectives:
  - 'Memahami arsitektur Electron: main process, renderer process, dan IPC'
  - 'Melakukan setup project Electron + TypeScript dengan Vite'
  - 'Mengimplementasikan IPC (Inter-Process Communication) antara main dan renderer'
  - 'Mengintegrasikan SQLite database di main process'
  - 'Melakukan packaging aplikasi Electron untuk distribusi'
nextChapter: null
prevChapter: 'spesial-01-panduan-npm-tsconfig'
status: 'published'
accessLevel: 'free'
---


> **Mata Kuliah:** Pemrograman Berorientasi Objek
> **Minggu:** Spesial / Ekstra
> **Bagian:** Pengayaan Ekosistem GUI Lanjut
> **Bahasa:** TypeScript 5.x, HTML, CSS

---

## Capaian Pembelajaran Modul

Setelah mempelajari modul tutorial ini, mahasiswa mampu:
1. Memahami arsitektur multiproses Electron (Main Process & Renderer Process).
2. Memahami peran jembatan Preload Script dan konsep *Context Isolation* demi keamanan aplikasi.
3. Menggunakan Inter-Process Communication (IPC) secara berorientasi objek untuk komunikasi asinkron antara UI dan sistem operasi.
4. Membuat, menyusun arsitektur (dengan TypeScript), dan menjalankan aplikasi berbasis desktop menggunakan Electron.
5. Membandingkan pendekatan GUI Electron dengan framework desktop konvensional.

---

## Prasyarat

- Modul `11-pengantar-gui-html-css-ts.md` dan modul tentang GUI/OOP Architecture.
- Pemahaman konfigurasi NPM & TypeScript (merujuk ke Modul Spesial NPM & Konfigurasi TypeScript).
- Pengalaman dasar menggunakan Terminal.

---

## Daftar Isi

- [1. Pendahuluan](#1-pendahuluan)
- [2. Landasan Konsep Electron](#2-landasan-konsep-electron)
- [3. Implementasi dalam TypeScript](#3-implementasi-dalam-typescript)
- [4. Studi Kasus Komprehensif (Aplikasi Todo Desktop)](#4-studi-kasus-komprehensif)
- [5. Perbandingan Lintas Bahasa](#5-perbandingan-lintas-bahasa)
- [6. Kesalahan Umum & Best Practices](#6-kesalahan-umum--best-practices)
- [7. Ringkasan](#7-ringkasan)
- [8. Latihan Mandiri](#8-latihan-mandiri)

---

## 1. Pendahuluan

Secara historis, di materi PBO, kita diajarkan membuat sistem GUI menggunakan Java Swing atau JavaFX. Kini, framework **Electron** merevolusi cara aplikasi GUI di-build karena memungkinkan pengembang Web untuk membuat *native local desktop apps* di Windows, Mac, dan Linux, bermodalkan pemahaman HTML, CSS, dan JavaScript/TypeScript.

Electron mencapainya dengan menggabungkan **Node.js** (backend dan akses filesystem/Sistem Operasi) dan **Chromium** (browser/render engine) di bawah satu atap (executable yang sama). Hasilnya luar biasa populer, terbukti dipakai oleh VS Code, Discord, Slack, dan Figma desktop.

---

## 2. Landasan Konsep Electron

Dalam memahami Electron, wajib menyadari konsep **Multiproses Architecture**.

### 2.1 Main Process vs Renderer Process

Berbeda dari aplikasi *single-threaded* sederhana, Electron memisahkan otak program menjadi dua alam:
1. **Main Process (Node.js Environment):** Bekerja menjaga *"Life-cycle"* (kapan aplikasi hidup, mati, atau minimize), membuat *Window* layar, serta bebas mengakses file OS dan database native.
2. **Renderer Process (Chromium Web Environment):** Mengelola UI (DOM), men-render file HTML, CSS, dan berinteraksi meng-handle klik *mouse* pengguna. Proses ini berjalan secara terbatas untuk menjaga keamanan (Sandbox).
 
### 2.2 Preload Scripts & IPC (Inter-Process Communication)

Katakanlah dari layar User Interface (Renderer), pengguna mengklik **"Simpan File"**. Renderer *tidak punya izin* mensimpan file ke harddisk sendiri demi keamanan (*Context Isolation*).
Maka dari itu:
- **Preload Script:** Skrip khusus yang berjalan sebelum webpage dimuat penuh. Fungsinya menempelkan seutas kawat komunikasi terbatas antara Web Process dan Main Process di objek `window`.
- **IPC (Inter-Process Communication):** Mekanisme pesan di mana Renderer dan Main saling berkirim sinyal. Renderer mengirim pesan "Tolong Simpan Ini" -> Main Process menangkapnya menggunakan `ipcMain.handle` -> Main meng-eksekusi file penyimpanan dan membalas persetujuan.

> 🔑 **Konsep Kunci:** Bayangkan Main Process sebagai Bankir di dalam brankas, Renderer Process sebagai Teller di counter depan. IPC dan Preload Script adalah pipa komunikasi antar lantai brankas dan counter.

---

## 3. Implementasi dalam TypeScript

Membuat setup arsitektur Node.js dan Electron + TypeScript dengan pendekatan yang benar.

### 3.1 Penataan Struktur Folder
```text
/proyek-electron-oop
 ├── package.json
 ├── tsconfig.json
 ├── /src
 │   ├── /main
 │   │    └── main.ts         (Class Main Process)
 │   ├── /preload
 │   │    └── preload.ts      (Jembatan kawat)
 │   └── /renderer
 │        ├── index.html      (View/Layouting)
 │        └── renderer.ts     (Pengendali UI Event)
```

### 3.2 Setup `package.json`

Jalankan perintah ini sebagai inersia inisialisasi awal.
```bash
npm init -y
npm install -D typescript @types/node electron
```

Atur `package.json` untuk mengeksekusi script sebagai berikut:
```json
{
  "name": "pbo-electron",
  "main": "dist/main/main.js",
  "scripts": {
    "start": "electron .",
    "build": "tsc"
  }
}
```

> ⚠️ **Perhatian:** Field `"main"` merupakan entri penunjuk dari mana Electron harus memulai boot up aplikasinya. Berbeda dari proyek web biasa.

### 3.3 Konfigurasi `tsconfig.json`

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "CommonJS",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true
  }
}
```

---

## 4. Studi Kasus Komprehensif (Aplikasi Info Sistem)

Mari membangun aplikasi sederhana di mana saat tombol pada UI diklik, ia akan memanggil Sistem Operasi (melalui Main Process) untuk membaca arsitektur komputer dan lalu UI menampilkannya. 

### 4.1 Desain Solusi (Kode)

#### A. Main Process (`src/main/main.ts`)
Mengatur window dan merespons IPC calls.

```typescript
import { app, BrowserWindow, ipcMain } from 'electron';
import * as path from 'path';
import * as os from 'os';

class ApplicationManager {
    private mainWindow: BrowserWindow | null = null;

    constructor() {
        // Lifecycle hook
        app.whenReady().then(() => {
            this.createWindow();
            this.setupIPC();
            
            app.on('activate', () => {
                if (BrowserWindow.getAllWindows().length === 0) {
                    this.createWindow();
                }
            });
        });

        app.on('window-all-closed', () => {
            if (process.platform !== 'darwin') {
                app.quit();
            }
        });
    }

    private createWindow(): void {
        this.mainWindow = new BrowserWindow({
            width: 800,
            height: 600,
            webPreferences: {
                // Preload sangat krusial
                preload: path.join(__dirname, '../preload/preload.js'), 
                contextIsolation: true,
                nodeIntegration: false,
            }
        });
        
        // Memuat Renderer
        this.mainWindow.loadFile(path.join(__dirname, '../../src/renderer/index.html'));
    }

    private setupIPC(): void {
        // Main merespons sinyal dengan channel 'get-system-info'
        ipcMain.handle('get-system-info', () => {
            return `Platform: ${os.platform()} - Arsitektur: ${os.arch()}`;
        });
    }
}

// Inisialisasi program OOP
new ApplicationManager();
```

#### B. Preload Script (`src/preload/preload.ts`)
Mendefinisikan API jembatan komunikasi bagi Renderer.

```typescript
import { contextBridge, ipcRenderer } from 'electron';

// Expose object khusus untuk dieksekusi oleh Window Node (diakses renderer)
contextBridge.exposeInMainWorld('sistemAPI', {
    fetchSystemInfo: () => ipcRenderer.invoke('get-system-info')
});
```

#### C. Layout Renderer (`src/renderer/index.html`)

```html
<!DOCTYPE html>
<html>
<head>
    <title>Aplikasi OOP Electron</title>
</head>
<body>
    <h1>Pengambilan Data OS</h1>
    <button id="btnInfo">Dapatkan Info</button>
    <p id="hasil">N/A</p>

    <!-- Panggil renderer script (hasil kompilasi) -->
    <script src="../../dist/renderer/renderer.js"></script>
</body>
</html>
```

#### D. Renderer Script (`src/renderer/renderer.ts`)

```typescript
// Define global window type interface
interface Window {
    sistemAPI: {
        fetchSystemInfo: () => Promise<string>;
    };
}

class UIManager {
    private btnInfo: HTMLButtonElement;
    private outputP: HTMLParagraphElement;

    constructor() {
        this.btnInfo = document.getElementById('btnInfo') as HTMLButtonElement;
        this.outputP = document.getElementById('hasil') as HTMLParagraphElement;
        this.setupListener();
    }

    private setupListener(): void {
        this.btnInfo.addEventListener('click', async () => {
            // Memanggil API via Preload 
            const info = await window.sistemAPI.fetchSystemInfo();
            this.outputP.innerText = info;
        });
    }
}

// Initialize saat konten HTML siap
document.addEventListener('DOMContentLoaded', () => {
    new UIManager();
});
```

### 4.2 Langkah Eksekusi (Jalankan!)
1. Buka terminal di folder project, eksekusi `npm run build`.
2. Kemudian, jalankan aplikasi desktop dengan `npm run start`.
3. Akan muncul jendela baru. Di saat tombol ditekan, ia akan menunjukkan arsitektur OS yang mana tidak mampu dilakukan sekadar HTML browser biasa!

---

## 5. Perbandingan Lintas Bahasa

| Aspek | Electron (TS/Web) | JavaFX (Java) | WPF (C# / Windows) |
|-------|-----------------|---------------|--------------------|
| Engine UI | Chromium HTML/CSS | SceneGraph / FXML | XAML |
| Paradigma | Event-driven architecture | Strongly OOP / MVC | MVVM Paradigm |
| Cross-Platform | Ya (Win/Mac/Linux) | Ya (Walau kalah native feel) | Tidak (Hanya Windows) |
| Ukuran File Build| Cukup besar (membawa Chromium) | Sedang (sejak Jigsaw modularity)| Kecil (bawaan Windows) |

> 🔄 **Perbandingan:** JavaFX menggunakan node-group khusus untuk menggambar canvas antarmuka, sedangkan Electron pada dasarnya membuat website internal namun memiliki kekuatan Sistem Operasi tanpa restriksi.

---

## 6. Kesalahan Umum & Best Practices

### ❌ Anti-Pattern / Kesalahan Umum
- **Mengubah `nodeIntegration: true` & `contextIsolation: false`.**
  Banyak modul kuno Electron menyarankan menggunakan `require('fs')` langsung di HTML Renderer. Ini sangat berbahaya *(Security Vulnerability)* karena skrip jahat dari internet bisa merusak harddisk *user*.
- **Sync IPC (`ipcRenderer.sendSync`)**
  Main Process terblokir sampai operasi selesai, ini menyebabkan aplikasi desktop terasa hang dan tidak merespons (freeze interface) ketika membaca file besar. Selalu gunakan `invoke/handle` yang bertabiat asinkron (Promise/await).

### ✅ Best Practice
- Menggunakan arsitektur Preload Script `contextBridge.exposeInMainWorld(...)` seperti pada bab implementasi (aman).
- Gunakan arsitektur OOP untuk Controller (lihat bagaimana kita menggunakan kelas `UIManager` ketimbang sekadar `function onButtonClick`) demi skalabilitas kode dan clean design.

---

## 7. Ringkasan

- **Electron** memberikan *superpower* bagi developer web untuk mengkompilasi file web menjadi aplikasi native Desktop nyata.
- Electron memiliki setidaknya dua alam proses utama: **Main Process** penguasa OS via Node.js dan **Renderer Process** sebagai layar antarmuka *user*.
- Karena konsep keamanan *sandbox*, Renderer tak bisa langsung berbicara ke hardware. Komunikasi OS harus melewati layer **Preload Script** dan mekanisme pesan **IPC**.
- TypeScript membalut pembuatan Electron dengan OOP pattern, memastikan class interface solid (menghindari error property null atau bad typing) dan peramalan Type Checking yang stabil saat run-time.

---

## 8. Latihan Mandiri

1. **Pertanyaan Analitis:** Apa alasan utama platform Discord mengembangkan Client *desktopnya* memakai Electron alih-alih bahasa seperti C++ Native? Apa Trade-offs (Sisi Negatif) dari strategi arsitektur ini?
2. **Mini Exercise:** Ubah class `UIManager` tadi, tambahkan input text-field HTML pada Renderer untuk nama `FileLog.txt`. Lalu buat IPC channel baru `save-log-file` untuk menerima payload argument filename, agar Main Process Node (`fs.writeFileSync`) menyimpannya ke desktop!
3. **Analisis Security:** Menurut standar Electron, bisakah Preload Process mengganti file `system32` OS Windows secara langsung? Jika ya, fitur properti parameter instansiasi apa yang menahannya?

---

## Referensi & Bacaan Lanjutan

- Official Electron Documentation & Security Guidelines: https://www.electronjs.org/docs/latest/
- Electron IPC Tutorial: https://www.electronjs.org/docs/latest/tutorial/ipc
- "Building GUI Desktop Application with Typescript & Electron" - O'Reilly / Packt (Referensi Praktik Terbaik)
