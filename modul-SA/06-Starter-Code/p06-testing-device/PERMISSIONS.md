# PERMISSIONS, P06 Device Feature (Image Picker)

> Catatan izin untuk fitur image picker (camera + gallery fallback). Mahasiswa
> menambahkan ini ke platform runner hasil `flutter create`. **Jangan commit
> secret apa pun**; ini hanya deklarasi izin OS, bukan kredensial.

## Android (`android/app/src/main/AndroidManifest.xml`)

Tambah di dalam `<manifest>`, sebelum `<application>`:

```xml
<!-- Galeri: cukup untuk gallery picker + fallback (wajib). -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<!-- Android 12 ke bawah (fallback bila READ_MEDIA_IMAGES tidak dikenali). -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
 android:maxSdkVersion="32" />

<!-- Kamera: opsional. Hanya bila mau jalur camera. Lewati bila emulator
 tanpa kamera -> otomatis jatuh ke cabang AttachmentUnavailable. -->
<uses-feature android:name="android.hardware.camera" android:required="false" />
<uses-permission android:name="android.permission.CAMERA" />
```

> **Fallback default:** bila device/emulator tidak punya kamera, starter tetap
> sah dengan **gallery picker saja** (`READ_MEDIA_IMAGES`). Cabang
> `AttachmentUnavailable` di `ImagePickerAttachmentService` menangani kasus
> kamera absen tanpa crash. Itu memenuhi acceptance "device unavailable /
> permission denied fallback".

## iOS (`ios/Runner/Info.plist`), opsional, di luar scope wajib

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>App perlu akses galeri untuk melampirkan foto ke tugas.</string>
<key>NSCameraUsageDescription</key>
<string>App perlu kamera untuk memotret lampiran tugas.</string>
```

> iOS release dikecualikan di planning §2 (scope wajib: Android + test).
> Disertakan hanya sebagai referensi bila dosen membuka jalur iOS.

## Alur izin saat runtime

1. Mahasiswa tekan **Pick photo** -> provider panggil `AttachmentService`.
2. Plugin `image_picker` meminta izin OS (Android 13+: `READ_MEDIA_IMAGES`).
3. **User setujui** -> `AttachmentSuccess(path)` -> banner "Attached: …".
4. **User tolak** -> `PlatformException` -> `AttachmentDenied` -> banner "Izin … ditolak" (bukan crash).
5. **Emulator tanpa kamera** / galeri kosong -> `null` return -> `AttachmentUnavailable` -> banner "tidak tersedia".

Semua cabang diuji tanpa perangkat lewat `LocalAttachmentService` (unit test hijau).
