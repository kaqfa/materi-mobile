import 'package:flutter_test/flutter_test.dart';
import 'package:p06_testing_device/features/attachments/attachment_service.dart';

/// Unit test target #3 (device fallback): [LocalAttachmentService] membuktikan
/// cabang device-unavailable & permission-denied bisa diuji tanpa perangkat
/// (acceptance criteria P06).
void main() {
  test('success -> AttachmentSuccess dengan path', () async {
    final svc = LocalAttachmentService();
    final result = await svc.pickFromGallery();
    expect(result, isA<AttachmentSuccess>());
    expect((result as AttachmentSuccess).path, startsWith('local://'));
  });

  test('device unavailable -> AttachmentUnavailable', () async {
    final svc = LocalAttachmentService(
      cameraBehavior: AttachmentScenario.unavailable,
    );
    final result = await svc.pickFromCamera();
    expect(result, isA<AttachmentUnavailable>());
  });

  test('permission denied -> AttachmentDenied', () async {
    final svc = LocalAttachmentService(
      galleryBehavior: AttachmentScenario.denied,
    );
    final result = await svc.pickFromGallery();
    expect(result, isA<AttachmentDenied>());
  });

  test('switch exhaustif atas AttachmentResult (sealed)', () {
    String describe(AttachmentResult r) => switch (r) {
          AttachmentSuccess() => 'ok',
          AttachmentUnavailable() => 'unavailable',
          AttachmentDenied() => 'denied',
        };
    expect(describe(const AttachmentSuccess('x')), 'ok');
    expect(describe(const AttachmentUnavailable()), 'unavailable');
    expect(describe(const AttachmentDenied()), 'denied');
  });
}
