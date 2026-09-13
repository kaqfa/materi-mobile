import 'dart:io';

import 'package:flutter/material.dart';

import '../services/location_service.dart';
import '../services/photo_service.dart';

/// Latihan fitur perangkat: lampirkan foto progres + catat lokasi
/// saat menyelesaikan sesi belajar.
class AttachmentScreen extends StatefulWidget {
  const AttachmentScreen({super.key});

  @override
  State<AttachmentScreen> createState() => _AttachmentScreenState();
}

class _AttachmentScreenState extends State<AttachmentScreen> {
  final _photos = PhotoService();
  final _location = LocationService();

  File? _photo;
  String? _locationText;
  bool _busy = false;

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _takePhoto(bool fromCamera) async {
    setState(() => _busy = true);
    try {
      final file = fromCamera ? await _photos.capture() : await _photos.pickFromGallery();
      if (file != null) setState(() => _photo = file);
    } on Exception catch (e) {
      // Kamera tidak tersedia / izin ditolak OS.
      _snack('Gagal membuka ${fromCamera ? "kamera" : "galeri"}: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _completeWithLocation() async {
    setState(() => _busy = true);
    try {
      final pos = await _location.getCurrentLocation();
      setState(() => _locationText =
          'Lokasi: ${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}');
    } on LocationException catch (e) {
      _snack(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StudyTracker — Device Features')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: _busy ? null : () => _takePhoto(true),
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Kamera'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: _busy ? null : () => _takePhoto(false),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galeri'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_photo != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_photo!, height: 220, fit: BoxFit.cover),
            )
          else
            const Card(
              child: SizedBox(
                height: 120,
                child: Center(child: Text('Belum ada foto progres')),
              ),
            ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _busy ? null : _completeWithLocation,
            icon: const Icon(Icons.location_on),
            label: const Text('Selesaikan sesi + catat lokasi'),
          ),
          if (_locationText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_locationText!),
            ),
          if (_busy) const LinearProgressIndicator(),
        ],
      ),
    );
  }
}
