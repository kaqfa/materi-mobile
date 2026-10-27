import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hris_mini/main.dart';

void main() {
  testWidgets('HRIS menampilkan daftar dan membuka detail pengajuan',
      (tester) async {
    await tester.pumpWidget(const HrisApp());
    expect(find.text('Budi Santoso'), findsOneWidget);

    await tester.tap(find.text('Budi Santoso'));
    await tester.pumpAndSettle();

    expect(find.text('Detail Pengajuan'), findsOneWidget);
    expect(find.text('Total 5 hari'), findsOneWidget);
  });

  testWidgets('Menyetujui pengajuan memperbarui status di daftar',
      (tester) async {
    await tester.pumpWidget(const HrisApp());
    await tester.tap(find.text('Budi Santoso'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Setujui'));
    await tester.pumpAndSettle();

    // Kembali ke daftar: filter "Disetujui" hanya menampilkan Budi (r1)
    // di antara pengajuan yang tadinya menunggu.
    await tester.tap(find.text('Disetujui').first);
    await tester.pumpAndSettle();
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Eko Prasetyo'), findsNothing);
  });

  testWidgets('Menolak pengajuan mengubah status menjadi Ditolak',
      (tester) async {
    await tester.pumpWidget(const HrisApp());

    // Eko ada di bawah fold — scroll dulu sampai kartunya terlihat.
    await tester.scrollUntilVisible(
      find.text('Eko Prasetyo'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.text('Eko Prasetyo'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tolak'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ditolak').first);
    await tester.pumpAndSettle();
    expect(find.text('Eko Prasetyo'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsNothing);
  });

  testWidgets('Aksi hanya tersedia untuk pengajuan Menunggu', (tester) async {
    await tester.pumpWidget(const HrisApp());

    // Siti sudah Disetujui → tidak ada tombol aksi.
    await tester.tap(find.text('Siti Aminah'));
    await tester.pumpAndSettle();
    expect(find.text('Setujui'), findsNothing);
    expect(find.text('Tolak'), findsNothing);
  });

  testWidgets('Filter status dan tipe bisa dikombinasikan (AND)',
      (tester) async {
    await tester.pumpWidget(const HrisApp());

    await tester.tap(find.text('Menunggu').first);
    await tester.pumpAndSettle();
    expect(find.text('Andi Wijaya'), findsNothing);

    await tester.tap(find.text('Cuti Tahunan').first);
    await tester.pumpAndSettle();
    // Hanya pengajuan Menunggu DAN Cuti Tahunan: Budi & Dewi.
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Dewi Lestari'), findsOneWidget);
    expect(find.text('Eko Prasetyo'), findsNothing);
    expect(find.text('Tono'), findsNothing);
  });

  testWidgets('Kombinasi tanpa hasil menampilkan empty state', (tester) async {
    await tester.pumpWidget(const HrisApp());

    await tester.tap(find.text('Ditolak').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sakit'));
    await tester.pumpAndSettle();

    expect(find.text('Tidak ada pengajuan'), findsOneWidget);
  });
}
