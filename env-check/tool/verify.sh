#!/usr/bin/env bash
# Verifikasi lingkungan pengembangan Flutter untuk mata kuliah Pemrograman
# Mobile. Jalankan dari akar proyek: bash tool/verify.sh
#
# Skrip ini memeriksa apa yang bisa diperiksa tanpa perangkat. Lapisan
# terakhir, yaitu plugin platform yang sungguhan, hanya bisa dibuktikan oleh
# `flutter test integration_test/` di emulator atau perangkat fisik.

set -uo pipefail

GAGAL=0
LEWAT=0

biru='\033[0;34m'; hijau='\033[0;32m'; merah='\033[0;31m'
kuning='\033[0;33m'; netral='\033[0m'

judul()  { printf "\n${biru}== %s ==${netral}\n" "$1"; }
lolos()  { printf "${hijau}  OK${netral}    %s\n" "$1"; LEWAT=$((LEWAT+1)); }
gagal()  { printf "${merah}  GAGAL${netral} %s\n" "$1"; GAGAL=$((GAGAL+1)); }
catat()  { printf "${kuning}  CATATAN${netral} %s\n" "$1"; }

judul "Toolchain"

if ! command -v flutter >/dev/null 2>&1; then
  gagal "flutter tidak ada di PATH. Pasang Flutter stable lebih dulu: https://docs.flutter.dev/get-started/install"
  printf "\n${merah}Verifikasi berhenti: tanpa Flutter tidak ada yang bisa diperiksa.${netral}\n"
  exit 1
fi
lolos "flutter ditemukan di $(command -v flutter)"

VERSI_BARIS="$(flutter --version 2>/dev/null | head -1)"
printf "        %s\n" "$VERSI_BARIS"

# Baseline buku: Flutter stable 3.47.x. Versi lebih baru umumnya aman;
# versi lebih lama berisiko pada Material 3 dan template Gradle Kotlin DSL.
FLUTTER_VER="$(printf '%s' "$VERSI_BARIS" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
MAJOR="${FLUTTER_VER%%.*}"
SISA="${FLUTTER_VER#*.}"
MINOR="${SISA%%.*}"
if [ -n "$FLUTTER_VER" ]; then
  if [ "$MAJOR" -gt 3 ] || { [ "$MAJOR" -eq 3 ] && [ "$MINOR" -ge 47 ]; }; then
    lolos "versi Flutter $FLUTTER_VER memenuhi baseline buku (>= 3.47)"
  else
    gagal "versi Flutter $FLUTTER_VER di bawah baseline buku 3.47. Jalankan: flutter upgrade"
  fi
else
  catat "versi Flutter tidak terbaca dari keluaran --version"
fi

if flutter --version 2>/dev/null | grep -q "channel stable"; then
  lolos "berada di channel stable"
else
  catat "bukan channel stable. Disarankan: flutter channel stable && flutter upgrade"
fi

judul "flutter doctor"
DOCTOR="$(flutter doctor 2>&1)"
printf '%s\n' "$DOCTOR" | sed 's/^/        /'

if printf '%s' "$DOCTOR" | grep -q "\[✓\] Flutter"; then
  lolos "Flutter SDK sehat menurut doctor"
else
  gagal "doctor melaporkan masalah pada Flutter SDK itu sendiri"
fi

if printf '%s' "$DOCTOR" | grep -qE "\[✓\] Android toolchain"; then
  lolos "Android toolchain lengkap"
elif printf '%s' "$DOCTOR" | grep -qE "Android (toolchain|Studio)"; then
  gagal "Android toolchain belum lengkap. Tanpa ini bab 4, 12, dan 14 tidak bisa dikerjakan. Lihat keluaran doctor di atas, dan jalankan: flutter doctor --android-licenses"
else
  gagal "Android toolchain tidak terdeteksi sama sekali"
fi

judul "Dependensi proyek"
if flutter pub get >/tmp/envcheck-pubget.log 2>&1; then
  lolos "flutter pub get berhasil: semua paket bab 1-14 saling kompatibel"
else
  gagal "flutter pub get gagal. Ini berarti ada konflik versi paket:"
  sed 's/^/        /' /tmp/envcheck-pubget.log
fi

if flutter pub outdated >/tmp/envcheck-outdated.log 2>&1; then
  catat "ringkasan paket yang bisa diperbarui ada di /tmp/envcheck-outdated.log"
fi

judul "Analisis statis"
if flutter analyze >/tmp/envcheck-analyze.log 2>&1; then
  lolos "flutter analyze bersih"
else
  gagal "flutter analyze menemukan masalah:"
  sed 's/^/        /' /tmp/envcheck-analyze.log
fi

judul "Unit dan widget test (host, tanpa perangkat)"
if flutter test >/tmp/envcheck-test.log 2>&1; then
  lolos "seluruh test di test/ lolos, termasuk sqflite via FFI dan preferences in-memory"
else
  gagal "ada test yang gagal:"
  sed 's/^/        /' /tmp/envcheck-test.log
fi

judul "Perangkat"
PERANGKAT="$(flutter devices 2>&1)"
printf '%s\n' "$PERANGKAT" | sed 's/^/        /'

if printf '%s' "$PERANGKAT" | grep -qiE "android"; then
  lolos "ada perangkat/emulator Android terhubung"
  catat "lanjutkan dengan: flutter test integration_test/"
  catat "lalu jalankan aplikasinya: flutter run"
else
  catat "tidak ada perangkat Android aktif. Unit test sudah membuktikan paket-paketnya sehat, tetapi plugin platform (secure storage, image_picker, geolocator) baru terbukti setelah integration test berjalan di emulator atau perangkat fisik."
  catat "nyalakan emulator dengan: flutter emulators --launch <id>"
fi

judul "Ringkasan"
printf "  %d pemeriksaan lolos, %d gagal\n" "$LEWAT" "$GAGAL"
if [ "$GAGAL" -eq 0 ]; then
  printf "${hijau}  Lingkungan siap. Langkah terakhir: jalankan integration test di perangkat.${netral}\n"
  exit 0
else
  printf "${merah}  Perbaiki item GAGAL di atas sebelum memulai perkuliahan.${netral}\n"
  exit 1
fi
