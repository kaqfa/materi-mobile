## CAPAIAN PEMBELAJARAN (CP)

### **CPL Prodi yang Dibebankan pada MK**

**CPL05**: Mampu menjelaskan konsep teoritis bidang pengetahuan Informatika dalam mendesain, implementasi dan mengevaluasi aplikasi teknologi multi-platform yang relevan dengan kebutuhan industri dan masyarakat

**CPL09**: Mampu menganalisis, merancang, membuat dan mengevaluasi user interface dan aplikasi interaktif dengan mempertimbangkan kebutuhan pengguna dan perkembangan ilmu transdisiplin.

### **Capaian Pembelajaran Mata Kuliah (CPMK)**

**CPMK53**: Mampu mengimplementasi aplikasi teknologi multi-platform yang relevan dengan kebutuhan industri dan masyarakat

**CPMK92**: Mampu merancang user interface dan aplikasi interaktif perkembangan ilmu transdisiplin.

### **Kemampuan Akhir Setiap Tahapan Belajar (Sub-CPMK)**

#### Sub-CPMK dari CPMK53 (Implementasi Aplikasi Multi-Platform)

**Sub-CPMK53.1**: Mampu mengimplementasikan aplikasi mobile fungsional menggunakan bahasa Dart dan Flutter framework dengan menerapkan konsep OOP, widget system, dan state management.
- *Indikator*: Mahasiswa dapat membangun aplikasi Flutter multi-screen yang berjalan di emulator/device dengan menerapkan OOP Dart, widget stateful/stateless, dan pengelolaan state sederhana.
- *Kriteria Penilaian*: Rubrik
- *Bentuk Pembelajaran*: Kuliah, Praktikum
- *Metode Pembelajaran*: Studi Kasus
- *Penugasan*:
  1. **Dart OOP Challenge** — Membuat model domain aplikasi lengkap menggunakan Dart dengan menerapkan class, inheritance, mixin, dan null safety; estimasi waktu: **3 × 50 menit**
  2. **Flutter Mini App** — Membangun aplikasi Flutter 3 screen dengan navigasi, StatefulWidget, dan state management sederhana (setState); estimasi waktu: **3 × 50 menit**

**Sub-CPMK53.2**: Mampu mengintegrasikan data persistence lokal dan layanan API eksternal serta mengoptimalkan performa aplikasi hingga siap untuk deployment.
- *Indikator*: Mahasiswa dapat menghasilkan aplikasi yang terhubung dengan REST API dan penyimpanan lokal, lulus profiling performa DevTools, dan menghasilkan release build yang siap didistribusikan.
- *Kriteria Penilaian*: Portfolio
- *Bentuk Pembelajaran*: Kuliah, Praktikum
- *Metode Pembelajaran*: Pembelajaran Berbasis Proyek
- *Penugasan*:
  1. **Backend Integration Sprint** — Mengintegrasikan REST API dan SQLite ke dalam capstone project dengan menerapkan CRUD penuh, error handling, dan offline-first strategy; estimasi waktu: **3 × 50 menit**
  2. **Release-Ready Build** — Melakukan profiling performa menggunakan DevTools, optimasi rebuild widget, dan menghasilkan signed APK/App Bundle yang terdokumentasi; estimasi waktu: **3 × 50 menit**

#### Sub-CPMK dari CPMK92 (Perancangan UI dan Aplikasi Interaktif)

**Sub-CPMK92.1**: Mampu merancang arsitektur UI aplikasi mobile yang konsisten dan responsif menggunakan Material Design dan adaptive layout berdasarkan kebutuhan pengguna.
- *Indikator*: Mahasiswa dapat merancang dan mengimplementasikan antarmuka aplikasi yang konsisten secara visual, responsif pada berbagai ukuran layar, dan sesuai dengan panduan Material Design.
- *Kriteria Penilaian*: Rubrik
- *Bentuk Pembelajaran*: Kuliah, Tutorial, Praktikum
- *Metode Pembelajaran*: Pembelajaran Kolaboratif
- *Penugasan*:
  1. **UI Design System** — Merancang design system capstone project meliputi color scheme, typography, komponen custom widget yang reusable, dan panduan konsistensi visual; estimasi waktu: **3 × 50 menit**
  2. **Responsive Layout Showcase** — Mengimplementasikan adaptive layout capstone project yang diuji pada minimal 3 konfigurasi layar berbeda (phone portrait, phone landscape, tablet); estimasi waktu: **3 × 50 menit**

**Sub-CPMK92.2**: Mampu mengembangkan aplikasi interaktif dengan fitur platform spesifik, pengujian menyeluruh, dan dokumentasi yang memenuhi standar kualitas industri.
- *Indikator*: Mahasiswa dapat mengintegrasikan minimal dua fitur platform natif (kamera/lokasi/sensor), menyertakan test suite dengan coverage yang memadai, dan mendokumentasikan aplikasi sesuai standar publikasi.
- *Kriteria Penilaian*: Portfolio
- *Bentuk Pembelajaran*: Praktikum, Responsi
- *Metode Pembelajaran*: Pembelajaran Berbasis Proyek
- *Penugasan*:
  1. **Native Feature Integration** — Mengintegrasikan minimal dua fitur platform natif ke dalam capstone project disertai permission handling, error case, dan demo pengujian di device nyata; estimasi waktu: **3 × 50 menit**
  2. **Quality Assurance Portfolio** — Menyusun test suite (unit + widget test) dengan coverage minimal 70% dan dokumentasi teknis aplikasi siap publikasi (README, arsitektur, panduan penggunaan); estimasi waktu: **3 × 50 menit**

---

## HUBUNGAN CPL PRODI TERHADAP SUB-CPMK

| Sub-CPMK | CPL | CPMK | Bobot Penilaian | Jumlah Minggu |
|---|---|---|---|---|
| Sub-CPMK53.1 | CPL05 | CPMK53 | 30% | 6 |
| Sub-CPMK53.2 | CPL05 | CPMK53 | 20% | 4 |
| Sub-CPMK92.1 | CPL09 | CPMK92 | 25% | 4 |
| Sub-CPMK92.2 | CPL09 | CPMK92 | 25% | 2 |
| **Total** | | | **100%** | **16** |

---

## DESKRIPSI SINGKAT MK

Mata kuliah Pemrograman Mobile Flutter membekali mahasiswa dengan kemampuan mengembangkan aplikasi mobile multiplatform menggunakan Flutter framework. Mahasiswa akan mempelajari bahasa pemrograman Dart, arsitektur Flutter, state management, integrasi API, testing, dan deployment. Pembelajaran mengintegrasikan AI tools secara progresif dengan metodologi Generate-Analyze-Improve, Error-First Learning, dan peer code review untuk memastikan pemahaman konsep yang mendalam sambil memanfaatkan teknologi terkini.

Mata kuliah ini dirancang dengan pendekatan incremental development melalui capstone project yang dikembangkan secara bertahap selama semester, memungkinkan mahasiswa membangun portfolio aplikasi yang dapat digunakan dalam dunia kerja.

---

## BAHAN KAJIAN/MATERI PEMBELAJARAN

### **1. Fundamental Mobile & Flutter Development**
- Transisi dari web ke mobile development paradigm
- Flutter ecosystem dan architecture overview
- Dart syntax fundamentals dan OOP concepts
- Development environment setup dan tooling

### **2. Flutter Widget System & UI Development**
- Widget tree architecture dan lifecycle
- Stateless vs Stateful widgets
- Layout widgets dan responsive design
- Material Design vs Cupertino implementation
- Custom widget development

### **3. State Management & Application Architecture**
- setState() limitations dan alternatives
- Provider pattern implementation
- BLoC/Riverpod architecture patterns
- Dependency injection
- Data flow design patterns

### **4. Data Persistence & Backend Integration**
- Local storage solutions (SQLite, SharedPreferences)
- REST API integration dengan dio/http
- JSON serialization/deserialization
- Authentication dan error handling
- Caching strategies

### **5. Advanced Features & Platform Integration**
- Platform channels untuk native features
- Camera, gallery, dan file handling
- Location services dan maps
- Push notifications
- Device sensors integration

### **6. Testing, Performance & Deployment**
- Unit testing dan widget testing
- Integration testing strategies
- Performance profiling dengan DevTools
- Memory management
- App store deployment process

### **7. AI Integration dalam Development Process**
- AI-assisted coding dengan proper understanding
- Code review dan quality assessment
- Debugging techniques dengan AI support
- Documentation generation
- Architecture design validation

---

## PUSTAKA

### **Utama:**
1. Windmill, Eric. *Flutter in Action*. Manning Publications, 2019.
2. Ramos, Matt. *Beginning App Development with Flutter*. Apress, 2020.
3. Flutter Team. *Flutter Documentation*. https://flutter.dev/docs

### **Pendukung:**
1. Biessek, Marco L. *Flutter Complete Reference*. Independently Published, 2021.
2. Moroney, Laurence. *AI and Machine Learning for Coders*. O'Reilly Media, 2020.
3. Tarlao, Simone. *Flutter Projects*. Packt Publishing, 2020.

---

## MEDIA PEMBELAJARAN

### **Perangkat Lunak:**
- Flutter SDK & Dart SDK
- Android Studio / VS Code
- Git version control
- Postman untuk API testing
- Firebase services
- AI Coding Assistants (GitHub Copilot, ChatGPT)

### **Perangkat Keras:**
- Komputer/laptop dengan spesifikasi minimum
- Android/iOS device untuk testing
- Emulator untuk development

---

## MATA KULIAH SYARAT

**Prasyarat:**
- Pemrograman Berorientasi Objek (telah lulus)
- Struktur Data dan Algoritma (telah lulus)
- Basis Data (telah lulus)

**Corequisite:**
- Rekayasa Perangkat Lunak

---

## RENCANA PEMBELAJARAN DETIL

### **Pertemuan 1: Introduction to Mobile Development & Dart Fundamentals**
- **Materi**: Web vs mobile paradigm, Flutter ecosystem overview, Development setup
- **Sub-CPMK**: Sub-CPMK53.1
- **Kemampuan Akhir**: Mampu menguasai fundamental Dart programming dan Flutter framework untuk pengembangan aplikasi mobile dasar
- **Indikator**: Kemampuan setup environment dan pemahaman paradigma mobile development
- **Bentuk Pembelajaran**: Kuliah, Praktikum
- **Metode**: Studi Kasus
- **Tugas**: Environment verification & first Dart program
- **AI Integration**: AI untuk explain syntax differences
- **Praktikum**: Mahasiswa melakukan setup lengkap development environment termasuk instalasi Flutter SDK, Android Studio, konfigurasi emulator, dan membuat project Flutter pertama dengan nama "StudyTracker". Praktikum mencakup pengenalan struktur project Flutter, pemahaman file pubspec.yaml, dan running aplikasi hello world pertama. Mahasiswa juga diajarkan fundamental Dart syntax melalui latihan sederhana seperti variabel, function, dan class declaration yang akan menjadi building blocks untuk assignment tracker nantinya.

### **Pertemuan 2: Dart Programming Deep Dive**
- **Materi**: OOP dalam Dart, Async programming, Error handling & null safety
- **Sub-CPMK**: Sub-CPMK53.1
- **Kemampuan Akhir**: Mampu menguasai fundamental Dart programming dan Flutter framework untuk pengembangan aplikasi mobile dasar
- **Indikator**: Penguasaan sintaks Dart dan OOP concepts
- **Bentuk Pembelajaran**: Kuliah, Praktikum
- **Metode**: Studi Kasus
- **Tugas**: Weather API client dengan async programming
- **AI Integration**: AI generate OOP examples, manual analysis
- **Praktikum**: Mahasiswa membuat model class Task dengan properti seperti id, title, description, category, priority, dueDate, dan completed. Praktikum fokus pada implementasi OOP concepts termasuk constructors, named constructors, method implementation, dan serialization methods (toJson/fromJson). Mahasiswa juga belajar async programming melalui simulasi API calls dan error handling dengan try-catch blocks. Generate-Analyze-Improve method diterapkan dimana AI generate contoh class structure, mahasiswa analyze pattern nya, kemudian improve dengan custom business logic untuk assignment management.

### **Pertemuan 3: Flutter Fundamentals & Widget System**
- **Materi**: Widget architecture, Basic layouts, Navigation basics
- **Sub-CPMK**: Sub-CPMK53.1
- **Kemampuan Akhir**: Mampu menguasai fundamental Dart programming dan Flutter framework untuk pengembangan aplikasi mobile dasar
- **Indikator**: Pemahaman widget system dan basic UI development
- **Bentuk Pembelajaran**: Kuliah, Praktikum
- **Metode**: Studi Kasus
- **Tugas**: Multi-screen app dengan navigation
- **AI Integration**: AI untuk explain widget properties
- **Praktikum**: Mahasiswa membangun UI dasar StudyTracker dengan implementasi bottom navigation untuk beralih antara Assignment List screen dan Dashboard screen. Praktikum mencakup pembuatan StatelessWidget untuk komponen yang statis dan StatefulWidget untuk komponen interactive. Error-First Learning diterapkan dengan memberikan kode UI yang rusak (widget hierarchy salah, constraints overflow) untuk mahasiswa debug dan perbaiki. Live coding session fokus pada pembuatan TaskCard widget yang reusable, implementasi ListView untuk menampilkan daftar assignment, dan navigation routing antar screens menggunakan Navigator.push dan MaterialPageRoute.

### **Pertemuan 4: Build System & Project Structure**
- **Materi**: Gradle configuration, Project organization, **CAPSTONE START:** Project proposal
- **Sub-CPMK**: Sub-CPMK92.1
- **Kemampuan Akhir**: Mampu merancang dan mengimplementasikan arsitektur aplikasi dengan state management yang efektif
- **Indikator**: Pemahaman build system dan project organization
- **Bentuk Pembelajaran**: Kuliah, Tutorial, Praktikum
- **Metode**: Pembelajaran Kolaboratif
- **Tugas**: Project proposal & initial structure
- **AI Integration**: AI limitation starts - debugging only
- **Praktikum**: Mahasiswa menyusun project proposal capstone dengan memilih domain aplikasi (Local Business Solutions, Educational Technology, atau Health & Wellness) dan merancang struktur folder yang clean dengan separasi concerns. Praktikum mencakup konfigurasi pubspec.yaml untuk dependencies yang dibutuhkan (provider, sqflite, image_picker, geolocator), setup folder structure (models/, services/, screens/, widgets/, utils/), dan implementasi basic routing architecture. Mahasiswa mulai membuat wireframe dan user flow untuk capstone project mereka sambil mengikuti pattern dari StudyTracker sebagai reference. AI integration dibatasi hanya untuk debugging purposes starting from pertemuan ini.

### **Pertemuan 5: UI Design & Material Design Implementation**
- **Materi**: Material Design principles, UI component library, **CAPSTONE:** UI foundation phase
- **Sub-CPMK**: Sub-CPMK92.1
- **Kemampuan Akhir**: Mampu merancang dan mengimplementasikan arsitektur aplikasi dengan state management yang efektif
- **Indikator**: Implementasi UI design yang consistent dan user-friendly
- **Bentuk Pembelajaran**: Kuliah, Tutorial, Praktikum
- **Metode**: Pembelajaran Kolaboratif
- **Tugas**: Complete UI implementation untuk semua screens
- **AI Integration**: AI hanya untuk debugging
- **Praktikum**: Mahasiswa mengimplementasikan Material Design system untuk StudyTracker termasuk consistent color scheme, typography, dan spacing guidelines. Design thinking workshop dimulai dengan user persona analysis, pain points identification, dan solution mapping untuk assignment management. Praktikum mencakup pembuatan custom theme di ThemeData, implementasi AppBar dengan consistent styling, FloatingActionButton untuk add task action, dan Card widgets dengan elevation dan proper padding. Mahasiswa juga membuat form UI untuk add/edit assignment dengan TextFormField, DropdownButton untuk category selection, DatePicker untuk due date, dan priority selection dengan radio buttons atau chips. UI harus responsive dan mengikuti Material Design accessibility guidelines.

### **Pertemuan 6: Advanced UI & Custom Widgets**
- **Materi**: Custom widget creation, Animations basics, **CAPSTONE:** Advanced UI components
- **Sub-CPMK**: Sub-CPMK92.1
- **Kemampuan Akhir**: Mampu merancang dan mengimplementasikan arsitektur aplikasi dengan state management yang efektif
- **Indikator**: Custom widget development dan advanced UI patterns
- **Bentuk Pembelajaran**: Kuliah, Tutorial, Praktikum
- **Metode**: Pembelajaran Kolaboratif
- **Tugas**: Custom widget library creation
- **AI Integration**: Manual core logic implementation
- **Praktikum**: Mahasiswa mengembangkan custom widgets yang reusable untuk StudyTracker seperti TaskCard widget dengan built-in actions (edit, delete, mark complete), PriorityIndicator widget dengan color coding, CategoryChip widget untuk visual categorization, dan ProgressIndicator widget untuk dashboard statistics. Custom development workshop fokus pada widget composition, passing data through constructors, handling callbacks untuk user interactions, dan implementing basic animations seperti fade transitions untuk task completion dan slide animations untuk delete actions. Mahasiswa juga membuat StatefulWidget untuk interactive components seperti expandable task details dan custom bottom sheet untuk quick task addition. Core logic untuk widget behavior harus diimplementasikan manual tanpa AI assistance untuk memastikan pemahaman mendalam tentang widget lifecycle dan state management.

### **Pertemuan 7: Responsive Design & Adaptive Layouts**
- **Materi**: Screen size handling, Adaptive design patterns, **CAPSTONE:** Responsive optimization
- **Sub-CPMK**: Sub-CPMK92.1
- **Kemampuan Akhir**: Mampu merancang dan mengimplementasikan arsitektur aplikasi dengan state management yang efektif
- **Indikator**: Responsive design implementation across devices
- **Bentuk Pembelajaran**: Kuliah, Tutorial, Praktikum
- **Metode**: Pembelajaran Kolaboratif
- **Tugas**: Responsive UI implementation
- **AI Integration**: Debugging assistance only
- **Praktikum**: Mahasiswa mengoptimalkan StudyTracker untuk berbagai screen sizes menggunakan MediaQuery, LayoutBuilder, dan responsive design patterns. Multi-device testing workshop menggunakan emulator dengan different screen sizes (phone, tablet, landscape/portrait) untuk memastikan UI tetap usable dan aesthetic. Praktikum mencakup implementasi adaptive layouts dengan Flexible dan Expanded widgets, penggunaan AspectRatio untuk image displays, dan conditional rendering berdasarkan screen width untuk optimized UX. Mahasiswa juga belajar breakpoint management untuk menentukan kapan menggunakan single-column vs two-column layouts, dynamic padding/margin adjustments, dan font size scaling untuk readability across devices. Testing dilakukan pada minimum 3 different screen configurations untuk memastikan responsive behavior yang consistent.

### **UJIAN TENGAH SEMESTER**
- **Format**: Live coding (60 menit), UI implementation demo, Project progress presentation
- **Evaluasi**: Kemampuan UI development dan fundamental skills
- **Indikator**: Komprehensif assessment Sub-CPMK4.1.1 dan Sub-CPMK4.1.2
- **Format**: Practical exam + project demo
- **Praktikum UTS**: Mahasiswa mendemonstrasikan StudyTracker app yang functional dengan fitur: (1) Add new assignment dengan form validation, (2) Display assignment list dengan filtering by category, (3) Mark assignment as complete dengan visual feedback, (4) Edit existing assignment dengan pre-filled data, (5) Delete assignment dengan confirmation dialog. Live coding session 60 menit untuk implement specific feature yang diberikan (misalnya: tambah search functionality atau sorting options). Project progress presentation mencakup demo aplikasi capstone, explanation of technical decisions, widget architecture yang digunakan, dan responsive design implementation. Assessment criteria meliputi code quality, UI/UX consistency, error handling, dan kemampuan explain technical concepts dengan jelas.

### **Pertemuan 9: API Integration & HTTP Operations**
- **Materi**: REST API integration, Authentication strategies, **CAPSTONE:** Backend integration phase
- **Sub-CPMK**: Sub-CPMK53.2
- **Kemampuan Akhir**: Mampu mengintegrasikan data persistence dan API eksternal dalam aplikasi mobile
- **Indikator**: API integration dan network programming
- **Bentuk Pembelajaran**: Kuliah, Praktikum
- **Metode**: Pembelajaran Berbasis Proyek
- **Tugas**: Complete API integration layer
- **AI Integration**: AI help untuk optimize API calls
- **Praktikum**: Mahasiswa mengintegrasikan StudyTracker dengan Supabase backend melalui pure REST API calls menggunakan http package. Praktikum dimulai dengan setup Supabase project, konfigurasi database tables (tasks, users), dan implementasi authentication flow dengan email/password. Mahasiswa belajar HTTP methods (GET, POST, PUT, DELETE) untuk CRUD operations, proper header management dengan API keys dan JWT tokens, dan error handling untuk different HTTP status codes (200, 401, 403, 404, 422). Implementasi mencakup SupabaseService class dengan methods untuk signIn, signUp, getAllTasks, createTask, updateTask, dan deleteTask. Practical exercise meliputi testing API calls dengan Postman, handling network errors dengan try-catch blocks, dan implementing loading states untuk better UX. AI assistance digunakan untuk optimizing API call patterns dan batch operations.

### **Pertemuan 10: Real-time Features & Advanced API Integration**
- **Materi**: WebSocket implementation, Firebase services, **CAPSTONE:** Real-time features integration
- **Sub-CPMK**: Sub-CPMK53.2
- **Kemampuan Akhir**: Mampu mengintegrasikan data persistence dan API eksternal dalam aplikasi mobile
- **Indikator**: Advanced API integration dengan real-time features
- **Bentuk Pembelajaran**: Kuliah, Praktikum
- **Metode**: Pembelajaran Berbasis Proyek
- **Tugas**: WebSocket/Firebase integration
- **AI Integration**: Architecture design feedback dari AI
- **Praktikum**: Mahasiswa mengimplementasikan data synchronization antara local SQLite database dan Supabase server dengan conflict resolution strategies. Real-time integration workshop fokus pada offline-first approach dimana app tetap functional tanpa internet connection dan sync data ketika connection restored. Praktikum mencakup implementasi sync service yang menghandle: pending local changes upload ke server, server changes download ke local, conflict resolution untuk simultaneous edits, dan sync status indicators untuk user feedback. Mahasiswa juga belajar background sync menggunakan WorkManager untuk periodic data synchronization, handling authentication token refresh, dan implementing retry mechanisms untuk failed requests. Advanced features include bulk operations untuk efisiensi, data pagination untuk large datasets, dan caching strategies untuk improved performance. AI digunakan untuk review architecture design dan suggesting optimal sync patterns.

### **Pertemuan 11: Advanced State Management**
- **Materi**: BLoC/Riverpod patterns, Scalable architecture, **CAPSTONE:** State management refactoring
- **Sub-CPMK**: Sub-CPMK53.2
- **Kemampuan Akhir**: Mampu mengintegrasikan data persistence dan API eksternal dalam aplikasi mobile
- **Indikator**: State management architecture implementation
- **Bentuk Pembelajaran**: Kuliah, Praktikum
- **Metode**: Pembelajaran Berbasis Proyek
- **Tugas**: Advanced state management implementation
- **AI Integration**: AI untuk architecture validation
- **Praktikum**: Mahasiswa melakukan refactoring StudyTracker dari simple setState() ke advanced state management menggunakan Provider pattern atau BLoC pattern untuk scalable architecture. Architecture redesign session dimulai dengan analysis current state management limitations, identification of pain points (duplicate state, prop drilling, complex updates), dan design of new architecture dengan clear separation of concerns. Praktikum mencakup implementasi TaskProvider dengan ChangeNotifier untuk reactive state updates, AuthProvider untuk user session management, dan SyncProvider untuk background operations. Mahasiswa belajar state persistence across app lifecycle, state restoration after app restart, dan complex state interactions between different providers. Advanced topics include state optimization dengan Selector widgets, lazy loading untuk improved performance, dan implementing undo/redo functionality untuk task operations. AI digunakan untuk validate architecture decisions dan suggest improvements untuk maintainability.

### **Pertemuan 12: Testing & Quality Assurance**
- **Materi**: Unit, widget, integration testing, TDD practices, **CAPSTONE:** Testing implementation
- **Sub-CPMK**: Sub-CPMK92.2
- **Kemampuan Akhir**: Mampu mengimplementasikan fitur-fitur platform spesifik dan testing yang komprehensif
- **Indikator**: Testing strategy dan quality assurance
- **Bentuk Pembelajaran**: Praktikum, Responsi
- **Metode**: Pembelajaran Berbasis Proyek
- **Tugas**: Comprehensive testing suite
- **AI Integration**: AI untuk test generation assistance
- **Praktikum**: Mahasiswa mengimplementasikan comprehensive testing strategy untuk StudyTracker menggunakan Flutter testing framework. TDD workshop dimulai dengan writing failing tests terlebih dahulu, kemudian implement code untuk make tests pass, dan refactor untuk code quality. Praktikum mencakup unit testing untuk model classes (Task class methods, validation logic, serialization), business logic (task filtering, sorting, search algorithms), dan service classes (API calls, database operations). Widget testing fokus pada UI components behavior, user interactions (tap, scroll, input), dan state changes verification. Integration testing untuk end-to-end workflows seperti complete task creation flow dari form input sampai database storage dan UI update. Mahasiswa juga belajar mock objects untuk isolating dependencies, test coverage analysis untuk ensuring comprehensive testing, dan automated testing setup untuk CI/CD. AI assistance digunakan untuk generating test cases dan identifying edge cases yang mungkin terlewat.

### **Pertemuan 13: Platform Features & Device Integration**
- **Materi**: Camera, location, sensors, Platform channels, **CAPSTONE:** Platform features enhancement
- **Sub-CPMK**: Sub-CPMK92.2
- **Kemampuan Akhir**: Mampu mengimplementasikan fitur-fitur platform spesifik dan testing yang komprehensif
- **Indikator**: Platform-specific features implementation
- **Bentuk Pembelajaran**: Praktikum, Responsi
- **Metode**: Pembelajaran Berbasis Proyek
- **Tugas**: Native features integration
- **AI Integration**: Free AI dengan documentation
- **Praktikum**: Mahasiswa mengintegrasikan StudyTracker dengan platform-specific features menggunakan camera untuk task documentation dan GPS location untuk study session tracking. Platform integration workshop mencakup permission handling untuk camera dan location access, implementasi image_picker untuk capturing task progress photos, dan geolocator untuk current location detection saat completing assignments. Praktikum fokus pada photo management workflow: capture/select image, compress untuk storage efficiency, upload ke Supabase storage, dan display dalam photo gallery. Location features include automatic location capture when marking task complete, location-based task suggestions, dan study location history tracking. Mahasiswa juga belajar handling different platform behaviors (Android vs iOS), error cases (permission denied, camera unavailable), dan user experience optimization (loading states, progress indicators). Advanced topics include background location updates, geofencing untuk location-based reminders, dan photo metadata extraction. AI assistance dengan full access untuk documentation review dan implementation guidance.

### **Pertemuan 14: Performance Optimization & Production Prep**
- **Materi**: DevTools profiling, Build optimization, **CAPSTONE:** Performance tuning
- **Sub-CPMK**: Sub-CPMK53.2
- **Kemampuan Akhir**: Mampu mengoptimalkan performa aplikasi dan menyiapkan aplikasi untuk deployment
- **Indikator**: Performance optimization dan production readiness
- **Bentuk Pembelajaran**: Kuliah, Praktikum
- **Metode**: Pembelajaran Berbasis Proyek
- **Tugas**: Performance tuning & optimization
- **AI Integration**: AI untuk performance analysis
- **Praktikum**: Mahasiswa mengoptimalkan StudyTracker performance menggunakan Flutter DevTools untuk profiling dan identifying bottlenecks. Performance optimization workshop mencakup memory management analysis, widget rebuild optimization dengan const constructors dan key management, image loading optimization dengan caching strategies, dan database query optimization untuk faster data retrieval. Praktikum fokus pada ListView optimization dengan itemExtent dan cacheExtent untuk large datasets, implementing lazy loading untuk photos dan large content, dan minimizing unnecessary widget rebuilds dengan proper Provider usage. Build optimization includes asset bundling, code splitting, dan tree shaking untuk reduced APK size. Mahasiswa juga belajar performance monitoring dengan real device testing, battery usage optimization, dan network request optimization dengan request batching dan caching. Production preparation mencakup code obfuscation, removing debug prints, dan implementing proper error reporting untuk production environment. AI digunakan untuk analyzing performance metrics dan suggesting specific optimizations.

### **Pertemuan 15: Deployment & Distribution Strategies**
- **Materi**: App store guidelines, Release management, **CAPSTONE:** Deployment preparation
- **Sub-CPMK**: Sub-CPMK53.2
- **Kemampuan Akhir**: Mampu mengoptimalkan performa aplikasi dan menyiapkan aplikasi untuk deployment
- **Indikator**: Deployment strategy dan distribution
- **Bentuk Pembelajaran**: Kuliah, Praktikum
- **Metode**: Pembelajaran Berbasis Proyek
- **Tugas**: Store submission preparation
- **AI Integration**: AI untuk documentation generation
- **Praktikum**: Mahasiswa mempersiapkan StudyTracker untuk deployment dengan mempelajari app store guidelines, creating release builds, dan documentation untuk distribution. Deployment preparation workshop mencakup Android App Bundle generation untuk Google Play Store, APK signing dengan release keystore, dan app store listing optimization dengan screenshots, descriptions, dan metadata. Praktikum fokus pada release checklist: version numbering, changelog documentation, privacy policy creation untuk data collection compliance, dan security audit untuk sensitive data handling. Mahasiswa juga belajar gradual rollout strategies, beta testing setup dengan internal testers, dan monitoring post-deployment dengan crash analytics dan user feedback. Documentation preparation includes technical architecture documentation, user manual creation, dan API documentation untuk backend integration. Final presentation preparation mencakup demo script, technical explanation, dan project reflection for portfolio purposes. AI assistance untuk generating comprehensive documentation, creating user guides, dan preparing presentation materials for professional portfolio showcase.

### **UJIAN AKHIR SEMESTER**
- **Format**: Project presentation (20 menit), Technical demo & code review, Comprehensive Q&A session
- **Evaluasi**: Evaluasi komprehensif semua Sub-CPMK
- **Indikator**: Comprehensive evaluation seluruh kemampuan mobile development
- **Format**: Final project presentation + technical demo + Q&A

---

## ASSESSMENT BREAKDOWN SEMESTER

### **Continuous Assessment (60%)**
- **Capstone Project Development:** 40%
  - Weekly incremental deliverables
  - Code quality dan architecture
  - Feature implementation progress
- **Weekly Assignments:** 15%
  - Individual coding tasks
  - AI integration documentation
- **Peer Code Review Participation:** 5%
  - Quality of reviews given
  - Response to feedback received

### **Major Assessments (40%)**
- **UTS (Ujian Tengah Semester):** 15%
  - Live coding examination
  - Project progress presentation
- **UAS (Final Project Presentation):** 20%
  - Complete application demonstration
  - Technical interview
  - Documentation quality
- **AI Integration Portfolio:** 5%
  - Documentation of AI tool usage
  - Critical analysis of AI suggestions
  - Learning reflection

### **Grading Scale:**
- **A (85-100):** Excellent project dengan innovation, superior code quality
- **B (75-84):** Good project dengan solid implementation, good practices
- **C (65-74):** Adequate project dengan basic requirements met
- **D (55-64):** Below average, major features missing atau poor quality
- **E (<55):** Fail, project tidak functional atau tidak complete

---

## CAPSTONE PROJECT DOMAINS

Mahasiswa memilih salah satu domain untuk dikembangkan sepanjang semester:

### **1. Local Business Solutions**
- Warung/Restaurant ordering system
- Local marketplace platform
- Service booking application
- Inventory management system

### **2. Educational Technology**
- Learning management system
- Skill assessment platform
- Educational content delivery
- Student productivity tools

### **3. Health & Wellness**
- Personal health tracking
- Telemedicine support system
- Fitness and nutrition tracker
- Mental health support app

---

## AI INTEGRATION STRATEGY

### **Progressive AI Limitation Timeline:**

**Weeks 1-4 (Learning Phase):**
- AI digunakan untuk syntax help dan concept explanation
- Mandatory: Mahasiswa harus memahami setiap AI suggestion
- Assessment: Quiz tentang pemahaman konsep yang di-generate AI

**Weeks 5-8 (Restriction Phase):**
- AI hanya untuk debugging assistance
- Core logic harus ditulis manual
- Assessment: Code review untuk memastikan original thinking

**Weeks 9-12 (Optimization Phase):**
- AI untuk optimization dan architecture feedback
- Mahasiswa design arsitektur sendiri dulu
- Assessment: Architecture decision documentation

**Weeks 13-16 (Integration Phase):**
- Free AI usage dengan mandatory documentation
- Setiap AI interaction harus didokumentasikan
- Assessment: AI usage reflection dan learning portfolio

### **Methodology Implementation:**

**Generate-Analyze-Improve:**
1. AI generates initial code solution
2. Mahasiswa analyze untuk understand logic
3. Manual improvement dengan explanation

**Error-First Learning:**
1. Intentionally broken code diberikan
2. Debug process menggunakan AI assistance
3. Explanation of root cause dan solution

**Peer Code Review:**
1. Code review sessions dengan AI tools
2. Discussion tentang code quality
3. Collaborative improvement suggestions

---

## PEMBELAJARAN BERBASIS PROYEK (PjBL)

### **Incremental Development Strategy:**
- **Week 4:** Project proposal dan basic structure
- **Week 5-6:** Foundation development (UI, navigation)
- **Week 7-8:** Data layer implementation
- **Week 9-10:** API integration dan advanced features
- **Week 11-12:** Platform features dan testing
- **Week 13-14:** Performance optimization dan deployment
- **Week 15-16:** Documentation dan final presentation

### **Quality Gates:**
Setiap 2 minggu ada checkpoint untuk memastikan:
- Code quality standards terpenuhi
- Architecture decisions terdokumentasi
- Progress sesuai timeline
- AI usage properly documented

### **Industry Relevance:**
- Project requirements disesuaikan dengan industry needs
- Guest lectures dari industry practitioners
- Portfolio development untuk job applications
- Real-world deployment experience
