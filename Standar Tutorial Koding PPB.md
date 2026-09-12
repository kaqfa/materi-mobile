# Standar Tutorial Koding PPB

#kuliah #ppb #standards #tutorial

## Filosofi Dasar

Tutorial koding PPB harus mengikuti prinsip **"Progressive Learning with Immediate Rewards"** - setiap langkah memberikan hasil yang terlihat dan berguna sambil membangun pemahaman secara bertahap.

## Prinsip Continuity (Kesinambungan)

### Menggunakan Progress dari Tutorial Sebelumnya
- **Satu aplikasi utuh**: Tutorial membangun 1 aplikasi lengkap dari awal sampai akhir
- **Progressive per pertemuan**: Setiap pertemuan menambahkan kemampuan/fitur baru
- **Referensi Sample-Code**: Gunakan direktori `Sample-Code/P0X/` sebagai baseline koding
- **No Repetition**: Tidak perlu menulis ulang kode yang sudah dibuat di pertemuan sebelumnya
- **Progressive Enhancement**: Setiap pertemuan menambahkan fitur baru di atas fondasi yang sudah ada

### Format Referensi Progress
```markdown
## Prerequisites
Pastikan Anda telah menyelesaikan Pertemuan [X] dengan [fitur yang sudah working].

## Starting Point
Tutorial ini melanjutkan dari Pertemuan [X] dengan struktur sebagai berikut:
[Tampilkan struktur direktori yang sudah ada]
```

## Struktur Wajib: Progressive Checkpoint Pattern

### Konsep Dasar
Setiap tutorial dipecah menjadi **2-4 checkpoints** (fleksibel sesuai complexity). Setiap checkpoint:
- ✅ **Must produce working code** - bisa di-run dan lihat hasilnya
- ✅ **Must be testable** - mahasiswa bisa verifikasi berhasil atau tidak
- ✅ **Builds on previous checkpoint** - progressive enhancement
- ✅ **Clear deliverable** - jelas apa yang bisa dilihat/dicoba

### Struktur Checkpoint
Setiap checkpoint harus memiliki:

#### 1. Checkpoint Header
```markdown
### 🎯 CHECKPOINT X: [Nama Checkpoint]
**Goal:** [Specific, measurable goal]
**Time:** ~XX minutes
```

#### 2. Building Context (untuk checkpoint 2+)
```markdown
**🔄 Building on Checkpoint X:**
- ✅ Already have: [Recap previous checkpoint]
- 🆕 Will add: [What's new in this checkpoint]
```

#### 3. Implementation Guide
```markdown
#### What You'll Build
[Clear description of deliverable]

#### Implementation Steps
1. [Step dengan code snippet atau reference]
2. [Step dengan code snippet atau reference]
3. ...
```

#### 4. Validation Checklist
```markdown
#### ✓ Checkpoint Validation
- [ ] [Criteria 1 - testable]
- [ ] [Criteria 2 - testable]
- [ ] [Criteria 3 - testable]

**Run & Test:**
```bash
flutter run
# Expected: [Apa yang harus terlihat]
```
```

### Berapa Checkpoint yang Ideal?
- **Simple feature** (basic UI, simple form): 2 checkpoints
- **Medium feature** (CRUD, API integration): 3 checkpoints
- **Complex feature** (camera, maps, analytics): 4 checkpoints

**Prinsip**: Jangan paksa fit ke pattern tertentu - sesuaikan dengan natural progression fitur

## Format Dokumentasi Wajib

### Tutorial Header
Setiap tutorial harus dimulai dengan:
```markdown
## 📱 PERTEMUAN X: [Judul Tema]

### Prerequisites
Pastikan Anda telah menyelesaikan Pertemuan [X] dengan [fitur yang sudah working].

### Final Outcome
[Deskripsi singkat + screenshot/mockup hasil akhir pertemuan]

### Learning Goals
- [Kemampuan 1 yang akan dikuasai]
- [Kemampuan 2 yang akan dikuasai]
- [Kemampuan 3 yang akan dikuasai]
```

### Tutorial Closing
Setiap tutorial harus diakhiri dengan:
```markdown
### 📝 Summary

**What You Built:**
- [Feature 1]
- [Feature 2]
- [Feature 3]

**Key Concepts Learned:**
- [Concept 1]
- [Concept 2]
- [Concept 3]

**Next Session Preview:**
[Teaser untuk pertemuan berikutnya]

### Troubleshooting
**Issue:** [Common problem]
**Solution:** [How to fix]

**Issue:** [Another problem]
**Solution:** [How to fix]
```

### Code Quality Standards
Setiap checkpoint harus memiliki:
- **Kode lengkap** yang bisa dicopy-paste
- **Penjelasan konsep** yang digunakan (fokus pada WHY, bukan hanya HOW)
- **Inline comments** untuk logic yang tidak obvious
- **Clear variable names** yang self-explanatory

## Prinsip Konten

### ✅ DO (Lakukan)
- Gunakan contoh real-world yang relevan
- Fokus pada deliverable yang jelas di setiap checkpoint
- Berikan hasil visual yang terlihat di **setiap checkpoint**
- Sertakan validation checklist yang testable
- Gunakan Material Design patterns
- Jelaskan "mengapa" bukan hanya "bagaimana"
- Pastikan setiap checkpoint **bisa di-run dan lihat hasilnya**
- Berikan estimasi waktu per checkpoint

### ❌ DON'T (Hindari)
- Checkpoint yang terlalu besar (>60 menit)
- Penjelasan teoritis yang bertele-tele tanpa implementasi
- Terlalu banyak konsep dalam satu checkpoint
- Pattern yang terlalu complex untuk pemula
- Skip validation - mahasiswa harus tahu berhasil atau tidak
- Asumsi mahasiswa sudah paham tanpa penjelasan
- Broken state - setiap checkpoint harus working

## Template Tutorial

```markdown
## 📱 PERTEMUAN X: [Judul Tema]

### Prerequisites
Pastikan Anda telah menyelesaikan Pertemuan [X] dengan [fitur yang sudah working].

### Final Outcome
[Deskripsi singkat + screenshot hasil akhir pertemuan]

### Learning Goals
- [Kemampuan 1]
- [Kemampuan 2]
- [Kemampuan 3]

---

### 🎯 CHECKPOINT 1: [Nama Checkpoint]
**Goal:** [Specific goal]
**Time:** ~XX minutes

#### What You'll Build
[Clear description of deliverable]

#### Implementation Steps
1. [Step with code/reference]
2. [Step with code/reference]
3. ...

#### ✓ Checkpoint Validation
- [ ] [Testable criteria 1]
- [ ] [Testable criteria 2]
- [ ] [Testable criteria 3]

**Run & Test:**
```bash
flutter run
# Expected: [What should be visible]
```
---
```
### 🎯 CHECKPOINT 2: [Nama Checkpoint]
**Goal:** [Next specific goal]
**Time:** ~XX minutes

**🔄 Building on Checkpoint 1:**
- ✅ Already have: [Recap]
- 🆕 Will add: [What's new]

#### What You'll Build
[Clear description]

#### Implementation Steps
1. [Step]
2. [Step]

#### ✓ Checkpoint Validation
- [ ] [Criteria]
- [ ] [Criteria]

**Run & Test:**
```bash
flutter run
# Expected: [What should be visible]
```

---

[... Additional checkpoints as needed ...]

---

### 📝 Summary

**What You Built:**
- [Feature 1]
- [Feature 2]

**Key Concepts Learned:**
- [Concept 1]
- [Concept 2]

**Next Session Preview:**
[Teaser]

### Troubleshooting
**Issue:** [Problem]
**Solution:** [Fix]
```

## Metrics Kualitas Tutorial

### Indikator Tutorial yang Baik:
1. **Progressive Checkpoints**: Setiap checkpoint membangun dari sebelumnya
2. **Immediate Testability**: Mahasiswa bisa run & test di setiap checkpoint
3. **Visual Rewards**: Mahasiswa melihat progress di setiap checkpoint
4. **Clear Deliverables**: Jelas apa yang harus tercapai di setiap checkpoint
5. **Real-world Relevance**: Contoh yang applicable
6. **Validation Checklist**: Criteria yang bisa di-check oleh mahasiswa
7. **Time Estimates**: Mahasiswa tahu berapa lama tiap checkpoint

### Red Flags:
- Checkpoint terlalu besar (>60 menit) atau terlalu kecil (<15 menit)
- Tidak ada validation checklist - mahasiswa bingung "berhasil atau nggak"
- Broken state - checkpoint tidak bisa di-run
- Terlalu theoritis tanpa implementasi
- Menggunakan pattern yang terlalu advanced
- Tidak ada troubleshooting section
- Skip penjelasan "building on previous checkpoint"

## Implementasi untuk Claude Code

Ketika membuat atau merevisi tutorial:

1. **Gunakan Progressive Checkpoint Pattern** (2-4 checkpoints per pertemuan)
2. **Pastikan setiap checkpoint working** - bisa flutter run & lihat hasil
3. **Sertakan validation checklist** di setiap checkpoint
4. **Berikan time estimate** yang realistic
5. **Building context** untuk checkpoint 2+ - recap + what's new
6. **Summary section** di akhir - what built, concepts learned, next preview
7. **Troubleshooting** untuk common issues
8. **Keep it simple** - beginner-friendly code patterns

Standard ini berlaku untuk semua tutorial koding di mata kuliah PPB.